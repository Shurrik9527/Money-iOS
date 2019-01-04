//
//  UIImage+LTPlaceholder.h
//  ixit
//
//  Created by litong on 2017/1/13.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LTPlaceholder)

/** 生成图片
 bgColor：图片背景色
 size：图片尺寸
 iconName：居中icon的图片名称
 iconWidth：icon的宽度，默认值->size.width*0.3
 */
+ (UIImage *)imageBgColor:(UIColor *)bgColor size:(CGSize)size iconName:(NSString *)iconName iconWidth:(CGFloat)iconWidth;

@end
