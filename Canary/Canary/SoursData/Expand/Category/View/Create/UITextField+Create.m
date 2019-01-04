//
//  UITextField+Create.m
//  Canary
//
//  Created by litong on 2017/6/3.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "UITextField+Create.h"

@implementation UITextField (Create)

+ (UITextField *)fieldRect:(CGRect)rect font:(UIFont *)font textColor:(UIColor *)textColor {
    UITextField *field = [[UITextField alloc] init];
    field.frame = rect;
    field.font = font;
    field.textColor = textColor;
    return field;
}

+ (UITextField *)fieldRect:(CGRect)rect font:(UIFont *)font textColor:(UIColor *)textColor place:(NSString *)place {
    UITextField *field = [[UITextField alloc] init];
    field.frame = rect;
    field.font = font;
    field.textColor = textColor;
    field.placeholder = place;
    return field;
}

+ (UITextField *)fieldRect:(CGRect)rect font:(UIFont *)font textColor:(UIColor *)textColor place:(NSString *)place placeColor:(UIColor *)placeColor {
    UITextField *field = [[UITextField alloc] init];
    field.frame = rect;
    field.font = font;
    field.textColor = textColor;
    NSAttributedString *abstr = [place ABStrColor:placeColor range:NSMakeRange(0, place.length)];
    field.attributedPlaceholder = abstr;
    return field;
}

+ (UITextField *)fieldRect:(CGRect)rect font:(UIFont *)font textColor:(UIColor *)textColor place:(NSString *)place placeColor:(UIColor *)placeColor placeFont:(UIFont *)placeFont {
    UITextField *field = [[UITextField alloc] init];
    field.frame = rect;
    field.font = font;
    field.textColor = textColor;
    NSAttributedString *abstr = [place ABStrFont:font placeholderFont:placeFont color:placeColor];
    field.attributedPlaceholder = abstr;
    return field;
}


@end
