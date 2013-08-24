//
//  GLChildBuddyItem.m
//  buddy
//
//  Created by Lancy on 24/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLChildBuddyItem.h"

@implementation GLChildBuddyItem

- (id)initWithBuddy:(GLBuddy *)buddy
{
    self = [super init];
    if (self) {
        _buddy = buddy;
        self.cellIdentifier = @"GLChildBuddyCell";
    }
    return self;
}

@end
