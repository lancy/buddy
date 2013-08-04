//
//  GLLaunchViewController.m
//  buddy
//
//  Created by Lancy on 4/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLLaunchViewController.h"
#import "AKTabBarController.h"

@interface GLLaunchViewController ()

@property (strong, nonatomic) AKTabBarController *tabBarController;



@end

@implementation GLLaunchViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self presentHomeViewController];
}


#pragma mark - Home View Controller

- (void)presentHomeViewController
{
    [self setupTabbarController];
    [_tabBarController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:_tabBarController animated:YES completion:nil];
}

- (void)setupTabbarController
{
    _tabBarController = [[AKTabBarController alloc] initWithTabBarHeight:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 70 : 53];
    [_tabBarController setMinimumHeightToDisplayTitle:40.0];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    
    [_tabBarController setViewControllers: [NSMutableArray arrayWithObjects:
                                            [[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"BuddyViewController"]],
                                            [[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"ReminderViewController"]],
                                            [[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"MessageViewController"]],
                                            [[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"MoreViewController"]],
                                            nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
