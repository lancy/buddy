//
//  GLAudioPowerIndicatorView.m
//  buddy
//
//  Created by Lancy on 13/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GLAudioPowerIndicatorView.h"

@interface GLAudioPowerIndicatorView ()

@property (strong, nonatomic) UIImageView *micIconView;
@property (strong, nonatomic) UIImageView *powerIndicatorView;
@property (strong, nonatomic) UIImageView *waveAnimationView;

@property (readwrite, assign, getter = isAnimating) BOOL animating;
@property CGRect setupFrame;

@end

@implementation GLAudioPowerIndicatorView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initSubview];
        [self resetSubview];
    }
    return self;
}

- (void)initSubview
{
    self.powerIndicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"record_power_indicator.png"]];
    [self addSubview:self.powerIndicatorView];
    
    self.waveAnimationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"record_wave_animation.png"]];
    [self addSubview:self.waveAnimationView];
    
    self.micIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"record_mic_icon.png"]];
    [self addSubview:self.micIconView];
}

- (void)resetSubview
{
    #warning TODO: auto resizing
    self.setupFrame = CGRectMake(87.5, 87.5, 75, 75);
    [self.powerIndicatorView setFrame:self.setupFrame];
    [self.waveAnimationView setFrame:self.setupFrame];
    [self.micIconView setFrame:self.setupFrame];
}

- (void)startAnimation
{
    [self resetSubview];
    [self setAnimating:YES];
    
    [UIView animateWithDuration: 1.5
                          delay: 0
                        options: UIViewAnimationOptionOverrideInheritedCurve |
     UIViewAnimationCurveEaseOut |
     UIViewAnimationOptionOverrideInheritedDuration |
     UIViewAnimationOptionRepeat
                     animations:^{
                         self.waveAnimationView.frame = CGRectMake(0, 0, 250, 250);
                         self.waveAnimationView.alpha = 0;
                         if (self.isAnimating) {
                             [UIView setAnimationRepeatCount:2];
                         } else {
                             [UIView setAnimationRepeatCount:0];
                         }
                     }
                     completion:^(BOOL finished) {
                         self.waveAnimationView.frame = self.setupFrame;
                         self.waveAnimationView.alpha = 1;
                     }];
}

- (void)stopAnimation
{
    [self setAnimating:NO];
    [self resetSubview];
}

- (void)setPower:(CGFloat)power
{
    _power = power;
    if (self.isAnimating) {
        [UIView animateWithDuration:0.1
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGFloat resizePoint = -(power + 70);
                             CGRect newFrame = CGRectInset(self.setupFrame, resizePoint, resizePoint);
                             self.powerIndicatorView.frame = newFrame;
                         }
                         completion:^(BOOL finished) {
                         }
         ];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
