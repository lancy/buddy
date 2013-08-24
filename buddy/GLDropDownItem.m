//
//  GLDropDownItem.m
//  buddy
//
//  Created by Lancy on 24/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLDropDownItem.h"

@implementation GLDropDownItem

- (id)initWithBuddy:(GLBuddy *)buddy
{
    self = [super init];
    if (self) {
        _buddy = buddy;
        self.cellIdentifier = @"GLDropDownCell";
    }
    return self;
}


@end
