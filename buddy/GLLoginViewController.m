//
//  GLLoginViewController.m
//  buddy
//
//  Created by Lancy on 4/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLLoginViewController.h"
#import "GLUserAgent.h"

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

- (void)setupUserInterface
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"viewcontroller_bg"]]];
}
- (IBAction)didTapCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)didTapLoginButton:(id)sender {
    [[GLUserAgent sharedAgent] loginWithPhoneNumber:self.phoneNumberTextField.text
                                           password:self.passwordTextField.text
                                          completed:^(APIStatusCode statusCode, NSError *error)
    {
          NSLog(@"status code = %d", statusCode);
    }];
    
}

@end