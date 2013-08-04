//
//  GLRegisterFinishViewController.m
//  buddy
//
//  Created by Lancy on 4/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLRegisterFinishViewController.h"

@interface GLRegisterFinishViewController ()

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

@end
