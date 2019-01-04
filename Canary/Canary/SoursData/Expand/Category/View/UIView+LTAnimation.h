//
//  UIView+LTAnimation.h
//  Canary
//
//  Created by litong on 2017/1/5.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LTAnimationDuration  0.3    //动画时间

@interface UIView (LTAnimation)

- (void)animationPulseScale:(CGFloat)scale repeatCount:(float)repeatCount duration:(NSTimeInterval)duration;

- (void)animationRotate:(CGFloat)angle duration:(NSTimeInterval)duration fromRight:(BOOL)fromRight repeatCount:(NSUInteger)repeatCount autoreverse:(BOOL)shouldAutoreverse;
/** 横向摇动 */
- (void)animationShakeHorizontally;
- (void)animationShakeHorizontallyShort;

//subtype : 上0、下1、左2、右3
- (void)animationSingleViewPush:(NSInteger)subtype;



#pragma mark - CGAffineTransform

#pragma mark 旋转

/*!  旋转 */
- (void)rotate:(CGFloat)angle;

#pragma mark 移动

/*!  向X方向移动x，向Y方向移动y  */
- (void)moveX:(CGFloat)x Y:(CGFloat)y;
/*!  向X方向移动x  */
- (void)moveX:(CGFloat)x;
/*!  向Y方向移动y  */
- (void)moveY:(CGFloat)y;

#pragma mark 缩放

/*!  只缩放一次，X方向缩放x ，Y方向缩放y */
- (void)scaleOnceToX:(CGFloat)x Y:(CGFloat)y;
/*!  只缩放一次，X方向缩放x */
- (void)scaleOnceToX:(CGFloat)x;
/*!  只缩放一次，Y方向缩放y */
- (void)scaleOnceToY:(CGFloat)y;

/*!  多次缩放，X方向缩放x ，Y方向缩放y */
- (void)scaleWithX:(CGFloat)x Y:(CGFloat)y;
/*!  多次缩放，X方向缩放x */
- (void)scaleWithX:(CGFloat)x;
/*!  多次缩放，Y方向缩放y */
- (void)scaleWithY:(CGFloat)y;


@end
