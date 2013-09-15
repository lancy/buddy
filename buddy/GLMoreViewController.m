//
//  GLMoreViewController.m
//  buddy
//
//  Created by Lancy on 10/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLMoreViewController.h"
#import "GLChildBuddyViewController.h"

@interface GLMoreViewController ()
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation GLMoreViewController

- (NSString *)tabImageName
{
	return @"tabbar_item4.png";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"viewcontroller_bg"]]];
}

- (IBAction)didTapLogoutButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
