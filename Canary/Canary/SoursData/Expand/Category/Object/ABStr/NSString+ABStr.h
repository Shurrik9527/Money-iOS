//
//  NSString+ABStr.h
//  LTDevDemo
//
//  Created by litong on 2017/1/7.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (ABStr)

#pragma mark - 富媒体文本

- (NSAttributedString *)ABStrColor:(UIColor *)color range:(NSRange)range;
- (NSAttributedString *)ABStrFont:(UIFont *)font range:(NSRange)range;
- (NSAttributedString *)ABStrColor:(UIColor *)color font:(UIFont *)font range:(NSRange)range;
- (NSAttributedString *)ABStrColor:(UIColor *)color font:(UIFont *)font;
- (NSAttributedString *)ABStrFont:(UIFont *)font color:(UIColor *)color;
//当placeholder 比 text的字体小的时候，使用该方法
- (NSAttributedString *)ABStrFont:(UIFont *)font placeholderFont:(UIFont *)placeholderFont color:(UIColor *)color;

//删除线
- (NSAttributedString *)ABStrStrikethrough;
- (NSAttributedString *)ABStrStrikethroughWithFont:(UIFont *)font color:(UIColor *)color;

//下划线
- (NSAttributedString *)ABStrUnderlineSpacing:(CGFloat)lineSpacing font:(UIFont *)font color:(UIColor *)color;

//行间距
- (NSAttributedString *)ABStrSpacing:(CGFloat)lineSpacing font:(UIFont *)font;
- (NSAttributedString *)ABStrSpacing:(CGFloat)lineSpacing font:(UIFont *)font color:(UIColor *)color;
- (NSAttributedString *)ABStrSpacing:(CGFloat)lineSpacing firstLineHeadIndent:(CGFloat)firstLineHeadIndent font:(UIFont *)font;

@end
