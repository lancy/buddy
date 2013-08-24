//
//  GLChildBuddyItem.h
//  buddy
//
//  Created by Lancy on 24/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "RETableViewItem.h"
#import "GLBuddy.h"

@interface GLChildBuddyItem : RETableViewItem

@property (copy, nonatomic) GLBuddy *buddy;

- (id)initWithBuddy:(GLBuddy *)buddy;


@end
