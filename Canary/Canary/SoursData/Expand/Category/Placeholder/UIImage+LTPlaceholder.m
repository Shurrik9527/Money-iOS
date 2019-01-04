//
//  UIImage+LTPlaceholder.m
//  ixit
//
//  Created by litong on 2017/1/13.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "UIImage+LTPlaceholder.h"

@implementation UIImage (LTPlaceholder)

static CGFloat iconWithScale = 0.3;
+ (UIImage *)imageBgColor:(UIColor *)bgColor size:(CGSize)size iconName:(NSString *)iconName iconWidth:(CGFloat)iconWidth {
    CGFloat sw = size.width;
    CGFloat sh = size.height;
    CGRect rect = CGRectMake(0.0f, 0.0f, sw, sh);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [bgColor CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *img = [UIImage imageNamed:iconName];
    CGFloat imgw = (iconWidth==0) ? sw*iconWithScale : iconWidth;
    CGFloat imgh = imgw*(img.size.height/img.size.width);
    [img drawInRect:CGRectMake((sw - imgw)*0.5,(sh - imgh)*0.5, imgw, imgh)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
