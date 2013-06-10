//
//  GLBuddyCell.h
//  buddy
//
//  Created by Lancy on 10/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLBuddyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

- (void)bindBuddyData:(NSDictionary *)buddy;

@end
