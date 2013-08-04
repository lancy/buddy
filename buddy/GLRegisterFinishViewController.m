//
//  GLRegisterFinishViewController.m
//  buddy
//
//  Created by Lancy on 4/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLRegisterFinishViewController.h"
#import "GLUserAgent.h"


@interface GLRegisterFinishViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *againPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation GLRegisterFinishViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUserInterface];
}

- (void)setupUserInterface
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"viewcontroller_bg"]]];
    [self setTitle:@"注册"];
}

- (void)saveUserInfo
{
    GLUserAgent *userAgent = [GLUserAgent sharedAgent];
    [userAgent setPhoneNumber:self.phoneNumberTextField.text];
    [userAgent setPassword:self.passwordTextField.text];
    [userAgent setEmail:self.emailTextField.text];
}

- (IBAction)didTapNextButton:(id)sender {
    [self saveUserInfo];
    
    
    GLUserAgent *userAgent = [GLUserAgent sharedAgent];
    GLUserType userType = userAgent.userType;
    NSString *phoneNumber = userAgent.phoneNumber;
    NSString *password = userAgent.password;
    NSString *email = userAgent.email;
    
    [userAgent registerWithUserType:userType phoneNumber:phoneNumber password:password email:email completed:^(APIStatusCode statusCode, NSError *error) {
            NSLog(@"status code = %d", statusCode);
    }];
}

@end
