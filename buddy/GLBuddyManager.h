//
//  GLBuddyManager.h
//  buddy
//
//  Created by Lancy on 10/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>

extern NSString * const BuddysDidChangedNotification;

@interface GLBuddyManager : NSObject

+ (GLBuddyManager *)shareManager;

- (NSArray *)allBuddys;
- (void)addNewBuddyWithPerson:(ABRecordRef)person;
- (void)addNewBuddyWithName:(NSString *)name phoneNumber:(NSString *)phoneNumber avatarPath:(NSString *)avatarPath;
- (void)updateBuddyMessageTimeWithIndex:(NSUInteger)index;
- (void)removeBuddyWithIndex:(NSUInteger)index;
- (void)clearAllBuddys;

- (BOOL)hasBuddyWithPhoneNumber:(NSString *)phoneNumber;

@end
