//
//  UIView+WQView.m
//  Canary
//
//  Created by Brain on 2017/5/27.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "UIView+WQView.h"

@implementation UIView (WQView)
//横向线
+ (UIView *)HLineViewFrame:(CGRect)frame color:(UIColor *)color {
    UIView *lView = [[UIView alloc] init] ;
    lView.frame = frame;
    lView.backgroundColor = color;
    return lView;
}

//竖向线
+ (UIView *)VLineViewFrame:(CGRect)frame color:(UIColor *)color {
    UIView *lView = [[UIView alloc] init] ;
    lView.frame = frame;
    lView.backgroundColor = color;
    return lView;
}


@end
