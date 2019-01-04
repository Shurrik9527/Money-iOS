//
//  UILabel+Create.m
//  Canary
//
//  Created by litong on 2017/6/3.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "UILabel+Create.h"

@implementation UILabel (Create)

+ (UILabel *)labRect:(CGRect)rect font:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = rect;
    lab.font = font;
    lab.textColor = textColor;
    return lab;
}

+ (UILabel *)labRect:(CGRect)rect font:(UIFont *)font textColor:(UIColor *)textColor text:(NSString *)text {
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = rect;
    lab.font = font;
    lab.textColor = textColor;
    lab.text = text;
    return lab;
}

@end
