//
//  GLBuddyManager.m
//  buddy
//
//  Created by Lancy on 10/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLBuddyManager.h"
#import "GLBuddy.h"
NSString * const BuddysDidChangedNotification = @"GLBuddysDidChangedNotificaton";

@interface GLBuddyManager()

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


- (GLBuddy *)buddyFromRemotesWithPhoneNumber:(NSString *)phoneNumber
{
    for (GLBuddy *buddy in self.remotesBuddys) {
        if ([buddy.phoneNumber isEqualToString:phoneNumber]) {
            return buddy;
        }
    }
    return nil;
}

@end
