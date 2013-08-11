//
//  GLBuddyCell.h
//  buddy
//
//  Created by Lancy on 10/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RETableViewCell.h"
#import "GLBuddyItem.h"

@interface GLBuddyCell : RETableViewCell

@property (strong, nonatomic) GLBuddyItem *item;

@end
