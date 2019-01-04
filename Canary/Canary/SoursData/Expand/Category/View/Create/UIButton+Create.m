//
//  UIButton+Create.m
//  Canary
//
//  Created by litong on 2017/5/11.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "UIButton+Create.h"

@implementation UIButton (Create)

/** UIControlStateNormal 、UIControlStateSelected 、UIControlStateHighlighted */
- (void)setTitleColorNSH:(UIColor *)color {
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateSelected];
    [self setTitleColor:color forState:UIControlStateHighlighted];
}

+ (UIButton *)btnWithCustom {
    return [UIButton buttonWithType:UIButtonTypeCustom];
}


+ (UIButton *)btnWithTarget:(id)target action:(SEL)action frame:(CGRect)frame {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+ (UIButton *)commitBlueBtn:(id)target action:(SEL)action y:(CGFloat)y text:(NSString *)text {
    CGRect frame = CGRectMake(kLeftMar, y, kMidW, 44);
    UIButton *btn = [UIButton commitBlueBtn:target action:action frame:frame text:text];
    return btn;
}
+ (UIButton *)commitBlueBtn:(id)target action:(SEL)action frame:(CGRect)frame text:(NSString *)text {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColorNSH:LTWhiteColor];
    btn.titleLabel.font = fontSiz(18);
    [btn layerRadius:3 bgColor:LTSureFontBlue];
    [btn setTitle:text forState:UIControlStateNormal];
    return btn;
}

+ (UIButton *)btnWithTarget:(id)target action:(SEL)action frame:(CGRect)frame imgName:(NSString *)imgName selImgName:(NSString *)selImgName {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.backgroundColor = [UIColor clearColor];
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selImgName] forState:UIControlStateSelected];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+ (UIButton *)btnWithTarget:(id)target action:(SEL)action frame:(CGRect)frame imgName:(NSString *)imgName HImgName:(NSString *)HImgName {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.backgroundColor = [UIColor clearColor];
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:HImgName] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+ (UIButton *)btnWithTarget:(id)target action:(SEL)action frame:(CGRect)frame bgImgName:(NSString *)bgImgName selBgImgName:(NSString *)selBgImgName {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.backgroundColor = [UIColor clearColor];
    [btn setBackgroundImage:[UIImage imageNamed:bgImgName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:selBgImgName] forState:UIControlStateSelected];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+ (UIButton *)btnWithTarget:(id)target action:(SEL)action frame:(CGRect)frame bgImgName:(NSString *)bgImgName HBgImgName:(NSString *)HBgImgName {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.backgroundColor = [UIColor clearColor];
    [btn setBackgroundImage:[UIImage imageNamed:bgImgName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:HBgImgName] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


@end
