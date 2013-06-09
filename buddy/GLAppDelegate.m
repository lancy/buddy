//
//  GLAppDelegate.m
//  buddy
//
//  Created by Lancy on 10/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//
#import "GLAppDelegate.h"


#import "AKTabBarController.h"


@interface GLAppDelegate ()
@property (strong, nonatomic) AKTabBarController *tabBarController;

@end

@implementation GLAppDelegate

- (void)customUserinterface
{
    [self customNavigation];
    [self customTabbar];
}

- (void)customNavigation
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navi_bg.png"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)customTabbar
{
    // Below you will find an example of the possible customizations, just uncomment the lines below
    
    // Tab background Image
    //    [_tabBarController setBackgroundImageName:@"tabbar_bg.png"];
    [_tabBarController setSelectedBackgroundImageName:@"tabbar_selected.png"];
    
    [_tabBarController setTabTitleIsHidden:YES];
    
    // Tabs top embos Color
    //     [_tabBarController setTabEdgeColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8]];
    
    // Tabs Colors settings
    //     [_tabBarController setTabColors:@[[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.0],
    //     [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0]]]; // MAX 2 Colors
    //
    //     [_tabBarController setSelectedTabColors:@[[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0],
    //     [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0]]]; // MAX 2 Colors
    
    // Tab Stroke Color
    //     [_tabBarController setTabStrokeColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    
    // Icons Color settings
    //     [_tabBarController setIconColors:@[[UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1],
    //     [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1]]]; // MAX 2 Colors
    
    // Icon Shadow
    //     [_tabBarController setIconShadowColor:[UIColor blackColor]];
    //     [_tabBarController setIconShadowOffset:CGSizeMake(0, 1)];
    
    [_tabBarController setSelectedIconColors:@[[UIColor lightGrayColor], [UIColor whiteColor]]];
    //     [_tabBarController setSelectedIconColors:@[[UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1],
    //     [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1]]]; // MAX 2 Colors
    //
    //     [_tabBarController setSelectedIconOuterGlowColor:[UIColor darkGrayColor]];
    
    // Text Color
    //     [_tabBarController setTextColor:[UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1.0]];
    //     [_tabBarController setSelectedTextColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
    
    // Text font
    //     [_tabBarController setTextFont:[UIFont fontWithName:@"Chalkduster" size:14]];
    
    // Hide / Show glossy on tab icons
    //     [_tabBarController setIconGlossyIsHidden:YES];
    
    // Enable / Disable pre-rendered image mode
    //     [_tabBarController setTabIconPreRendered:YES];
    
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // If the device is an iPad, we make it taller.
    _tabBarController = [[AKTabBarController alloc] initWithTabBarHeight:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 70 : 53];
    [_tabBarController setMinimumHeightToDisplayTitle:40.0];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    
    [_tabBarController setViewControllers: [NSMutableArray arrayWithObjects:
                                             [[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"BuddyViewController"]],
                                             [[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"ReminderViewController"]],
                                             [[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"MessageViewController"]],
                                             [[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"MoreViewController"]],
                                            nil]];
    
    
    
    [self customUserinterface];
    [_window setRootViewController:_tabBarController];
    [_window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
