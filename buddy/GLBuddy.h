//
//  GLBuddy.h
//  buddy
//
//  Created by Lancy on 11/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLBuddy : NSObject

@property (copy, nonatomic) NSString *contactName;
@property (copy, nonatomic) NSString *phoneNumber;
@property (copy, nonatomic) NSString *avatarUrl;

- (id)initWithJsonObject:(NSDictionary *)jsonObject;
+ (NSArray *)buddysWithJsonObject:(NSDictionary *)jsonObject;

@end
