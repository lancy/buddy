//
//  GLReminderSettingViewController.h
//  buddy
//
//  Created by Lancy on 14/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLAudioManager.h"
#import "GLBuddy.h"

@interface GLReminderSettingViewController : UIViewController

@property (strong, nonatomic) GLBuddy *selectedBuddy;
@property (strong, nonatomic) GLAudioManager *audioManager;

@end
