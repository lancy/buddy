//
//  GLLaunchViewController.m
//  buddy
//
//  Created by Lancy on 4/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLLaunchViewController.h"
#import "AKTabBarController.h"
#import "GLLoginViewController.h"
#import "GLChildBuddyViewController.h"
#import "GLUserAgent.h"

@interface GLLaunchViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) AKTabBarController *tabBarController;

@end

NSString * const kPresentRegisterSegueIdentifier = @"presentRegister";
NSString * const kPresentLoginSegueIdentifier = @"presentLogin";
NSString * const kPresentChildBuddySegueIdentifier = @"presentChild";
NSString * const kPresentMainBuddySegueIdentifier = @"presentMain";


@implementation GLLaunchViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserRegisterSuccess:) name:GLUserRegisterDidSuccessNotificaton object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GLUserRegisterDidSuccessNotificaton object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupScrollView];
}

#pragma mark - Notification handler
- (void)handleUserRegisterSuccess:(NSNotification *)notification
{
    GLUserAgent *agent = [GLUserAgent sharedAgent];
    [[GLUserAgent sharedAgent] loginWithPhoneNumber:agent.phoneNumber
                                           password:agent.password
                                          completed:^(APIStatusCode statusCode, GLUserType userType, NSError *error) {
                                              NSLog(@"login api, status code = %d", statusCode);
                                              if (statusCode == APIStatusCodeOK) {
                                                  [self presentHomeViewController];
                                              }else{
                                                  [ [GLUserAgent sharedAgent] showErrorDialog:statusCode ];
                                              }
                                          }];
}

#pragma mark - scroll view
- (void)setupScrollView
{
    NSArray *imagesNames;
    if  (IS_NOT_4INCH_IPHONE) {
        imagesNames = [self introImageNamesOfPrefix:@"LaunchIntroImage4-" count:5];
    } else {
        imagesNames = [self introImageNamesOfPrefix:@"LaunchIntroImage-" count:5];
    }
    CGFloat pageWidth = self.scrollView.frame.size.width;
    [imagesNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImage *image = [UIImage imageNamed:obj];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setFrame:CGRectMake(pageWidth * idx, 0, pageWidth, image.size.height)];
        [self.scrollView addSubview:imageView];
    }];
    [self.scrollView setContentSize:CGSizeMake(pageWidth * imagesNames.count, self.scrollView.frame.size.height)];
}

- (NSArray *)introImageNamesOfPrefix:(NSString *)prefix count:(NSInteger)count
{
    NSMutableArray *imagesNames = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%@%d.png", prefix, i];
        [imagesNames addObject:imageName];
    }
    return [imagesNames copy];
}

#pragma mark - Register View Controller
- (void)presentRegisterViewController
{
    [self performSegueWithIdentifier:kPresentRegisterSegueIdentifier sender:self];
}

#pragma mark - Login View Controller
- (void)presentLoginViewController
{
    [self performSegueWithIdentifier:kPresentLoginSegueIdentifier sender:self];
}


#pragma mark - Home View Controller

- (void)presentHomeViewController
{
    if (IOS7_OR_LATER) {
        [self performSegueWithIdentifier:kPresentMainBuddySegueIdentifier sender:self];
    } else {
        [self setupTabbarController];
        [_tabBarController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:_tabBarController animated:YES completion:nil];
    }
}

- (void)presentChildBuddyViewController
{
    [self performSegueWithIdentifier:kPresentChildBuddySegueIdentifier sender:self];
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

#pragma mark - segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kPresentRegisterSegueIdentifier]) {
        
    } else if ([segue.identifier isEqualToString:kPresentLoginSegueIdentifier]) {
        UINavigationController *navi = segue.destinationViewController;
        [(GLLoginViewController *)navi.topViewController setLoginSuccessHandler:^{
            if ([[GLUserAgent sharedAgent] userType] == GLUserTypeOld) {
                [self presentHomeViewController];
            } else {
                [self presentChildBuddyViewController];
            }
        }];
    }
}

#pragma mark - action methods
- (IBAction)didTapRegisterButton:(id)sender {
    [self presentRegisterViewController];
}

- (IBAction)didTapLoginButton:(id)sender {
    [self presentLoginViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
