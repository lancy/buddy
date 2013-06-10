//
//  GLBuddyManager.m
//  buddy
//
//  Created by Lancy on 10/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLBuddyManager.h"

#import "NSMutableDictionary+GLBuddy.h"

NSString * const BuddysDidChangedNotification = @"GLBuddysDidChangedNotificaton";

@interface GLBuddyManager()

@property (strong, nonatomic) NSMutableArray *buddys;

@end

@implementation GLBuddyManager

+ (GLBuddyManager *)shareManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}


- (NSArray *)allBuddys
{
    return [self.buddys copy];
}

- (NSMutableArray *)buddys
{
    if (!_buddys) {
        [self loadBuddysFromFile];
    }
    return _buddys;
}

- (void)addNewBuddyWithName:(NSString *)name
                phoneNumber:(NSString *)phoneNumber
                 avatarPath:(NSString *)avatarPath
{
    NSMutableDictionary *newBuddy = [[NSMutableDictionary alloc] init];
    [newBuddy setBuddyName:name];
    [newBuddy setBuddyPhoneNumber:phoneNumber];
    [newBuddy setAvatarPath:avatarPath];
    
    [self.buddys addObject:[newBuddy copy]];
    [self saveBuddysToFile];
    [[NSNotificationCenter defaultCenter] postNotificationName:BuddysDidChangedNotification
                                                        object:self
                                                      userInfo:@{@"newBuddys": [self allBuddys]}];
}

#pragma mark - file operation

- (void)loadBuddysFromFile
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"buddys.plist"];
    _buddys = [NSMutableArray arrayWithContentsOfFile:plistPath];
}

- (void)saveBuddysToFile
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"buddys.plist"];
    [_buddys writeToFile:plistPath atomically:YES];
}


@end
