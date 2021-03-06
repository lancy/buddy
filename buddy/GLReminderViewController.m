//
//  GLReminderViewController.m
//  buddy
//
//  Created by Lancy on 10/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLReminderViewController.h"
#import "GLReminderManager.h"
#import "GLUserAgent.h"
#import "GLReminderCell.h"
#import <AVFoundation/AVFoundation.h>
#import "GLReminder.h"
#import "MBProgressHUD.h"


@interface GLReminderViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSArray *reminders;

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVAudioPlayer *audioplayer;
@end

@implementation GLReminderViewController

- (NSString *)tabImageName
{
	return @"tabbar_item2.png";
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customUserinterface];
	// Do any additional setup after loading the view.
    
    [self registerNotificationHandler];
    [self loadRemidnersData];
}


- (void) viewDidAppear:(BOOL)animated{
    NSString *soundFilePath =[[NSBundle mainBundle] pathForResource: @"reminder_cn" ofType: @"aac"];
    NSURL *url=[NSURL fileURLWithPath:soundFilePath];
    self.audioplayer=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    if(![[GLUserAgent sharedAgent] getAudioNavigationDisabledStatus]){
        [[self audioplayer] prepareToPlay];
        [[self audioplayer] play];
    }
    
}

- (void) viewDidDisappear:(BOOL)animated {
    [[self audioplayer] stop];
}

- (void)registerNotificationHandler
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRemidnersData) name:LocalRemindersDidChangedNotification object:nil];
}

- (void)loadRemidnersData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[GLUserAgent sharedAgent] requestRemindsWithCompletedBlock:^(APIStatusCode statusCode, NSArray *reminds, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.reminders = reminds;
        [self setupTableViewWithReminders:self.reminders];
    }];
}

- (void)setupTableViewWithReminders:(NSArray *)reminders
{
    _manager = [[RETableViewManager alloc] initWithTableView:self.tableview];
    [_manager registerClass:@"GLReminderItem" forCellWithReuseIdentifier:@"GLReminderCell"];
    
    RETableViewSection *section = [RETableViewSection section];
    for (GLReminder *reminder in reminders) {
        GLReminderItem *item = [[GLReminderItem alloc] initWithReminder:reminder];
        [item setSelectionHandler:^(GLReminderItem *item) {
            [item deselectRowAnimated:YES];
            GLReminder *reminder = item.reminder;
            if (reminder.audioFileUrl) {
                NSURL *url = [NSURL URLWithString:reminder.audioFileUrl];
                AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:item];
                [self.player play];
            } else if (reminder.audioFilePath) {
                self.player = [[AVPlayer alloc] initWithURL:[NSURL fileURLWithPath:reminder.audioFilePath]];
                [self.player play];
            }
        }];
        [section addItem:item];
    }
    [_manager addSection:section];
    [_tableview reloadData];
}

- (void)customUserinterface
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"viewcontroller_bg"]]];
}

#pragma mark - View Methods
- (void)didTapPlusButton:(id)sender
{
    [self performSegueWithIdentifier:@"ShowAudioRecordView" sender:self];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
