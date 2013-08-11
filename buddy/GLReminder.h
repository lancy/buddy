//
//  GLReminder.h
//  buddy
//
//  Created by Lancy on 11/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLReminder : NSObject

@property (copy, nonatomic) NSDate *fireDate;
@property (copy, nonatomic) NSString *audioFilePath;
@property (copy, nonatomic) NSString *audioFileUrl;

- (id)initWithJsonObject:(NSDictionary *)jsonObject;
- (id)initWithDictionaryValue:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryValue;

+ (NSArray *)dictionaryValuesFromReminders:(NSArray *)reminders;
+ (NSArray *)remindersFromDictionaryValues:(NSArray *)values;

@end
