//
//  GLUserAgent.m
//  buddy
//
//  Created by Lancy on 4/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLUserAgent.h"
#import "GLBuddyApiClient.h"
#import "GLBuddy.h"
@implementation GLUserAgent

+ (GLUserAgent *)sharedAgent
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

- (void)loginWithPhoneNumber:(NSString *)phoneNumber
                    password:(NSString *)password
                   completed:(void (^)(APIStatusCode statusCode, GLUserType userType, NSError *error))block
{
    NSDictionary *parameters = @{
                                     @"phoneNumber": @([phoneNumber integerValue]),
                                     @"password": password
                                 };
    [[GLBuddyApiClient sharedClient] postPath:@"login/"
                                  parameters:parameters
                                     success:^(AFHTTPRequestOperation *operation, id JSON) {
                                                NSNumber *statusCode = [JSON valueForKeyPath:@"status_code"];
                                                GLUserType userType = [[JSON valueForKeyPath:@"userType"] integerValue];
                                                if (block) {
                                                    block([statusCode integerValue], userType, nil);
                                                }
                                            }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            if (block) {
                                                block(APIStatusCodeError, 0, error);
                                            }
    }];
}

- (void)registerWithUserType:(GLUserType)userType
                 phoneNumber:(NSString *)phoneNumber
                    password:(NSString *)password
                       email:(NSString *)email
                   completed:(void (^)(APIStatusCode statusCode, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"userTpye": @(userType),
                                 @"phoneNumber": @([phoneNumber integerValue]),
                                 @"password": password,
                                 @"email": (email? email: @""),
                                 };
    [[GLBuddyApiClient sharedClient] postPath:@"register/"
                                   parameters:parameters
                                      success:^(AFHTTPRequestOperation *operation, id JSON) {
                                          NSNumber *statusCode = [JSON valueForKeyPath:@"status_code"];
                                          if (block) {
                                              block([statusCode integerValue], nil);
                                          }
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          if (block) {
                                              block(APIStatusCodeError, error);
                                          }
                                      }];
}

- (void)updatePushTokenWithPushToken:(NSString *)pushToken
                           completed:(void (^)(APIStatusCode statusCode, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"pushToken": pushToken
                                 };
    [[GLBuddyApiClient sharedClient] postPath:@"update_token/"
                                   parameters:parameters
                                      success:^(AFHTTPRequestOperation *operation, id JSON) {
                                          NSNumber *statusCode = [JSON valueForKeyPath:@"status_code"];
                                          if (block) {
                                              block([statusCode integerValue], nil);
                                          }
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          if (block) {
                                              block(APIStatusCodeError, error);
                                          }
                                      }];

}

- (void)updateAvatarWithAvatarImage:(UIImage *)avatarImage
                          completed:(void (^)(APIStatusCode statusCode, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"avatar": UIImageJPEGRepresentation(avatarImage, 1)
                                 };
    
    [[GLBuddyApiClient sharedClient] postPath:@"update_avatar/"
                                   parameters:parameters
                                      success:^(AFHTTPRequestOperation *operation, id JSON) {
                                          NSNumber *statusCode = [JSON valueForKeyPath:@"status_code"];
                                          if (block) {
                                              block([statusCode integerValue], nil);
                                          }
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          if (block) {
                                              block(APIStatusCodeError, error);
                                          }
                                      }];

}

- (void)addRelativeWithPhoneNumber:(NSString *)phoneNumber
                       contactName:(NSString *)contactName
                         completed:(void (^)(APIStatusCode statusCode, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"phoneNumber": @([phoneNumber integerValue]),
                                 @"contactName": contactName
                                 };
    
    [[GLBuddyApiClient sharedClient] postPath:@"add_relatives/"
                                   parameters:parameters
                                      success:^(AFHTTPRequestOperation *operation, id JSON) {
                                          NSNumber *statusCode = [JSON valueForKeyPath:@"status_code"];
                                          if (block) {
                                              block([statusCode integerValue], nil);
                                          }
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          if (block) {
                                              block(APIStatusCodeError, error);
                                          }
                                      }];    
}

- (void)requestRelativesListWithCompletedBlock:(void (^)(NSArray *relatives, NSError *error))block
{
    [[GLBuddyApiClient sharedClient] postPath:@"get_relatives_list/"
                                   parameters:nil
                                      success:^(AFHTTPRequestOperation *operation, id JSON) {
                                          NSArray *relatives = [GLBuddy buddysWithJsonObject:JSON];
                                          if (block) {
                                              block(relatives, nil);
                                          }
                                      }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          if (block) {
                                              block([NSArray array], error);
                                          }
                                      }];
}


@end
