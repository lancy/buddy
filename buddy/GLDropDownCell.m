//
//  GLDropDownCell.m
//  buddy
//
//  Created by Lancy on 24/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLDropDownCell.h"

@implementation GLDropDownCell

+ (CGFloat)heightWithItem:(NSObject *)item tableViewManager:(RETableViewManager *)tableViewManager
{
    return 50;
}

- (void)cellDidLoad
{
    [super cellDidLoad];
}

- (void)cellWillAppear
{
    [super cellWillAppear];
}

- (void)cellDidDisappear
{
    [super cellDidDisappear];
}

- (IBAction)phoneButtonPressed:(id)sender {
    self.item.phoneHandler(self.item);
}
- (IBAction)reminderButtonPressed:(id)sender {
    self.item.reminderHandler(self.item);
}
- (IBAction)messageButtonPressed:(id)sender {
    self.item.messageHandler(self.item);
}


@end
