//
//  GLUserAgent.h
//  buddy
//
//  Created by Lancy on 4/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLBuddyApiClient.h"


typedef enum {
    GLUserTypeOld = 0,
    GLUserTypeYoung = 1
} GLUserType;

@interface GLUserAgent : NSObject

+ (GLUserAgent *)sharedAgent;

- (void)loginWithPhoneNumber:(NSString *)phoneNumber
                    password:(NSString *)password
                   completed:(void (^)(APIStatusCode statusCode, NSError *error))block;

- (void)registerWithUserType:(GLUserType)userType
                 phoneNumber:(NSString *)phoneNumber
                    password:(NSString *)password
                       email:(NSString *)email
                   completed:(void (^)(APIStatusCode statusCode, NSError *error))block;

- (void)updatePushTokenWithPushToken:(NSString *)pushToken
                           completed:(void (^)(APIStatusCode statusCode, NSError *error))block;

- (void)updateAvatarWithAvatarImage:(UIImage *)avatarImage
                          completed:(void (^)(APIStatusCode statusCode, NSError *error))block;

- (void)addRelativeWithPhoneNumber:(NSString *)phoneNumber
                       contactName:(NSString *)contactName
                         completed:(void (^)(APIStatusCode statusCode, NSError *error))block;

- (void)requestRelativesListWithCompletedBlock:(void (^)(NSArray *relatives, NSError *error))block;

@end
