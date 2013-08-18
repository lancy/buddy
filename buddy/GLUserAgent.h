//
//  GLUserAgent.h
//  buddy
//
//  Created by Lancy on 4/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>
#import "GLBuddyApiClient.h"


typedef enum {
    GLUserTypeOld = 0,
    GLUserTypeYoung = 1
} GLUserType;

@interface GLUserAgent : NSObject

+ (GLUserAgent *)sharedAgent;

// utils methods

@property (assign, nonatomic) GLUserType userType;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *contactName;
@property (strong, nonatomic) UIImage *avatarImage;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *email;


// request methods

- (void)loginWithPhoneNumber:(NSString *)phoneNumber
                    password:(NSString *)password
                   completed:(void (^)(APIStatusCode statusCode, GLUserType userType, NSError *error))block;

- (void)registerWithUserType:(GLUserType)userType
                    userName:(NSString *)userName
                 phoneNumber:(NSString *)phoneNumber
                    password:(NSString *)password
                       email:(NSString *)email
                   completed:(void (^)(APIStatusCode statusCode, NSError *error))block;



- (void)updatePushTokenWithPushToken:(NSString *)pushToken
                           completed:(void (^)(APIStatusCode statusCode, NSError *error))block;

- (void)updateAvatarWithAvatarImage:(UIImage *)avatarImage
                          completed:(void (^)(APIStatusCode statusCode, NSError *error))block;

- (void)addRelativeWithPersonRef:(ABRecordRef)person
                       completed:(void (^)(APIStatusCode statusCode, NSError *error))block;

- (void)addRelativeWithPhoneNumber:(NSString *)phoneNumber
                       contactName:(NSString *)contactName
                         completed:(void (^)(APIStatusCode statusCode, NSError *error))block;

- (void)requestRelativesListWithCompletedBlock:(void (^)(NSArray *relatives, NSError *error))block;

@end
