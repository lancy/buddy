//
//  NSDictionary+GLBuddy.m
//  buddy
//
//  Created by Lancy on 10/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "NSDictionary+GLBuddy.h"

@implementation NSDictionary (GLBuddy)

- (NSString *)buddyName
{
    return [self valueForKey:@"buddyName"];
}

- (void)setBuddyName:(NSString *)buddyName
{
    [self setValue:buddyName forKey:@"buddyName"];
}

- (NSString *)buddyPhoneNumber
{
    return [self valueForKey:@"buddyPhoneNumber"];
}
- (void)setBuddyPhoneNumber:(NSString *)phoneNumber
{
    [self setValue:phoneNumber forKey:@"buddyPhoneNumber"];
}

- (NSString *)avatarPath
{
    return [self valueForKey:@"avatarPath"];
}
- (void)setAvatarPath:(NSString *)avatarPath
{
    [self setValue:avatarPath forKey:@"avatarPath"];
}



@end
