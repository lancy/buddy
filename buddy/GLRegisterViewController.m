//
//  GLRegisterViewController.m
//  buddy
//
//  Created by Lancy on 4/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLRegisterViewController.h"

@interface GLRegisterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *chooseSwitch;
@property (assign, nonatomic, getter = isChooseOld) BOOL chooseOld;
@end

@implementation GLRegisterViewController

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

- (IBAction)didTapChooseSwitch:(id)sender {
    [self setChooseOld:![sender isSelected]];
    [sender setSelected:self.chooseOld];
}
- (IBAction)didTapNextButton:(id)sender {
    [self performSegueWithIdentifier:@"next" sender:self];
}
- (IBAction)didTapCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"next"]) {
        [segue.destinationViewController setChooseOld:self.chooseOld];
    }
}

@end
