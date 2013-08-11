//
//  GLReminderCell.m
//  buddy
//
//  Created by Lancy on 10/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLReminderCell.h"

@interface GLReminderCell()
@property (weak, nonatomic) IBOutlet UILabel *fireDateLabel;

@end

@implementation GLReminderCell

+ (CGFloat)heightWithItem:(NSObject *)item tableViewManager:(RETableViewManager *)tableViewManager
{
    return 100;
}

- (void)cellDidLoad
{
    [super cellDidLoad];
}

- (void)cellWillAppear
{
    [super cellWillAppear];
    GLReminder *reminder = self.item.reminder;
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
