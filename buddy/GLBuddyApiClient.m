//
//  GLBuddyApiClient.m
//  buddy
//
//  Created by Lancy on 4/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLBuddyApiClient.h"

#import "AFJSONRequestOperation.h"

static NSString * const kGLBuddyAPIBaseURLString = @"http://app100718308.t.tqapp.cn/";

@implementation GLBuddyApiClient

+ (GLBuddyApiClient *)sharedClient {
    static GLBuddyApiClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[GLBuddyApiClient alloc] initWithBaseURL:[NSURL URLWithString:kGLBuddyAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    return self;
}

@end
