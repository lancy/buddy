//
//  GLBuddyViewController.m
//  buddy
//
//  Created by Lancy on 10/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>
#import <AVFoundation/AVFoundation.h>
#import "GLBuddyViewController.h"
#import "GLBuddyManager.h"
#import "GLBuddyCell.h"
#import "GLUserAgent.h"
#import "MBProgressHUD.h"

@interface GLBuddyViewController () <UIGestureRecognizerDelegate, UIActionSheetDelegate, ABPeoplePickerNavigationControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSArray *buddys;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UITextField *phoneTextField;
@property (strong, nonatomic) AVAudioPlayer *audioplayer;

@end

const NSInteger kActionSheetTagAddBuddy = 1014;

@implementation GLBuddyViewController

- (NSString *)tabImageName
{
	return @"tabbar_item1.png";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customUserinterface];
    [self registerNotificationHandler];
    [self initGestureRecognizer];
    [self requestRemoteBuddyData];
}



- (void) viewDidAppear:(BOOL)animated{
    NSString *soundFilePath =[[NSBundle mainBundle] pathForResource: @"quicktalk_cn" ofType: @"aac"];
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

- (void)initGestureRecognizer
{
    UILongPressGestureRecognizer *longPressGestureRecongnizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    longPressGestureRecongnizer.minimumPressDuration = 1.0;
    [longPressGestureRecongnizer setDelegate:self];
    [self.tableview addGestureRecognizer:longPressGestureRecongnizer];
}

- (void)customUserinterface
{
    [self setTitle:@"亲友团"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"viewcontroller_bg"]]];
    
    UIBarButtonItem *plusBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didTapPlusButton:)];
    [self.navigationItem setRightBarButtonItem:plusBarButton];
}

- (void)setupTableViewWithBuddys:(NSArray *)buddys;
{
    _manager = [[RETableViewManager alloc] initWithTableView:self.tableview];
    [_manager registerClass:@"GLBuddyItem" forCellWithReuseIdentifier:@"GLBuddyCell"];
    
    
    RETableViewSection *section = [RETableViewSection section];
    for (GLBuddy *buddy in buddys) {
        GLBuddyItem *item = [[GLBuddyItem alloc] initWithBuddy:buddy];
        [item setSelectionHandler:^(GLBuddyItem *item) {
            [item deselectRowAnimated:YES];
            GLBuddy *buddy = item.buddy;
            NSString *cleanedString = [[buddy.phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
            NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", cleanedString]];
            [[UIApplication sharedApplication] openURL:telURL];
            [[GLUserAgent sharedAgent] requestRecordWithPhoneNumber:buddy.phoneNumber recordType:GLRecordTypeTelephone];
        }];
        [section addItem:item];
    }
    [_manager addSection:section];
    [_tableview reloadData];
}

#pragma mark - data methods

- (void)registerNotificationHandler
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadBuddyData) name:BuddysDidChangedNotification object:nil];
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

#pragma mark - View Methods
- (void)didTapPlusButton:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"添加伙伴" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从通讯录添加", @"输入号码", nil];
    [actionSheet setTag:kActionSheetTagAddBuddy];
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
}

- (void)presentPeoplePicker
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint pressPoint = [gestureRecognizer locationInView:self.tableview];
        
        NSIndexPath *indexPath = [self.tableview indexPathForRowAtPoint:pressPoint];
        if (indexPath == nil) {
            NSLog(@"long press on table view but not on a row");
        } else {
            [self showActionSheetWithBuddyIndex:indexPath.row];
        }
    }
}

- (void)showActionSheetWithBuddyIndex:(NSUInteger)index
{
    GLBuddy *buddy = self.buddys[index];
    NSString *actionSheetTitle = [NSString stringWithFormat:@"%@%@?", NSLocalizedString(@"Remove ", nil), buddy.contactName];
    NSString *cancelTitle = NSLocalizedString(@"Cancle", nil);
    NSString *removeTitle = NSLocalizedString(@"Remove", nil);
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionSheetTitle delegate:self cancelButtonTitle:cancelTitle destructiveButtonTitle:removeTitle otherButtonTitles:nil];
    [actionSheet setTag:index];
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
}

- (void)showAddPeopleAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"添加伙伴" message:@"请输入电话号码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"添加", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
//    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 50.0, 260.0, 25.0)];
//    [_nameTextField setBackgroundColor:[UIColor whiteColor]];
//    [_nameTextField setPlaceholder:@"姓名"];
//    [alertView addSubview:_nameTextField];
//    
//    _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 85.0, 260.0, 25.0)];
//    [_phoneTextField setBackgroundColor:[UIColor whiteColor]];
//    [_phoneTextField setPlaceholder:@"电话号码"];
//    [alertView addSubview:_phoneTextField];
//    
    [alertView show];
//    [_nameTextField becomeFirstResponder];
}

#pragma mark - Alert View Delegate Methods

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

#pragma mark - Action Sheet Delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == kActionSheetTagAddBuddy) {
        if (buttonIndex == actionSheet.cancelButtonIndex) {
            // cancle
        } else if (buttonIndex == 0) {
            // add from address book
            [self presentPeoplePicker];
        } else if (buttonIndex == 1) {
            [self showAddPeopleAlertView];
        }
    } else {
        if (buttonIndex == actionSheet.destructiveButtonIndex) {
        }
    }
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
