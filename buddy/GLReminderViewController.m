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

@interface GLReminderViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSArray *reminders;

@property (strong, nonatomic) AVAudioPlayer *player;

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

- (void)registerNotificationHandler
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRemidnersData) name:LocalRemindersDidChangedNotification object:nil];
}

- (void)loadRemidnersData
{
//    self.reminders = [[GLReminderManager shareManager] allLocalReminders];
    [[GLUserAgent sharedAgent] requestRemindsWithCompletedBlock:^(APIStatusCode statusCode, NSArray *reminds, NSError *error) {
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
                self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:reminder.audioFileUrl] error:nil];
                [self.player play];
            } else if (reminder.audioFilePath) {
                self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:reminder.audioFilePath] error:nil];
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
    
    UIBarButtonItem *plusBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didTapPlusButton:)];
    [self.navigationItem setRightBarButtonItem:plusBarButton];
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
