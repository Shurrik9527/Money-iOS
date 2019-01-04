//
//  UIButton+Create.h
//  Canary
//
//  Created by litong on 2017/5/11.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Create)

/** UIControlStateNormal 、UIControlStateSelected 、UIControlStateHighlighted */
- (void)setTitleColorNSH:(UIColor *)color;

+ (UIButton *)btnWithCustom;

+ (UIButton *)btnWithTarget:(id)target action:(SEL)action frame:(CGRect)frame;
+ (UIButton *)commitBlueBtn:(id)target action:(SEL)action y:(CGFloat)y text:(NSString *)text;
+ (UIButton *)commitBlueBtn:(id)target action:(SEL)action frame:(CGRect)frame text:(NSString *)text;
//img
+ (UIButton *)btnWithTarget:(id)target action:(SEL)action frame:(CGRect)frame imgName:(NSString *)imgName selImgName:(NSString *)selImgName;
+ (UIButton *)btnWithTarget:(id)target action:(SEL)action frame:(CGRect)frame imgName:(NSString *)imgName HImgName:(NSString *)HImgName;

//bgimg
+ (UIButton *)btnWithTarget:(id)target action:(SEL)action frame:(CGRect)frame bgImgName:(NSString *)bgImgName selBgImgName:(NSString *)selBgImgName;
+ (UIButton *)btnWithTarget:(id)target action:(SEL)action frame:(CGRect)frame bgImgName:(NSString *)bgImgName HBgImgName:(NSString *)HBgImgName;

@end
