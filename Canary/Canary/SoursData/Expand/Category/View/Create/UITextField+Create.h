//
//  UITextField+Create.h
//  Canary
//
//  Created by litong on 2017/6/3.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Create)

+ (UITextField *)fieldRect:(CGRect)rect font:(UIFont *)font textColor:(UIColor *)textColor;

+ (UITextField *)fieldRect:(CGRect)rect font:(UIFont *)font textColor:(UIColor *)textColor place:(NSString *)place;

+ (UITextField *)fieldRect:(CGRect)rect font:(UIFont *)font textColor:(UIColor *)textColor place:(NSString *)place placeColor:(UIColor *)placeColor;

+ (UITextField *)fieldRect:(CGRect)rect font:(UIFont *)font textColor:(UIColor *)textColor place:(NSString *)place placeColor:(UIColor *)placeColor placeFont:(UIFont *)placeFont;

@end
