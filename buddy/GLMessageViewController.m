//
//  GLMessageViewController.m
//  buddy
//
//  Created by Lancy on 10/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "GLMessageViewController.h"
#import "GLBuddyManager.h"
#import "GLMessageCell.h"
#import "GLBuddy.h"
#import "GLMessageItem.h"
#import "GLUserAgent.h"
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"
@interface GLMessageViewController () <MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) NSArray *buddys;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) AVAudioPlayer *audioplayer;

@end

@implementation GLMessageViewController

- (NSString *)tabImageName
{
	return @"tabbar_item3.png";
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadBuddyData];
    [self registerNotificationHandler];
    [self customUserinterface];
}

- (void) viewDidAppear:(BOOL)animated{
    NSString *soundFilePath =[[NSBundle mainBundle] pathForResource: @"missu_cn" ofType: @"aac"];
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



- (void)customUserinterface
{
    [self setTitle:@"思念"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"viewcontroller_bg"]]];
}

#pragma mark - data methods

- (void)registerNotificationHandler
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadBuddyData) name:BuddysDidChangedNotification object:nil];
}

- (void)loadBuddyData
{
    self.buddys = [[GLBuddyManager shareManager] remotesBuddys];
    [self setupTableViewWithBuddys:self.buddys];
}

- (void)setupTableViewWithBuddys:(NSArray *)buddys;
{
    _manager = [[RETableViewManager alloc] initWithTableView:self.tableview];
    [_manager registerClass:@"GLMessageItem" forCellWithReuseIdentifier:@"GLMessageCell"];
    
    
    RETableViewSection *section = [RETableViewSection section];
    for (GLBuddy *buddy in buddys) {
        __block GLMessageItem *item = [[GLMessageItem alloc] initWithBuddy:buddy];
        [item setSelectionHandler:^(GLMessageItem *item) {
            [item deselectRowAnimated:YES];
            GLBuddy *buddy = item.buddy;
            if ([item isSent] == NO) {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [[GLUserAgent sharedAgent] requestSendMissToRelativeWithPhoneNumber:buddy.phoneNumber completed:^(APIStatusCode statusCode, NSError *error) {
                    NSLog(@"statusCode = %d", statusCode);
                    if (statusCode == APIStatusCodeOK) {
                        MBProgressHUD *hub = [MBProgressHUD HUDForView:self.view];
                        [hub setMode:MBProgressHUDModeText];
                        [hub setLabelText:@"思念发送成功"];
                        [hub hide:YES afterDelay:1.0];
                        [[GLUserAgent sharedAgent] requestRecordWithPhoneNumber:buddy.phoneNumber recordType:GLRecordTypeMISS];
                        [item setIsSent:YES];
                        [item reloadRowWithAnimation:UITableViewRowAnimationAutomatic];
                    }
                }];
            }
        }];
        [section addItem:item];
    }
    [_manager addSection:section];
    [_tableview reloadData];
}

#pragma mark - message delegate methods

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    if (result == MessageComposeResultFailed) {
        #warning TOTO exception handler
        NSLog(@"Message compose failed");
    } else if (result == MessageComposeResultCancelled) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (result == MessageComposeResultSent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
