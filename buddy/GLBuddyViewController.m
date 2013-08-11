//
//  GLBuddyViewController.m
//  buddy
//
//  Created by Lancy on 10/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>
#import "GLBuddyViewController.h"
#import "GLBuddyManager.h"
#import "GLBuddyCell.h"
#import "GLUserAgent.h"

@interface GLBuddyViewController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate, ABPeoplePickerNavigationControllerDelegate>

@property (strong, nonatomic) NSArray *buddys;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

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

- (void)initGestureRecognizer
{
    UILongPressGestureRecognizer *longPressGestureRecongnizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    longPressGestureRecongnizer.minimumPressDuration = 1.0;
    [longPressGestureRecongnizer setDelegate:self];
    [self.tableview addGestureRecognizer:longPressGestureRecongnizer];
}

- (void)customUserinterface
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"viewcontroller_bg"]]];
    
    UIImage *plusButtonImage= [UIImage imageNamed:@"navi_plusbutton.png"];
    UIButton *plusButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, plusButtonImage.size.width, plusButtonImage.size.height)];
    [plusButton setImage:[UIImage imageNamed:@"navi_plusbutton.png"] forState:UIControlStateNormal];
    [plusButton setImage:[UIImage imageNamed:@"navi_plusbutton_selected.png"] forState:UIControlStateHighlighted];
    [plusButton addTarget:self action:@selector(didTapPlusButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *plusBarButton = [[UIBarButtonItem alloc] initWithCustomView:plusButton];
    [self.navigationItem setRightBarButtonItem:plusBarButton];
    
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -5;
    
    [self.navigationItem setRightBarButtonItems:@[negativeSeperator, plusBarButton]];
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
    [[GLUserAgent sharedAgent] requestRelativesListWithCompletedBlock:^(NSArray *relatives, NSError *error) {
        NSLog(@"relatives = %@", relatives);
        [self setupTableViewWithBuddys:relatives];
    }];
}

#pragma mark - View Methods
- (void)didTapPlusButton:(id)sender
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

#pragma mark - Action Sheet Delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        [[GLBuddyManager shareManager] removeBuddyWithIndex:actionSheet.tag];
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
    [[GLBuddyManager shareManager] addNewBuddyWithPerson:person];
    [[GLUserAgent sharedAgent] addRelativeWithPersonRef:person completed:^(APIStatusCode statusCode, NSError *error) {
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
