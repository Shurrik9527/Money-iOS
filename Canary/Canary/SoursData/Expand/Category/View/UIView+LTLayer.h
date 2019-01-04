//
//  UIView+LTLayer.h
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LTLayer)


#pragma mark - layer

/*!  边框颜色color，边宽width  */
- (void)borderColor:(UIColor *)color width:(CGFloat)width;

/*!  圆形，无边框  */
- (void)circleViwe;

/*!  半径r 背景颜色color */
- (void)layerRadius:(CGFloat)r bgColor:(UIColor *)color;

/*!  半径r 边宽width 边框颜色boColor */
- (void)layerRadius:(CGFloat)r borderColor:(UIColor *)boColor borderWidth:(CGFloat)width;

/*!  半径r 边宽width 边框颜色boColor 背景颜色color */
- (void)layerRadius:(CGFloat)r borderColor:(UIColor *)boColor borderWidth:(CGFloat)width bgColor:(UIColor *)bgColor;

//阴影尺寸、颜色
- (void)layerShadowOffset:(CGSize)size color:(UIColor *)color opacity:(CGFloat)opacity radius:(CGFloat)radius;

#pragma mark 设置部分圆角
/** 设置部分圆角(绝对布局) */
- (void)layerRadius:(CGFloat)r corners:(UIRectCorner)corners;
/** 设置部分圆角(相对布局) */
- (void)layerRadius:(CGFloat)r corners:(UIRectCorner)corners rect:(CGRect)rect;
- (void)layerRadius:(CGFloat)r corners:(UIRectCorner)corners rect:(CGRect)rect strokeColor:(UIColor *)strokeColor lineWidth:(CGFloat)lineWidth;
- (void)layerRadius:(CGFloat)r corners:(UIRectCorner)corners rect:(CGRect)rect borderColor:(UIColor *)borderColor borderWidth:(CGFloat)width shadowOffset:(CGSize)size shadowColor:(UIColor *)shadowColor;


@end
