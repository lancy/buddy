//
//  GLBuddyCell.m
//  buddy
//
//  Created by Lancy on 10/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLBuddyCell.h"
#import "NSDictionary+GLBuddy.h"

@implementation GLBuddyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindBuddyData:(NSDictionary *)buddy
{
    [self.nameLabel setText:buddy.buddyName];
    [self.descritionLabel setText:NSLocalizedString(@"Click here to call him/her.", nil)];
}


@end
