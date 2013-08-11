//
//  GLReminderCell.h
//  buddy
//
//  Created by Lancy on 10/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RETableViewCell.h"
#import "GLReminderItem.h"

@interface GLReminderCell : RETableViewCell

@property (strong, nonatomic) GLReminderItem *item;

@end
