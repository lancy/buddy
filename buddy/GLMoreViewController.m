//
//  GLMoreViewController.m
//  buddy
//
//  Created by Lancy on 10/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLMoreViewController.h"
#import "GLChildBuddyViewController.h"
#import "GLUserAgent.h"
#import <AVFoundation/AVFoundation.h>

@interface GLMoreViewController ()
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *toggleButton;
@property (strong, nonatomic) AVAudioPlayer *audioplayer;

@end

@implementation GLMoreViewController

- (NSString *)tabImageName
{
	return @"tabbar_item4.png";
}

-(void) setButtonTitle{
    if([[GLUserAgent sharedAgent] getAudioNavigationDisabledStatus]){
        [self.toggleButton setTitle:@"开启语音导航" forState:0];
    }else{
        [self.toggleButton setTitle:@"关闭语音导航" forState:0];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"更多"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"viewcontroller_bg"]]];
    if (_isChild) {
        [self.toggleButton setHidden:YES];
    }
    if (IOS7_OR_LATER) {
        [self.logoutButton.layer setBorderColor:self.logoutButton.tintColor.CGColor];
        [self.logoutButton.layer setCornerRadius:4];
        [self.logoutButton.layer setBorderWidth:1];
        [self.toggleButton.layer setBorderColor:self.toggleButton.tintColor.CGColor];
        [self.toggleButton.layer setCornerRadius:4];
        [self.toggleButton.layer setBorderWidth:1];
    }
    [self setButtonTitle];
}

- (void)viewDidAppear:(BOOL)animated{
    if (_isChild == NO) {
        NSString *soundFilePath =[[NSBundle mainBundle] pathForResource: @"more_cn" ofType: @"aac"];
        NSURL *url=[NSURL fileURLWithPath:soundFilePath];
        self.audioplayer=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        if(![[GLUserAgent sharedAgent] getAudioNavigationDisabledStatus]){
            [[self audioplayer] prepareToPlay];
            [[self audioplayer] play];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [[self audioplayer] stop];
}

- (IBAction)didTapLogoutButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTaptoggleButton:(id)sender {
    BOOL nowStatus= ![[GLUserAgent sharedAgent] getAudioNavigationDisabledStatus];
    [[GLUserAgent sharedAgent] setAudioNavigationDisabledStatus:nowStatus];
    [self setButtonTitle];
    if (nowStatus == YES) {
        [self.audioplayer stop];
    }
}

@end
