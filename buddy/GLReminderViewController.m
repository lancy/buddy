//
//  GLReminderViewController.m
//  buddy
//
//  Created by Lancy on 10/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLReminderViewController.h"

@interface GLReminderViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation GLReminderViewController

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
	return @"tabbar_item2.png";
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customUserinterface];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - View Methods
- (void)didTapPlusButton:(id)sender
{
    [self performSegueWithIdentifier:@"ShowAudioRecordView" sender:self];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ReminderCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    //    NSDate *object = self.buddys[indexPath.row];
    //    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

@end
