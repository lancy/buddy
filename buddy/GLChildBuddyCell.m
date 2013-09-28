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
@property (assign, nonatomic) CGFloat moodWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *faceImageView;

@end

@implementation GLChildBuddyCell

+ (CGFloat)heightWithItem:(NSObject *)item tableViewManager:(RETableViewManager *)tableViewManager
{
    return 100;
}

- (void)cellDidLoad
{
    [super cellDidLoad];
    UIImage *progressImage = [[UIImage imageNamed:@"moodProgress"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 6, 2, 6) resizingMode:UIImageResizingModeStretch];
    [self.moodProgressImageView setImage:progressImage];
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
    if (buddy.miss) {
        [_missYouImageView setHidden:!buddy.miss.boolValue];
    } else {
        [_missYouImageView setHidden:YES];
    }
    
    if (buddy.userIntimacy) {
        [self setMoodWithUserIntimacy:buddy.userIntimacy];
    }
    
    if (buddy.avatarUrl) {
        [self.avatarImageView setImageWithURL:[NSURL URLWithString:buddy.avatarUrl]];
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

- (void)setMoodWithUserIntimacy:(NSNumber *)intimacy
{
    NSUInteger mood = [intimacy integerValue] + 1;
    CGFloat width = 178 * (mood / 100.0);
    [self.widthConstraint setConstant:width];
    [self.faceImageView setImage:[self faceImageWithUserIntimacy:intimacy]];
}

- (UIImage *)faceImageWithUserIntimacy:(NSNumber *)intimacy
{
    UIImage *image;
    NSUInteger mood = [intimacy integerValue];
    if (mood < 20) {
        image = [UIImage imageNamed:@"mood20"];
    } else if (mood < 40) {
        image = [UIImage imageNamed:@"mood40"];
    } else if (mood < 60) {
        image = [UIImage imageNamed:@"mood60"];
    } else if (mood < 80) {
        image = [UIImage imageNamed:@"mood80"];
    } else {
        image = [UIImage imageNamed:@"mood100"];
    }
    return image;
}
@end
