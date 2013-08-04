//
//  GLBuddyApiClient.h
//  buddy
//
//  Created by Lancy on 4/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

typedef enum {
    APIStatusCodeError = 0,
    APIStatusCodeOK = 1,
    APIStatusCodeNeedParams = 2, //参数缺失
    APIStatusCodeParamsError = 3, //参数类型错误
    APIStatusCodePasswordError = 4,  //登陆密码错误
    APIStatusCodeUsernameError = 5,  //登陆用户名错误
    APIStatusCodeFileError = 6, //文件过大 or 没有
    APIStatusCodeFileMiss = 7, //文件不见了
    APIStatusCodeFriendNotRegistered = 8, //好友没注册哦
    APIStatusCodeFriendAddedSuccess = 9, //添加好友成功
    APIStatusCodeFriendAddedError = 10, //添加好友失败
} APIStatusCode;

@interface GLBuddyApiClient : AFHTTPClient

+ (GLBuddyApiClient *)sharedClient;

@end
