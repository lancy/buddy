//
//  GLBuddyViewController.m
//  buddy
//
//  Created by Lancy on 10/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLBuddyViewController.h"

#import "GLBuddyManager.h"
#import "NSDictionary+GLBuddy.h"

#import "GLBuddyCell.h"


@interface GLBuddyViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *buddys;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation GLBuddyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSString *)tabImageName
{
	return @"tabbar_item1.png";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customUserinterface];
    [self registerNotificationHandler];
    
    #warning test methods, need to remove
    [[GLBuddyManager shareManager] clearAllBuddys];

    [self loadBuddyData];
	// Do any additional setup after loading the view.
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - data methods

- (void)registerNotificationHandler
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadBuddyData) name:BuddysDidChangedNotification object:nil];
}
- (void)loadBuddyData
{
    self.buddys = [[GLBuddyManager shareManager] allBuddys];
    [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - View Methods
- (void)didTapPlusButton:(id)sender
{
    [[GLBuddyManager shareManager] addNewBuddyWithName:@"Lancy" phoneNumber:@"15902063569" avatarPath:nil];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.buddys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BuddyCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    NSDictionary *buddy = self.buddys[indexPath.row];
    [(GLBuddyCell *)cell bindBuddyData:buddy];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *buddy = self.buddys[indexPath.row];
    NSString *cleanedString = [[buddy.buddyPhoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", cleanedString]];
    [[UIApplication sharedApplication] openURL:telURL];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
