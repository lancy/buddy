//
//  GLReminder.m
//  buddy
//
//  Created by Lancy on 11/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLReminder.h"
#import "KZPropertyMapper.h"


@implementation GLReminder

- (NSString *)description
{
    return [NSString stringWithFormat:@"fireDate = %@, audioFilePath = %@", _fireDate, _audioFilePath];
}

- (id)initWithJsonObject:(NSDictionary *)jsonObject
{
    self = [super init];
    if (self) {
        [KZPropertyMapper mapValuesFrom:jsonObject toInstance:self usingMapping:@{
             @"fireDate": @"fireDate",
             @"audioFileUrl": @"audioFileUrl"
         }];
    }
    return self;
}

- (id)initWithDictionaryValue:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        [KZPropertyMapper mapValuesFrom:dictionary toInstance:self usingMapping:@{
             @"fireDate": @"fireDate",
             @"audioFilePath": @"audioFilePath"
         }];
    }
    return self;
}

- (NSDictionary *)dictionaryValue
{
    return @{
                 @"fireDate": _fireDate,
                 @"audioFilePath": _audioFilePath,
             };
}

+ (NSArray *)dictionaryValuesFromReminders:(NSArray *)reminders
{
    NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:reminders.count];
    for (GLReminder *reminder in reminders) {
        [values addObject:[reminder dictionaryValue]];
    }
    return [values copy];
}

+ (NSArray *)remindersFromDictionaryValues:(NSArray *)values
{
    NSMutableArray *reminders = [[NSMutableArray alloc] initWithCapacity:values.count];
    for (NSDictionary *value in values) {
        GLReminder *reminder = [[GLReminder alloc] initWithDictionaryValue:value];
        [reminders addObject:reminder];
    }
    return [reminders copy];
}


@end
