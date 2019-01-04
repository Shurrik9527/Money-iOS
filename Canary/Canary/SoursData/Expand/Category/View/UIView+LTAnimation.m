//
//  UIView+LTAnimation.m
//  Canary
//
//  Created by litong on 2017/1/5.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "UIView+LTAnimation.h"

#define CABA_TS  @"transform.scale"
#define CABA_TRY  @"transform.rotation.y"


@implementation UIView (LTAnimation)

- (void)animationPulseScale:(CGFloat)scale repeatCount:(float)repeatCount duration:(NSTimeInterval)duration {
    
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:CABA_TS];
    
    pulseAnimation.duration = duration;
    pulseAnimation.toValue = @(scale);
    pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulseAnimation.autoreverses = YES;
    pulseAnimation.repeatCount = repeatCount;
    
    [self.layer addAnimation:pulseAnimation forKey:@"pulse"];
}



- (void)animationRotate:(CGFloat)angle duration:(NSTimeInterval)duration fromRight:(BOOL)fromRight repeatCount:(NSUInteger)repeatCount autoreverse:(BOOL)shouldAutoreverse {
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:CABA_TRY];
    rotationAnimation.toValue = @(fromRight ? angle : -angle);
    rotationAnimation.duration = duration;
    rotationAnimation.autoreverses = shouldAutoreverse;
    rotationAnimation.repeatCount = repeatCount;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:rotationAnimation forKey:CABA_TRY];
}


/** 横向摇动 */
- (void)animationShakeHorizontally {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = LTAnimationDuration;
    animation.values = @[@(-12), @(12), @(-8), @(8), @(-4), @(4), @(0) ];
    
    [self.layer addAnimation:animation forKey:@"shake"];
}

/** 横向摇动 */
- (void)animationShakeHorizontallyShort {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = LTAnimationDuration;
    animation.values = @[@(-9), @(9), @(-6), @(6), @(-3), @(2), @(0) ];
    
    [self.layer addAnimation:animation forKey:@"shake"];
}

#define kCATransitionSubtypes    @[kCATransitionFromTop,kCATransitionFromBottom,kCATransitionFromLeft,kCATransitionFromRight]
//subtype : 上0、下1、左2、右3
- (void)animationSingleViewPush:(NSInteger)subtype {
    if (subtype>3 || subtype<0) {
        subtype = 0;
    }
    CATransition *animation = [CATransition animation];//初始化动画
    animation.duration = LTAnimationDuration;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionSubtypes[subtype];
    [self.layer addAnimation:animation forKey:@"animationID"];
}






#pragma mark - CGAffineTransform

#pragma mark 旋转

/*!  旋转 */
- (void)rotate:(CGFloat)angle {
    self.transform = CGAffineTransformRotate(self.transform, angle);
}

#pragma mark 移动

/*!  向X方向移动x，向Y方向移动y  */
- (void)moveX:(CGFloat)x Y:(CGFloat)y {
    self.transform = CGAffineTransformTranslate(self.transform, x, y);
}
/*!  向X方向移动x  */
- (void)moveX:(CGFloat)x {
    [self moveX:x Y:0];
}
/*!  向Y方向移动y  */
- (void)moveY:(CGFloat)y {
    [self moveX:0 Y:y];
}

#pragma mark 缩放

/*!  只缩放一次，X方向缩放x ，Y方向缩放y */
- (void)scaleOnceToX:(CGFloat)x Y:(CGFloat)y {
    self.transform = CGAffineTransformMakeScale(x, y);
}
/*!  只缩放一次，X方向缩放x */
- (void)scaleOnceToX:(CGFloat)x {
    [self scaleOnceToX:x Y:1];
}
/*!  只缩放一次，Y方向缩放y */
- (void)scaleOnceToY:(CGFloat)y {
    [self scaleOnceToX:1 Y:y];
}

/*!  多次缩放，X方向缩放x ，Y方向缩放y */
- (void)scaleWithX:(CGFloat)x Y:(CGFloat)y {
    self.transform = CGAffineTransformScale(self.transform, x, y);
}
/*!  多次缩放，X方向缩放x */
- (void)scaleWithX:(CGFloat)x {
    [self scaleWithX:x Y:1];
}
/*!  多次缩放，Y方向缩放y */
- (void)scaleWithY:(CGFloat)y {
    [self scaleWithX:1 Y:y];
}

@end
