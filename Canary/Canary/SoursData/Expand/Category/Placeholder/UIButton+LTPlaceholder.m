//
//  UIButton+LTPlaceholder.m
//  ixit
//
//  Created by litong on 2017/1/13.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "UIButton+LTPlaceholder.h"

@implementation UIButton (LTPlaceholder)

//生成 view.size大小 的默认图片
- (UIImage *)placeholderDefaultImage {
    return [self placeholderDefaultImage:LTBgRGB];
}
- (UIImage *)placeholderDefaultImage:(UIColor *)bgColor {
    CGSize size = self.frame.size;
    CGFloat sw = size.width;
    CGFloat sh = size.height;
    CGRect rect = CGRectMake(0.0f, 0.0f, sw, sh);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [bgColor CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *img = [UIImage imageNamed:@"placeholderDefaultIcon"];
    CGFloat imgw = sw*0.3;
    CGFloat imgh = imgw*(img.size.height/img.size.width);
    [img drawInRect:CGRectMake((sw - imgw)*0.5,(sh - imgh)*0.5, imgw, imgh)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
