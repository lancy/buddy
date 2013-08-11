//
//  GLReminderManager.m
//  buddy
//
//  Created by Lancy on 15/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLReminderManager.h"
#import "NSDictionary+GLReminder.h"
#import "GLReminder.h"
NSString * const LocalRemindersDidChangedNotification = @"GLLocalRemindersDidChangedNotificaton";


@interface GLReminderManager ()

@property (strong, nonatomic) NSMutableArray *localReminders;

@end

@implementation GLReminderManager

+ (GLReminderManager *)shareManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

- (NSMutableArray *)localReminders
{
    if (!_localReminders) {
        [self loadLocalRemindersFromFile];
        if (!_localReminders) {
            _localReminders = [[NSMutableArray alloc] init];
        }
    }
    return _localReminders;
}


- (NSArray *)allLocalReminders
{
    return [self.localReminders copy];
}

- (void)addNewLocalReminderWithFireDate:(NSDate *)fireDate audioFilePath:(NSString *)audioFilePath
{
    GLReminder *newReminder = [[GLReminder alloc] init];
    [newReminder setFireDate:fireDate];
    [newReminder setAudioFilePath:audioFilePath];
    [self.localReminders addObject:newReminder];
    [self.localReminders sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        GLReminder *reminder1 = (GLReminder *)obj1;
        GLReminder *reminder2 = (GLReminder *)obj2;
        return [reminder1.fireDate compare:reminder2.fireDate];
    }];
    
    [self saveLocalRemindersToFile];
}

#pragma mark - file operation

- (void)loadLocalRemindersFromFile
{
    NSString *plistPath = [self plistPath];
    NSArray *dictionaryValues = [NSMutableArray arrayWithContentsOfFile:plistPath];
    self.localReminders = [[GLReminder remindersFromDictionaryValues:dictionaryValues] mutableCopy];
}

- (void)saveLocalRemindersToFile
{
    NSString *plistPath = [self plistPath];
    NSArray *dictionaryValues = [GLReminder dictionaryValuesFromReminders:self.localReminders];
    [dictionaryValues writeToFile:plistPath atomically:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LocalRemindersDidChangedNotification
                                                        object:self
                                                      userInfo:@{@"newLocalReminders": [self allLocalReminders]}];
}

- (NSString *)plistPath
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"localReminders.plist"];
    return plistPath;
}

@end
