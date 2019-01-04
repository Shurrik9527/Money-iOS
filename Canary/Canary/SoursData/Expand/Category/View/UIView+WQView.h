//
//  UIView+WQView.h
//  Canary
//
//  Created by Brain on 2017/5/27.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WQView)
//横向线
+ (UIView *)HLineViewFrame:(CGRect)frame color:(UIColor *)color;
//竖向线
+ (UIView *)VLineViewFrame:(CGRect)frame color:(UIColor *)color;


@end
