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

@interface GLRecordViewController ()
@property (strong, nonatomic) GLAudioManager *audioManager;
@property (strong, nonatomic) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *powerLabel;
@property (strong, nonatomic) GLAudioPowerIndicatorView *powerIndicatorView;

@end

@implementation GLRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.audioManager = [[GLAudioManager alloc] init];
    
    self.powerIndicatorView = [[GLAudioPowerIndicatorView alloc] initWithFrame:CGRectMake(35, 300, 250, 250)];
    [self.view addSubview:self.powerIndicatorView];

}

- (void) timerUpdate
{
    if ([self.audioManager isRecording])
    {
        int m = self.audioManager.recorder.currentTime / 60;
        int s = ((int) self.audioManager.recorder.currentTime) % 60;
        int ss = (self.audioManager.recorder.currentTime - ((int) self.audioManager.recorder.currentTime)) * 100;
        
        self.timeLabel.text = [NSString stringWithFormat:@"%.2d:%.2d %.2d", m, s, ss];
        [self.powerLabel setText:[NSString stringWithFormat:@"%f", self.audioManager.micAveragePower]];
        [self.powerIndicatorView setPower:self.audioManager.micAveragePower];
    }
}

- (IBAction)didTapRecordButton:(id)sender {
    [self.audioManager startRecord];
    [self.powerIndicatorView startAnimation];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.1f
                                              target:self
                                            selector:@selector(timerUpdate)
                                            userInfo:nil
                                             repeats:YES];
}
- (IBAction)didTapStopButton:(id)sender {
    [self.audioManager stopRecord];
    [self.powerIndicatorView stopAnimation];
    [self.timer invalidate];
}
- (IBAction)didTapPlayButton:(id)sender {
    [self.audioManager playCurrentAudio];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
