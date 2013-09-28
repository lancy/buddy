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
#import "GLMoreViewController.h"
#import "GLChildBuddyItem.h"
#import "GLDropDownCell.h"
#import "GLDropDownItem.h"
#import "GLRecordViewController.h"
#import "MBProgressHUD.h"

@interface GLChildBuddyViewController () <MFMessageComposeViewControllerDelegate, UIActionSheetDelegate, ABPeoplePickerNavigationControllerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UITextField *phoneTextField;
@end

@implementation GLChildBuddyViewController {
    GLDropDownItem *_lastItem;
    GLBuddy *_selectedBuddy;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customUserinterface];
    [self requestRemoteBuddyData];
}

- (void)customUserinterface
{
    self.title = @"亲友团";
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"viewcontroller_bg"]]];
    UIBarButtonItem *moreBarButton = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStyleBordered target:self action:@selector(didTapMoreButton:)];
    [self.navigationItem setLeftBarButtonItem:moreBarButton];
    UIBarButtonItem *plusBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didTapPlusButton:)];
    [self.navigationItem setRightBarButtonItem:plusBarButton];
}

- (void)didTapMoreButton:(id)sender
{
    GLMoreViewController *contentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MoreViewController"];
    [self.navigationController pushViewController:contentVC animated:YES];
}

- (void)requestRemoteBuddyData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[GLUserAgent sharedAgent] requestRelativesListWithCompletedBlock:^(NSArray *relatives, NSError *error) {
        NSLog(@"relatives = %@", relatives);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
            _selectedBuddy = [item buddy];
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
        [[GLUserAgent sharedAgent] requestRecordWithPhoneNumber:buddy.phoneNumber recordType:GLRecordTypeTelephone];
    }];
    
    [item setReminderHandler:^(GLDropDownItem *item) {
        [self performSegueWithIdentifier:@"ShowAudioRecordView" sender:self];
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
#warning TODO exception handler
        NSLog(@"Message compose failed");
    } else if (result == MessageComposeResultCancelled) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (result == MessageComposeResultSent) {
        [[GLUserAgent sharedAgent] requestRecordWithPhoneNumber:_selectedBuddy.phoneNumber recordType:GLRecordTypeSMS];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowAudioRecordView"]) {
        GLRecordViewController *vc = (GLRecordViewController *)[(UINavigationController *)segue.destinationViewController topViewController];
        [vc setSelectedBuddy:_selectedBuddy];
    }
}

- (void)didTapPlusButton:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"添加伙伴" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从通讯录添加", @"输入号码", nil];
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if (buttonIndex == actionSheet.cancelButtonIndex) {
            // cancle
        } else if (buttonIndex == 0) {
            // add from address book
            [self presentPeoplePicker];
        } else if (buttonIndex == 1) {
            [self showAddPeopleAlertView];
        }
}

- (void)showAddPeopleAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"添加伙伴" message:@"请输入电话号码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"添加", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alertView show];
}
- (void)presentPeoplePicker
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark - People Picker Navagation Delegate

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    [[GLUserAgent sharedAgent] addRelativeWithPersonRef:person completed:^(APIStatusCode statusCode, NSError *error) {
        if(statusCode==APIStatusCodeFriendAddedSuccess) {
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"信息" message:@"添加成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [av show];
        }else{
            [[GLUserAgent sharedAgent] showErrorDialog:statusCode];
        }
        
        NSLog(@"add relative api, status = %d", statusCode);
    }];
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        UITextField *phoneTextFiled = [alertView textFieldAtIndex:0];
        // add contact
        [[GLUserAgent sharedAgent] addRelativeWithPhoneNumber:phoneTextFiled.text contactName:nil completed:^(APIStatusCode statusCode, NSError *error) {
            NSLog(@"Add Relative API, statue = %d", statusCode);
            if (statusCode == APIStatusCodeFriendAddedSuccess) {
                UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"信息" message:@"添加成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [av show];
                [self requestRemoteBuddyData];
            }else{
                [[GLUserAgent sharedAgent] showErrorDialog:statusCode];
            }
        }];
    }
}
@end
