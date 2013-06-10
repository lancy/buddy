//
//  NSDictionary+GLBuddy.h
//  buddy
//
//  Created by Lancy on 10/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (GLBuddy)

- (NSString *)buddyName;
- (void)setBuddyName:(NSString *)buddyName;

- (NSString *)buddyPhoneNumber;
- (void)setBuddyPhoneNumber:(NSString *)phoneNumber;

- (NSString *)avatarPath;
- (void)setAvatarPath:(NSString *)avatarPath;

- (NSTimeInterval)lastMessageTimeStamp;
- (void)setLastMessageTimeStamp:(NSTimeInterval)timeStamp;

@end
