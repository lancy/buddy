//
//  GLRegisterMiddleViewController.m
//  buddy
//
//  Created by Lancy on 4/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLRegisterMiddleViewController.h"
#import "GLUserAgent.h"

@interface GLRegisterMiddleViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarBackgroundView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@end

@implementation GLRegisterMiddleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUserInterface];
}

- (void)setupUserInterface
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"viewcontroller_bg"]]];
    [self setTitle:@"注册"];
    
    if ([self isChooseOld]) {
        [self.avatarBackgroundView setImage:[UIImage imageNamed:@"oldframe.png"]];
        [self.titleLabel setText:@"您选择了伴儿老人端"];
        [self.subtitleLabel setText:@"老人端提供全套语音导航，帮助老人快速拨通亲人电话，接收语音提醒，传达思念"];
    }
}

- (IBAction)didTapNextButton:(id)sender {
    [self saveUserInfo];
    [self performSegueWithIdentifier:@"next" sender:self];
}

- (void)saveUserInfo
{
    GLUserAgent *userAgent = [GLUserAgent sharedAgent];
    if ([self isChooseOld]) {
        [userAgent setUserType:GLUserTypeOld];
    } else {
        [userAgent setUserType:GLUserTypeYoung];
    }
    [userAgent setContactName:self.nameTextField.text];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
