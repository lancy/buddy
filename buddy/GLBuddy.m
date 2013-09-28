//
//  GLBuddy.m
//  buddy
//
//  Created by Lancy on 11/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLBuddy.h"
#import "KZPropertyMapper.h"
#import "KZPropertyMapper+boxValueAsString.h"

@implementation GLBuddy

- (NSString *)description
{
    return [NSString stringWithFormat:@"phoneNumber = %@, contactName = %@, avatarUrl = %@, miss = %@", _phoneNumber, _contactName, _avatarUrl, _miss];
}

- (id)initWithJsonObject:(NSDictionary *)jsonObject
{
    self = [super init];
    if (self) {
        [KZPropertyMapper mapValuesFrom:jsonObject toInstance:self usingMapping:@{
            @"contactName": @"contactName",
            @"phoneNumber": @"@String(phoneNumber)",
            @"avatarUrl": @"avatarUrl",
            @"miss": @"miss",
            @"userIntimacy": @"userIntimacy"
         }];        
    }
    return self;
}


+ (NSArray *)buddysWithJsonObject:(NSDictionary *)jsonObject
{
    NSMutableArray *relatives = [[NSMutableArray alloc] init];
    for (NSDictionary *buddyJsonObject in jsonObject) {
        GLBuddy *buddy = [[GLBuddy alloc] initWithJsonObject:buddyJsonObject];
        [relatives addObject:buddy];
    }
    return relatives;
}

@end
