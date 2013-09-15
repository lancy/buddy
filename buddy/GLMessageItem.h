//
//  GLMessageItem.h
//  buddy
//
//  Created by Lancy on 11/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "RETableViewItem.h"
#import "GLBuddy.h"

@interface GLMessageItem : RETableViewItem

@property (copy, nonatomic) GLBuddy *buddy;
@property (assign, nonatomic) BOOL isSent;

- (id)initWithBuddy:(GLBuddy *)buddy;


@end
