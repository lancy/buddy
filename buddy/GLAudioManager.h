//
//  GLRecorderManager.h
//  buddy
//
//  Created by Lancy on 12/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>


@interface GLAudioManager : NSObject

@property (readonly, strong, nonatomic) NSURL *recordedFileUrl;

- (float)micAveragePower;
- (void)startRecord;
- (void)stopRecord;

- (void)playCurrentAudio;
- (void)playAudioWithFileUrl:(NSURL *)fileUrl;


@end