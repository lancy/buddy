//
//  GLAudioPowerIndicatorView.h
//  buddy
//
//  Created by Lancy on 13/6/13.
//  Copyright (c) 2013 GraceLancy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLAudioPowerIndicatorView : UIView

@property (assign, nonatomic) CGFloat power;
@property (readonly, assign, getter = isAnimating) BOOL animating;

- (void)startAnimation;
- (void)stopAnimation;

@end
