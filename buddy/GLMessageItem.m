//
//  GLMessageItem.m
//  buddy
//
//  Created by Lancy on 11/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLMessageItem.h"

@implementation GLMessageItem

- (id)initWithBuddy:(GLBuddy *)buddy
{
    self = [super init];
    if (self) {
        _buddy = buddy;
        self.cellIdentifier = @"GLMessageCell";
    }
    return self;
}


@end
