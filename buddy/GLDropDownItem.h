//
//  GLDropDownItem.h
//  buddy
//
//  Created by Lancy on 24/8/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "RETableViewItem.h"
#import "GLBuddy.h"

@interface GLDropDownItem : RETableViewItem

@property (copy, nonatomic) GLBuddy *buddy;
@property (copy, readwrite, nonatomic) void (^phoneHandler)(GLDropDownItem *item);
@property (copy, readwrite, nonatomic) void (^reminderHandler)(GLDropDownItem *item);
@property (copy, readwrite, nonatomic) void (^messageHandler)(GLDropDownItem *item);


- (id)initWithBuddy:(GLBuddy *)buddy;


@end
