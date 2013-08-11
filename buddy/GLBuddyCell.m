//
//  GLBuddyCell.m
//  buddy
//
//  Created by Lancy on 10/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GLBuddyCell.h"
#import "NSDictionary+GLBuddy.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GLBuddyCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end



@implementation GLBuddyCell

+ (CGFloat)heightWithItem:(NSObject *)item tableViewManager:(RETableViewManager *)tableViewManager
{
    return 100;
}

- (void)cellDidLoad
{
    [super cellDidLoad];
    [self.avatarImageView.layer setCornerRadius:32];
    [self.avatarImageView.layer setMasksToBounds:YES];
}

- (void)cellWillAppear
{
    [super cellWillAppear];
    GLBuddy *buddy = self.item.buddy;
    if (buddy.contactName) {
        [_nameLabel setText:buddy.contactName];
    } else {
        [_nameLabel setText:buddy.phoneNumber];
    }
    [self.descriptionLabel setText:NSLocalizedString(@"Click here to call him/her.", nil)];
    if (buddy.avatarUrl) {
        [self.avatarImageView setImageWithURL:[NSURL URLWithString:buddy.avatarUrl]];
        [self.avatarImageView setHidden:NO];
    } else {
        [self.avatarImageView setHidden:YES];
    }
}

- (void)cellDidDisappear
{
    [super cellDidDisappear];
}


@end
