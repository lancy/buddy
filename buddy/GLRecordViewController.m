//
//  GLRecordViewController.m
//  buddy
//
//  Created by Lancy on 12/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLRecordViewController.h"
#import "GLAudioManager.h"

@interface GLRecordViewController ()
@property (strong, nonatomic) GLAudioManager *audioManager;

@end

@implementation GLRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.audioManager = [[GLAudioManager alloc] init];

}
- (IBAction)didTapRecordButton:(id)sender {
    [self.audioManager startRecord];
}
- (IBAction)didTapStopButton:(id)sender {
    [self.audioManager stopRecord];
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
