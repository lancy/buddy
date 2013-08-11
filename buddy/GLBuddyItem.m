//
//  GLBuddyItem.m
//  buddy
//
//  Created by Lancy on 11/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLBuddyItem.h"

@implementation GLBuddyItem

- (id)initWithBuddy:(GLBuddy *)buddy
{
    self = [super init];
    if (self) {
        _buddy = buddy;
        self.cellIdentifier = @"GLBuddyCell";
    }
    return self;
}

@end
