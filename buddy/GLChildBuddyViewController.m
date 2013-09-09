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
    self.title = @"Buddys";
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"viewcontroller_bg"]]];
    UIBarButtonItem *moreBarButton = [[UIBarButtonItem alloc] initWithTitle:@"More" style:UIBarButtonItemStyleBordered target:self action:@selector(didTapMoreButton:)];
    [self.navigationItem setLeftBarButtonItem:moreBarButton];
    UIBarButtonItem *plusBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didTapPlusButton:)];
    [self.navigationItem setRightBarButtonItem:plusBarButton];
}

- (void)didTapMoreButton:(id)sender
{
   
    GLMoreViewController *contentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MoreViewController"];
    [contentVC setShouldShowDoneButton:YES];
    UIViewController *vc = [[UINavigationController alloc] initWithRootViewController:contentVC];
    [self presentViewController:vc animated:YES completion:nil];
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
        _selectedBuddy = item.buddy;
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
#warning TOTO exception handler
        NSLog(@"Message compose failed");
    } else if (result == MessageComposeResultCancelled) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (result == MessageComposeResultSent) {
        // give current buddy a red heart
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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"添加伙伴" message:@"   " delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"添加", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 50.0, 260.0, 25.0)];
    [_nameTextField setBackgroundColor:[UIColor whiteColor]];
    [_nameTextField setPlaceholder:@"姓名"];
    [alertView addSubview:_nameTextField];
    
    _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 85.0, 260.0, 25.0)];
    [_phoneTextField setBackgroundColor:[UIColor whiteColor]];
    [_phoneTextField setPlaceholder:@"电话号码"];
    [alertView addSubview:_phoneTextField];
    
    [alertView show];
    [_nameTextField becomeFirstResponder];
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

@end
