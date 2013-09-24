//
//  GLBuddyManager.h
//  buddy
//
//  Created by Lancy on 10/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>

extern NSString * const BuddysDidChangedNotification;

@interface GLBuddyManager : NSObject

+ (GLBuddyManager *)shareManager;

@property (strong, nonatomic) NSArray *remotesBuddys;

@end
