//
//  GLMoreViewController.m
//  buddy
//
//  Created by Lancy on 10/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLMoreViewController.h"
#import "GLChildBuddyViewController.h"

@interface GLMoreViewController ()

@end

@implementation GLMoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSString *)tabImageName
{
	return @"tabbar_item4.png";
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"viewcontroller_bg"]]];
    
    if ([self shouldShowDoneButton]) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(didTapDoneButton:)];
        [self.navigationItem setLeftBarButtonItem:doneButton];
    }
}

- (void)didTapDoneButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
