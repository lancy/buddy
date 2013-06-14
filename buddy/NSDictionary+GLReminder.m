//
//  NSDictionary+GLReminder.m
//  buddy
//
//  Created by Lancy on 15/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "NSDictionary+GLReminder.h"

@implementation NSDictionary (GLReminder)

- (NSDate *)fireDate
{
    return [self valueForKey:@"fireDate"];
}
- (void)setFireDate:(NSDate *)fireDate
{
    [self setValue:fireDate forKey:@"fireDate"];
}

- (NSString *)audioFilePath
{
    return [self valueForKey:@"audioFilePath"];
}
- (void)setAudioFilePath:(NSString *)filePath
{
    [self setValue:filePath forKey:@"audioFilePath"];
}

@end
