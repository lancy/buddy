//
//  GLMessageCell.m
//  buddy
//
//  Created by Lancy on 10/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GLMessageCell.h"
#import "NSDictionary+GLBuddy.h"

@implementation GLMessageCell

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
    [self.descriptionLabel setText:NSLocalizedString(@"Click here to message him/her.", nil)];
    NSTimeInterval secondsOfADay = 24 * 60 * 60;
    NSTimeInterval currentTimeStamp = [[NSDate date] timeIntervalSince1970];
    if (currentTimeStamp - buddy.lastMessageTimeStamp >  secondsOfADay) {
        [self.heartImageView setImage:[UIImage imageNamed:@"message_tableviewcell_unsend.png"]];
    } else {
        [self.heartImageView setImage:[UIImage imageNamed:@"message_tableviewcell_sent.png"]];
    }
    if (buddy.avatarPath) {
        UIImage *avatarImage = [UIImage imageWithContentsOfFile:buddy.avatarPath];
        [self.avatarImageView.layer setCornerRadius:32];
        [self.avatarImageView.layer setMasksToBounds:YES];
        [self.avatarImageView setImage:avatarImage];
        [self.avatarImageView setHidden:NO];
    } else {
        [self.avatarImageView setHidden:YES];
    }

}


@end
