//
//  GLReminderManager.m
//  buddy
//
//  Created by Lancy on 15/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLReminderManager.h"
#import "NSDictionary+GLReminder.h"

NSString * const BuddysDidChangedNotification = @"GLLocalRemindersDidChangedNotificaton";


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
    NSMutableDictionary *newReminder;
    [newReminder setFireDate:fireDate];
    [newReminder setAudioFilePath:audioFilePath];
    [self.localReminders addObject:newReminder];
    
    [self saveLocalRemindersToFile];
}

#pragma mark - file operation

- (void)loadLocalRemindersFromFile
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"localReminders.plist"];
    self.localReminders = [NSMutableArray arrayWithContentsOfFile:plistPath];
}

- (void)saveLocalRemindersToFile
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"localReminders.plist"];
    [self.localReminders writeToFile:plistPath atomically:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BuddysDidChangedNotification
                                                        object:self
                                                      userInfo:@{@"newLocalReminders": [self allLocalReminders]}];
}



@end
