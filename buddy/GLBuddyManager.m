//
//  GLBuddyManager.m
//  buddy
//
//  Created by Lancy on 10/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLBuddyManager.h"

#import "NSDictionary+GLBuddy.h"

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
        if (!_buddys) {
            _buddys = [[NSMutableArray alloc] init];
        }
    }
    return _buddys;
}

- (void)addNewBuddyWithPerson:(ABRecordRef)person
{
    // get full name
    NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                    kABPersonFirstNameProperty);
    NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                         kABPersonLastNameProperty);
    NSString *fullName;
    if (firstName && lastName) {
        fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    } else if (firstName) {
        fullName = firstName;
    } else {
        fullName = lastName;
    }
    
    // get phone number
    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
                                                     kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        phone = @"[None]";
    }
    CFRelease(phoneNumbers);
    
    // get avatar image
    NSData  *imgData = (__bridge_transfer NSData *) ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *avatarPath = [documentsDirectory stringByAppendingPathComponent:fullName];
    [imgData writeToFile:avatarPath atomically:YES];
    
    // add to buddys lists
    [self addNewBuddyWithName:fullName phoneNumber:phone avatarPath:avatarPath];
}

- (void)addNewBuddyWithName:(NSString *)name
                phoneNumber:(NSString *)phoneNumber
                 avatarPath:(NSString *)avatarPath
{
    NSMutableDictionary *newBuddy = [[NSMutableDictionary alloc] init];
    [newBuddy setBuddyName:name];
    [newBuddy setBuddyPhoneNumber:phoneNumber];
    [newBuddy setAvatarPath:avatarPath];
    
    [self.buddys addObject:newBuddy];
    [self saveBuddysToFile];
}

- (void)updateBuddyMessageTimeWithIndex:(NSUInteger)index
{
    NSTimeInterval currentTimeStamp = [[NSDate date] timeIntervalSince1970];
    [self.buddys[index] setLastMessageTimeStamp:currentTimeStamp];
    [self saveBuddysToFile];
}

- (void)removeBuddyWithIndex:(NSUInteger)index
{
    [self.buddys removeObjectAtIndex:index];
    [self saveBuddysToFile];
}


- (void)clearAllBuddys
{
    self.buddys = [[NSMutableArray alloc] init];
    [self saveBuddysToFile];
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BuddysDidChangedNotification
                                                        object:self
                                                      userInfo:@{@"newBuddys": [self allBuddys]}];

}


@end
