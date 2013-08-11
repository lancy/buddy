//
//  GLBuddyItem.h
//  buddy
//
//  Created by Lancy on 11/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "RETableViewItem.h"
#import "GLBuddy.h"

@interface GLBuddyItem : RETableViewItem

@property (copy, nonatomic) GLBuddy *buddy;

- (id)initWithBuddy:(GLBuddy *)buddy;

@end
