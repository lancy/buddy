//
//  GLReminderSettingViewController.m
//  buddy
//
//  Created by Lancy on 14/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLReminderSettingViewController.h"
#import "MCProgressBarView.h"

@interface GLReminderSettingViewController ()

@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *stateLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) MCProgressBarView *progressBarView;
@property (weak, nonatomic) IBOutlet UIButton *playerButton;

@property (assign, nonatomic) NSTimeInterval audioDuration;
@property (strong, nonatomic) NSTimer *timer;


@end

@implementation GLReminderSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initUserinterface
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"viewcontroller_bg"]]];
    
    [self.playerButton setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:98.0/255.0 blue:70.0/255.0 alpha:1]];
    [self.playerButton.layer setCornerRadius:6];
    [self.playerButton.layer setMasksToBounds:YES];
    

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
    [self.audioManager prepareCurrentAudio];
    
    self.audioDuration = self.audioManager.player.duration;
    if (self.audioDuration == 60) {
        [self.timeLabel setText:@"00:00 / 01:00"];
    } else {
        [self.timeLabel setText:[NSString stringWithFormat:@"00:00 / 00:%.2d", (int)self.audioDuration]];
    }

    self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 44)];
    [self.stateLabel setTextColor:[UIColor grayColor]];
    [self.stateLabel setFont:[UIFont systemFontOfSize:24]];
    [self.stateLabel setAdjustsFontSizeToFitWidth:YES];
    [self.stateLabel setBackgroundColor:[UIColor clearColor]];
    [self.stateLabel setText:NSLocalizedString(@"Recording is finished", nil)];
    
    self.descriptionLabel= [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 280, 44)];
    [self.descriptionLabel setTextColor:[UIColor grayColor]];
    [self.descriptionLabel setFont:[UIFont systemFontOfSize:16]];
    [self.descriptionLabel setNumberOfLines:2];
    [self.descriptionLabel setAdjustsFontSizeToFitWidth:YES];
    [self.descriptionLabel setBackgroundColor:[UIColor clearColor]];
    [self.descriptionLabel setText:NSLocalizedString(@"You could listen the audio and set the alert time", nil)];
    
    [self.view addSubview:self.timeLabel];
    [self.view addSubview:self.stateLabel];
    [self.view addSubview:self.descriptionLabel];

    
}

- (void)timerUpdate
{
    if ([self.audioManager.player isPlaying])
    {
        int m = self.audioManager.player.currentTime / 60;
        int s = ((int) self.audioManager.player.currentTime) % 60;
        int ss = (self.audioManager.player.currentTime - ((int) self.audioManager.player.currentTime)) * 100;
        
        NSMutableString *recordingString = [NSLocalizedString(@"Playing.", nil) mutableCopy];
        if (s % 3 == 0) {
            [recordingString appendString:@"."];
        } else if (s % 3 == 1) {
            [recordingString appendString:@".."];
        }
        [self.stateLabel setText:recordingString];
        if (self.audioDuration == 60) {
            self.timeLabel.text = [NSString stringWithFormat:@"%.2d:%.2d / 01:00", m, s];
        } else {
            [self.timeLabel setText:[NSString stringWithFormat:@"%.2d:%.2d / 00:%.2d", m, s, (int)self.audioDuration]];
        }
    
        CGFloat progress = (s + ss / 100.0) / self.audioDuration;
        [self.progressBarView setProgress:progress];
    } else {
        [self.progressBarView setProgress:1];
        [self.stateLabel setText:NSLocalizedString(@"Recording is finished", nil)];
        [self.timer invalidate];
        [self.playerButton setHidden:NO];
    }

}

- (IBAction)didTapPlayButton:(id)sender {
    [self.audioManager playCurrentAudio];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.01f
                                                  target:self
                                                selector:@selector(timerUpdate)
                                                userInfo:nil
                                                 repeats:YES];
    [self.playerButton setHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initUserinterface];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
