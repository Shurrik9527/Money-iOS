//
//  UILabel+Create.h
//  Canary
//
//  Created by litong on 2017/6/3.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Create)

+ (UILabel *)labRect:(CGRect)rect font:(UIFont *)font textColor:(UIColor *)textColor;
+ (UILabel *)labRect:(CGRect)rect font:(UIFont *)font textColor:(UIColor *)textColor text:(NSString *)text;

@end
