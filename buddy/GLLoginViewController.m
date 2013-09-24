//
//  GLLoginViewController.m
//  buddy
//
//  Created by Lancy on 4/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLLoginViewController.h"
#import "GLUserAgent.h"
#import "MBProgressHUD.h"

@interface GLLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation GLLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUserInterface];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.phoneNumberTextField becomeFirstResponder];
}

- (void)setupUserInterface
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"viewcontroller_bg"]]];
}

- (IBAction)accountTextFieldDidEndOnExit:(id)sender {
    [self.passwordTextField becomeFirstResponder];
}

- (IBAction)passwordTextFieldDidEndOnExit:(id)sender {
    [self didTapLoginButton:sender];
}

- (IBAction)didTapCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)didTapLoginButton:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[GLUserAgent sharedAgent] loginWithPhoneNumber:self.phoneNumberTextField.text
                                           password:self.passwordTextField.text
                                          completed:^(APIStatusCode statusCode, GLUserType userType, NSError *error) {
                                              NSLog(@"login api, status code = %d, userType = %d", statusCode, userType);
                                              [MBProgressHUD hideHUDForView:self.view animated:YES];
                                              if (statusCode == APIStatusCodeOK) {
                                                  [self dismissViewControllerAnimated:NO completion:[self loginSuccessHandler]];
                                              }else{
                                                  [ [GLUserAgent sharedAgent] showErrorDialog:statusCode ];
                                              }
                                          }];
}
@end
