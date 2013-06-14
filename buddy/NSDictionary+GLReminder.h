//
//  NSDictionary+GLReminder.h
//  buddy
//
//  Created by Lancy on 15/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (GLReminder)

- (NSDate *)fireDate;
- (void)setFireDate:(NSDate *)fireDate;

- (NSString *)audioFilePath;
- (void)setAudioFilePath:(NSString *)filePath;



@end
