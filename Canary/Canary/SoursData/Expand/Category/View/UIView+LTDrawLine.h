//
//  UIView+LTDrawLine.h
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LTDrawLine)

+ (UIView *)lineFrame:(CGRect)frame color:(UIColor *)color;

- (void)addLine:(UIColor *)color frame:(CGRect)frame;
//画上下左右 线条宽高w or h
- (void)addLineTop:(UIColor *)color h:(CGFloat)h;
- (void)addLineBottom:(UIColor *)color h:(CGFloat)h;
- (void)addLineLeft:(UIColor *)color w:(CGFloat)w;
- (void)addLineRight:(UIColor *)color w:(CGFloat)w;

//画上下左右 线条宽高0.5
- (void)addLineTop:(UIColor *)color;
- (void)addLineBottom:(UIColor *)color;
- (void)addLineLeft:(UIColor *)color;
- (void)addLineRight:(UIColor *)color;

@end
