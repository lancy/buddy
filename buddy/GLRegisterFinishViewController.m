//
//  GLRegisterFinishViewController.m
//  buddy
//
//  Created by Lancy on 4/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLRegisterFinishViewController.h"
#import "GLUserAgent.h"
#import "MBProgressHUD.h"


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
- (IBAction)textFieldDidEndOnExit:(id)sender {
    NSArray *textFields = @[self.phoneNumberTextField, self.passwordTextField, self.againPasswordTextField, self.emailTextField];
    NSInteger index = [textFields indexOfObject:sender];
    if (sender != self.emailTextField) {
        [textFields[index + 1] becomeFirstResponder];
    } else {
        [self didTapNextButton:nil];
    }
}

- (IBAction)didTapNextButton:(id)sender {
    if (self.phoneNumberTextField.text.length == 0) {
        [self showAlertViewWithMessage:@"请输入手机号"];
        return;
    } else if (self.passwordTextField.text.length == 0) {
        [self showAlertViewWithMessage:@"请输入密码"];
        return;
    } else if (self.againPasswordTextField.text.length == 0) {
        [self showAlertViewWithMessage:@"请再次输入密码"];
        return;
    } else if ([self.againPasswordTextField.text isEqualToString:self.passwordTextField.text] == NO) {
        [self showAlertViewWithMessage:@"两次输入的密码不一致"];
        return;
    }
    [self saveUserInfo];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    GLUserAgent *userAgent = [GLUserAgent sharedAgent];
    GLUserType userType = userAgent.userType;
    NSString *phoneNumber = userAgent.phoneNumber;
    NSString *password = userAgent.password;
    NSString *email = userAgent.email;
    NSString *userName = userAgent.contactName;
    [userAgent registerWithUserType:userType userName:userName phoneNumber:phoneNumber password:password email:email completed:^(APIStatusCode statusCode, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(statusCode == APIStatusCodeOK){
            [self dismissViewControllerAnimated:NO completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:GLUserRegisterDidSuccessNotificaton object:nil];
            }];
        } else {
            [userAgent showErrorDialog:statusCode];
        }
            NSLog(@"status code = %d", statusCode);
    }];
}

- (void)showAlertViewWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
