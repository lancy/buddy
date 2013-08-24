//
//  GLChildBuddyViewController.m
//  buddy
//
//  Created by Lancy on 24/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "GLChildBuddyViewController.h"
#import "GLUserAgent.h"
#import "GLBuddy.h"
#import "GLChildBuddyCell.h"
#import "GLChildBuddyItem.h"
#import "GLDropDownCell.h"
#import "GLDropDownItem.h"

@interface GLChildBuddyViewController () <MFMessageComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation GLChildBuddyViewController {
    GLDropDownItem *_lastItem;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customUserinterface];
    [self requestRemoteBuddyData];
}

- (void)customUserinterface
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"viewcontroller_bg"]]];

}

- (void)requestRemoteBuddyData
{
    [[GLUserAgent sharedAgent] requestRelativesListWithCompletedBlock:^(NSArray *relatives, NSError *error) {
        NSLog(@"relatives = %@", relatives);
        [self setupTableViewWithBuddys:relatives];
    }];
}

- (void)setupTableViewWithBuddys:(NSArray *)buddys;
{
    _manager = [[RETableViewManager alloc] initWithTableView:_tableview];
    [_manager registerClass:@"GLChildBuddyItem" forCellWithReuseIdentifier:@"GLChildBuddyCell"];
    [_manager registerClass:@"GLDropDownItem" forCellWithReuseIdentifier:@"GLDropDownCell"];
    
    RETableViewSection *section = [RETableViewSection section];
    for (GLBuddy *buddy in buddys) {
        GLChildBuddyItem *item = [[GLChildBuddyItem alloc] initWithBuddy:buddy];
        [item setSelectionHandler:^(id item) {
            [section removeItem:_lastItem];
            GLChildBuddyItem *selectedItem = item;
            GLDropDownItem *dropDownItem = [[GLDropDownItem alloc] initWithBuddy:selectedItem.buddy];
            [section insertItem:dropDownItem atIndex:selectedItem.indexPath.row + 1];
            [self configureDropDownItem:dropDownItem];
            _lastItem = dropDownItem;
            [section reloadSectionWithAnimation:UITableViewRowAnimationAutomatic];
        }];
        [section addItem:item];
    }
    [_manager addSection:section];
    [_tableview reloadData];
}

- (void)configureDropDownItem:(GLDropDownItem *)item
{
    [item setPhoneHandler:^(GLDropDownItem *item) {
        GLBuddy *buddy = item.buddy;
        NSString *cleanedString = [[buddy.phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
        NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", cleanedString]];
        [[UIApplication sharedApplication] openURL:telURL];        
    }];
    
    [item setReminderHandler:^(GLDropDownItem *item) {
        
    }];
    
    [item setMessageHandler:^(GLDropDownItem *item) {
        GLBuddy *buddy = item.buddy;
        NSString *cleanedString = [[buddy.phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
        
        if ([MFMessageComposeViewController canSendText]) {
            MFMessageComposeViewController *messageComposer =
            [[MFMessageComposeViewController alloc] init];
            NSString *message = NSLocalizedString(@"I miss you dear, call me if you have time.", nil);
            [messageComposer setRecipients:@[cleanedString]];
            [messageComposer setBody:message];
            messageComposer.messageComposeDelegate = self;
            [self presentViewController:messageComposer animated:YES completion:nil];
        }
    }];
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


@end
