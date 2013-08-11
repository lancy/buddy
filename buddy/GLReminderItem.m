//
//  GLReminderItem.m
//  buddy
//
//  Created by Lancy on 11/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLReminderItem.h"

@implementation GLReminderItem

- (id)initWithReminder:(GLReminder *)reminder
{
    self = [super init];
    if (self) {
        _reminder = reminder;
    }
    return self;
}


@end
