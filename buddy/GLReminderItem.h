//
//  GLReminderItem.h
//  buddy
//
//  Created by Lancy on 11/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "RETableViewItem.h"
#import "GLReminder.h"

@interface GLReminderItem : RETableViewItem

@property (copy, nonatomic) GLReminder *reminder;

- (id)initWithReminder:(GLReminder *)reminder;


@end
