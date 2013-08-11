//
//  GLMessageCell.m
//  buddy
//
//  Created by Lancy on 10/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SDWebImage/UIImageView+WebCache.h"
#import "GLMessageCell.h"

@interface GLMessageCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *heartImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@end

@implementation GLMessageCell


+ (CGFloat)heightWithItem:(NSObject *)item tableViewManager:(RETableViewManager *)tableViewManager
{
    return 100;
}

- (void)cellDidLoad
{
    [super cellDidLoad];
    [_avatarImageView.layer setCornerRadius:32];
    [_avatarImageView.layer setMasksToBounds:YES];
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
    [_descriptionLabel setText:NSLocalizedString(@"Click here to message him/her.", nil)];
    if (buddy.avatarUrl) {
        [_avatarImageView setImageWithURL:[NSURL URLWithString:buddy.avatarUrl]];
        [_avatarImageView setHidden:NO];
    } else {
        [_avatarImageView setHidden:YES];
    }
}

- (void)cellDidDisappear
{
    [super cellDidDisappear];
}



@end
