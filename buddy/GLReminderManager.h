//
//  GLReminderManager.h
//  buddy
//
//  Created by Lancy on 15/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const LocalRemindersDidChangedNotification;

@interface GLReminderManager : NSObject

+ (GLReminderManager *)shareManager;

- (NSArray *)allLocalReminders;
- (void)addNewLocalReminderWithFireDate:(NSDate *)fireDate audioFilePath:(NSString *)audioFilePath;


@end
