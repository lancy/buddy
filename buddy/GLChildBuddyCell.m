//
//  GLChildBuddyCell.m
//  buddy
//
//  Created by Lancy on 24/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GLChildBuddyCell.h"
#import "GLBuddy.h"
#import "SDWebImage/UIImageView+WebCache.h"


@interface GLChildBuddyCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moodProgressImageView;
@property (weak, nonatomic) IBOutlet UIImageView *missYouImageView;

@end

@implementation GLChildBuddyCell

+ (CGFloat)heightWithItem:(NSObject *)item tableViewManager:(RETableViewManager *)tableViewManager
{
    return 100;
}

- (void)cellDidLoad
{
    [super cellDidLoad];
    [self.avatarImageView.layer setCornerRadius:32];
    [self.avatarImageView.layer setMasksToBounds:YES];
    NSLog(@"called cellDidLoad");
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
    if (buddy.avatarUrl) {
        //[self.avatarImageView setImageWithURL:[NSURL URLWithString:buddy.avatarUrl]];
        
        //For testing purpose only
        [self.avatarImageView setImageWithURL:[NSURL URLWithString:@"http://tp1.sinaimg.cn/1666109020/180/40013962754/1"]];
        [self.avatarImageView.layer setCornerRadius:32];
        [self.avatarImageView.layer setMasksToBounds:YES];
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
