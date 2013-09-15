//
//  GLRecordViewController.m
//  buddy
//
//  Created by Lancy on 12/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLRecordViewController.h"
#import "GLAudioManager.h"
#import "GLAudioPowerIndicatorView.h"
#import "MCProgressBarView.h"
#import "GLReminderSettingViewController.h"

@interface GLRecordViewController ()
@property (strong, nonatomic) GLAudioManager *audioManager;
@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *stateLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) UIButton *recordToggleButton;
@property (strong, nonatomic) GLAudioPowerIndicatorView *powerIndicatorView;
@property (strong, nonatomic) MCProgressBarView *progressBarView;

@property (assign, nonatomic, getter = isRecording) BOOL recording;

@end

@implementation GLRecordViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.audioManager = [[GLAudioManager alloc] init];
    [self setRecording:NO];
    [self initUserinterface];
}

- (void)initUserinterface
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"viewcontroller_bg"]]];
    
    UIBarButtonItem *cancleButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didTapCancleButton:)];
    [self.navigationItem setLeftBarButtonItem:cancleButton];
    
#warning TODO: auto layout
    self.powerIndicatorView = [[GLAudioPowerIndicatorView alloc] initWithFrame:CGRectMake(10, 250, 300, 300)];
    [self.view addSubview:self.powerIndicatorView];
    
    self.recordToggleButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 385, 80, 80)];
    [self.recordToggleButton addTarget:self action:@selector(didTapRecordToggleButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.recordToggleButton];
    
    UIImage * backgroundImage = [[UIImage imageNamed:@"progress_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    UIImage * foregroundImage = [[UIImage imageNamed:@"progress_fg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    self.progressBarView = [[MCProgressBarView alloc] initWithFrame:CGRectMake(25, 200, 270, 16)
                                                    backgroundImage:backgroundImage
                                                    foregroundImage:foregroundImage];
    [self.view addSubview:self.progressBarView];
    self.progressBarView.progress = 0;
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, 280, 32)];
    [self.timeLabel setTextColor:[UIColor grayColor]];
    [self.timeLabel setFont:[UIFont systemFontOfSize:18]];
    [self.timeLabel setTextAlignment:NSTextAlignmentCenter];
    [self.timeLabel setBackgroundColor:[UIColor clearColor]];
    [self.timeLabel setText:@"00:00 / 01:00"];
    
    self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 44)];
    [self.stateLabel setTextColor:[UIColor grayColor]];
    [self.stateLabel setFont:[UIFont systemFontOfSize:24]];
    [self.stateLabel setAdjustsFontSizeToFitWidth:YES];
    [self.stateLabel setBackgroundColor:[UIColor clearColor]];
    [self.stateLabel setText:NSLocalizedString(@"点击麦克风", nil)];
    
    self.descriptionLabel= [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 280, 44)];
    [self.descriptionLabel setTextColor:[UIColor grayColor]];
    [self.descriptionLabel setFont:[UIFont systemFontOfSize:16]];
    [self.descriptionLabel setNumberOfLines:2];
    [self.descriptionLabel setAdjustsFontSizeToFitWidth:YES];
    [self.descriptionLabel setBackgroundColor:[UIColor clearColor]];
    [self.descriptionLabel setText:NSLocalizedString(@"你最多可以录制一分钟的语音，再次点击麦克风来停止录音", nil)];

    [self.view addSubview:self.timeLabel];
    [self.view addSubview:self.stateLabel];
    [self.view addSubview:self.descriptionLabel];
}


- (void) timerUpdate
{
    if ([self.audioManager isRecording])
    {
        int m = self.audioManager.recorder.currentTime / 60;
        int s = ((int) self.audioManager.recorder.currentTime) % 60;
        int ss = (self.audioManager.recorder.currentTime - ((int) self.audioManager.recorder.currentTime)) * 100;
        
        NSMutableString *recordingString = [NSLocalizedString(@"录音中.", nil) mutableCopy];
        if (s % 3 == 0) {
            [recordingString appendString:@"."];
        } else if (s % 3 == 1) {
            [recordingString appendString:@".."];
        }
        [self.stateLabel setText:recordingString];
        self.timeLabel.text = [NSString stringWithFormat:@"%.2d:%.2d / 01:00", m, s];
        [self.powerIndicatorView setPower:self.audioManager.micAveragePower];
        
        CGFloat progress;
        if (m > 0){
            progress = 1;
            [self stopRecroding];
            [self performSegueWithIdentifier:@"FinishedRecording" sender:self];
        } else {
            progress = (s + ss / 100.0) / 60.0;
        }
        [self.progressBarView setProgress:progress];
        
        
    }
}

- (void)didTapCancleButton:(id)sender
{
    if ([self isRecording]) {
        [self stopRecroding];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)stopRecroding
{
    [self setRecording:NO];
    [self.audioManager stopRecord];
    [self.stateLabel setText:NSLocalizedString(@"点击麦克风", nil)];
    [self.powerIndicatorView stopAnimation];
    [self.timer invalidate];
}

- (void)didTapRecordToggleButton:(id)sender {
    if (self.isRecording) {
        [self stopRecroding];
        [self performSegueWithIdentifier:@"FinishedRecording" sender:self];
    } else {
        [self setRecording:YES];
        [self.audioManager startRecord];
        [self.powerIndicatorView startAnimation];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:.01f
                                                      target:self
                                                    selector:@selector(timerUpdate)
                                                    userInfo:nil
                                                     repeats:YES];
    }    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"FinishedRecording"]) {
        [segue.destinationViewController setAudioManager:self.audioManager];
        [segue.destinationViewController setSelectedBuddy:_selectedBuddy];
    }
}

@end
