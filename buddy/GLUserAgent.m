//
//  GLUserAgent.m
//  buddy
//
//  Created by Lancy on 4/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "AFNetworking.h"
#import "GLUserAgent.h"
#import "GLBuddyApiClient.h"
#import "GLBuddyManager.h"
#import "GLBuddy.h"
#import "GLReminder.h"

NSString * const GLUserRegisterDidSuccessNotificaton = @"GLUserRegisterDidSuccessNotificaton";


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
                                                GLUserType userType = [[JSON valueForKeyPath:@"user_type"] integerValue];
                                                [self setUserType:userType];
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
                    userName:(NSString *)userName
                 phoneNumber:(NSString *)phoneNumber
                    password:(NSString *)password
                       email:(NSString *)email
                   completed:(void (^)(APIStatusCode statusCode, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"userType": @(userType),
                                 @"phoneNumber": @([phoneNumber longLongValue]),
                                 @"password": password,
                                 @"email": (email? email: @""),
                                 @"userName": userName,
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

- (void)addRelativeWithPersonRef:(ABRecordRef)person
                         completed:(void (^)(APIStatusCode statusCode, NSError *error))block

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
    
    [self addRelativeWithPhoneNumber:phone contactName:fullName completed:block];
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
    [[GLBuddyApiClient sharedClient] postPath:@"get_relatives_list_with_miss/"
                                   parameters:nil
                                      success:^(AFHTTPRequestOperation *operation, id JSON) {
                                          NSArray *relatives = [GLBuddy buddysWithJsonObject:JSON[@"data"]];
                                          [[GLBuddyManager shareManager] setRemotesBuddys:relatives];
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

- (void)requestSendRemindToRelativeWithPhoneNumber:(NSString *)phoneNumber
                                        remindTime:(NSTimeInterval)remindTime
                                     audioFilePath:(NSString *)filePath
                                         completed:(void (^)(APIStatusCode statusCode, NSError *error))block
{
    NSData *audioData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    NSDictionary *parameters = @{
                                 @"friendPhoneNumber": @([phoneNumber integerValue]),
                                 @"remindTime": @(round(remindTime)),
                                 };
    NSMutableURLRequest *request = [[GLBuddyApiClient sharedClient] multipartFormRequestWithMethod:@"POST" path:@"send_remind_to_relative/" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:audioData name:@"audio" fileName:@"bra.aac" mimeType:@"audio/aac"];
    }];
    
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSNumber *statusCode = [responseObject valueForKeyPath:@"status_code"];
        if (block) {
            block([statusCode integerValue], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(APIStatusCodeError, error);

        }
    }];
    [[GLBuddyApiClient sharedClient] enqueueHTTPRequestOperation:operation];
}

- (void)requestRemindsWithCompletedBlock:(void (^)(APIStatusCode statusCode, NSArray *reminds, NSError *error))block
{
    [[GLBuddyApiClient sharedClient] postPath:@"get_remind_fifty_limit/"
                                   parameters:nil
                                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                          NSNumber *statusCode = responseObject[@"status_code"];
                                          NSArray *reminds = [GLReminder remindersFromJsonValues:responseObject[@"data"]];
                                          if (block) {
                                              block([statusCode integerValue], reminds, nil);
                                          }
    }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          if (block) {
                                              block(APIStatusCodeError, nil, error);
                                          }
        
    }];
    
}

- (NSString *) getAPIStatusCodeDescription:(APIStatusCode)APIStatusCode {
    const NSDictionary *mapping = @{
                              @(APIStatusCodeError): @"系统错误",
                              @(APIStatusCodeFileError): @"文件大小错误(>2MB)",
                              @(APIStatusCodeFileMiss): @"文件丢失",
                              @(APIStatusCodeFriendAddedError): @"添加好友错误",
                              @(APIStatusCodeFriendAddedSuccess): @"添加好友成功",
                              @(APIStatusCodeFriendNotRegistered): @"好友未注册",
                              @(APIStatusCodeNeedParams): @"参数不足",
                              @(APIStatusCodeOK): @"成功",
                              @(APIStatusCodeParamsError): @"参数类型错误",
                              @(APIStatusCodePasswordError): @"密码错误",
                              @(APIStatusCodeUsernameError): @"用户名错误",
                              };
    return [mapping objectForKey:@(APIStatusCode)];
}

- (void)requestSendMissToRelativeWithPhoneNumber:(NSString *)phoneNumber completed:(void (^)(APIStatusCode statusCode, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"friendPhoneNumber": @([phoneNumber integerValue]),
                                 };
    
    [[GLBuddyApiClient sharedClient] postPath:@"send_miss_to_relative/"
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

- (void)showErrorDialog:(APIStatusCode)statusCode {
    UIAlertView *av=[[UIAlertView alloc] initWithTitle:@"错误" message:[NSString stringWithFormat:@"错误代码：%d\n 错误原因：%@", statusCode, [[GLUserAgent sharedAgent] getAPIStatusCodeDescription:statusCode]  ] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [av show];
}

@end
