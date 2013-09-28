//
//  GLReminderCell.m
//  buddy
//
//  Created by Lancy on 10/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "SDWebImage/UIImageView+WebCache.h"
#import "GLReminderCell.h"
#import "GLBuddy.h"
#import "GLBuddyManager.h"

@interface GLReminderCell()
@property (weak, nonatomic) IBOutlet UILabel *fireDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end

@implementation GLReminderCell

+ (CGFloat)heightWithItem:(NSObject *)item tableViewManager:(RETableViewManager *)tableViewManager
{
    return 100;
}

- (void)cellDidLoad
{
    [super cellDidLoad];
    [self.avatarImageView.layer setCornerRadius:28];
    [self.avatarImageView.layer setMasksToBounds:YES];
}

- (void)cellWillAppear
{
    [super cellWillAppear];
    GLReminder *reminder = self.item.reminder;
    GLBuddy *buddy = [[GLBuddyManager shareManager] buddyFromRemotesWithPhoneNumber:reminder.phoneNumber];
    
    if (buddy.avatarUrl) {
        [self.avatarImageView setImageWithURL:[NSURL URLWithString:buddy.avatarUrl]];
        [self.avatarImageView setHidden:NO];
    } else {
        [self.avatarImageView setHidden:YES];
    }
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateStyle:NSDateFormatterShortStyle];
    [dateFormater setTimeStyle:NSDateFormatterShortStyle];
    [_fireDateLabel setText:[dateFormater stringFromDate:reminder.fireDate]];
}

- (void)cellDidDisappear
{
    [super cellDidDisappear];
}


@end
