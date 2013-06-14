//
//  GLRecorderManager.m
//  buddy
//
//  Created by Lancy on 12/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import "GLAudioManager.h"
#import <AudioToolbox/AudioToolbox.h>


const int kRecordAudioFormat = kAudioFormatMPEG4AAC;

@interface GLAudioManager ()

@property (readwrite, assign, getter = isRecording) BOOL recording;
@property (readwrite, strong, nonatomic) NSURL *recordedFileUrl;
@property (readwrite, strong, nonatomic) NSString *currentRecordedTime;


@end

@implementation GLAudioManager

- (id)init
{
    if (self = [super init]) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
        
        if(session == nil)
            NSLog(@"Error creating session: %@", [sessionError description]);
        else
            [session setActive:YES error:nil];
        
        [self setRecording:NO];
    }
    return self;
}

- (float) micAveragePower
{
    [self.recorder updateMeters];
    float avgPower = [self.recorder averagePowerForChannel:0];
    return avgPower;
}


- (void)startRecord
{
    self.recordedFileUrl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]];

    
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 11025.0],                 AVSampleRateKey,
                              [NSNumber numberWithInt: kRecordAudioFormat], AVFormatIDKey,
                              [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMin],         AVEncoderAudioQualityKey,
                              nil];
    NSError *error;
    
    self.recorder = [[AVAudioRecorder alloc] initWithURL:self.recordedFileUrl settings:settings error:&error];
    
    if (self.recorder) {
        [self.recorder prepareToRecord];
        self.recorder.meteringEnabled = YES;
        [self setRecording:YES];
        [self.recorder record];
    } else {
        NSLog(@"%@",[error description]);
    }
}

- (void)stopRecord
{
    [self.recorder stop];
    [self setRecording:NO];
}

- (void)prepareCurrentAudio
{
    if (self.recordedFileUrl) {
        [self prepareAudioWithFileUrl:self.recordedFileUrl];
    }
}
- (void)prepareAudioWithFileUrl:(NSURL *)fileUrl
{
    #warning TODO exception handler
    NSError *error;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:&error];
    self.player.meteringEnabled = YES;

}


- (void)playCurrentAudio
{
    if (self.recordedFileUrl) {
        [self playAudioWithFileUrl:self.recordedFileUrl];
    }
    #warning TODO exception handler
}

- (void)playAudioWithFileUrl:(NSURL *)fileUrl
{
    if (self.player) {
        [self.player play];
    }
}




@end
