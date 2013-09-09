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
@interface GLMessageViewController () <MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) NSArray *buddys;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

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

- (void)customUserinterface
{
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
        GLMessageItem *item = [[GLMessageItem alloc] initWithBuddy:buddy];
        [item setSelectionHandler:^(GLMessageItem *item) {
            [item deselectRowAnimated:YES];
            GLBuddy *buddy = item.buddy;
            [[GLUserAgent sharedAgent] requestSendMissToRelativeWithPhoneNumber:buddy.phoneNumber completed:^(APIStatusCode statusCode, NSError *error) {
                    NSLog(@"statusCode = %d", statusCode);
            }];
//            NSString *cleanedString = [[buddy.phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
//            
//            if ([MFMessageComposeViewController canSendText]) {
//                MFMessageComposeViewController *messageComposer =
//                [[MFMessageComposeViewController alloc] init];
//                NSString *message = NSLocalizedString(@"I miss you dear, call me if you have time.", nil);
//                [messageComposer setRecipients:@[cleanedString]];
//                [messageComposer setBody:message];
//                messageComposer.messageComposeDelegate = self;
//                [self presentViewController:messageComposer animated:YES completion:nil];
//            } else {
//#warning DOTO: exception handle;
//            }
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
        // give current buddy a red heart
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
