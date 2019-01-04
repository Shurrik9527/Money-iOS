//
//  NSString+LT.h
//  LTDevDemo
//
//  Created by litong on 2017/1/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define emptyStr(str)            [NSString emptyString:str]
#define notemptyStr(str)        [NSString notEmptyString:str]

@interface NSString (LT)

#pragma mark - 判空

/** 是否为空(nil、NULL、[NSNull class]、空格)字符串
 * 空：yes   非空：no  */
+ (BOOL)emptyString:(NSString *)str;
+ (BOOL)notEmptyString:(NSString *)str;

#pragma mark - 计算字符串宽高
-(CGSize)sizeWithFont:(UIFont *)font;
- (CGSize)boundingSize:(CGSize)size font:(UIFont *)font;
//计算文字高度
- (CGSize)boundingH:(CGFloat)maxW font:(UIFont *)font;
//计算文字宽度
- (CGSize)boundingW:(CGFloat)maxH font:(UIFont *)font;
- (CGFloat)autoFitW:(CGFloat)fs;

#pragma mark - 常用系统方法

- (NSString *)replacStr:(NSString *)s1 withStr:(NSString *)s2;
- (NSArray *)splitWithStr:(NSString *)separator;
- (BOOL)contains:(NSString *)str;
- (NSString *)removeSubStr:(NSString *)subStr;
//忽略大小写比较两个字符串
- (BOOL)equalsIgnoreCase:(NSString *)str;

#pragma mark - TO (转换)

- (NSURL *)toURL;
- (NSURLRequest *)toURLRequest;
//文件名称 -> NSString
- (NSString *)toFilePath;
//文件名称 -> FileURL
- (NSURL *)toFileURL;
//文件名称 -> FileURLRequest
- (NSURLRequest *)toFileURLRequest;
// cString -> NSString
+ (NSString *)stringWithCString:(const char *)cString;
// double 字符串 去掉0   如：23.9000000001   --> 23.9
- (NSString *)doubleStringNullZero;
// 字符串 -> NSNumber
- (NSNumber *)toNumber;
// NSInteger -> 字符串
+ (NSString *)stringWithInteger:(NSInteger)num;
// int -> 字符串
+ (NSString *)stringWithInt:(int)num;


#pragma mark - 其他

//过滤emoji表情
- (BOOL)stringContainsEmoji;
#pragma mark - 富媒体文本

/*!  多媒体字符串颜色color、字体font  */
- (NSAttributedString *)attrStringFont:(UIFont *)font color:(UIColor *)color;
/*!  多媒体字符串颜色color、区域range  */
- (NSMutableAttributedString *)changeIntoABStringWithColor:(UIColor *)color range:(NSRange)range;
- (NSMutableAttributedString *)changeIntoABStringWithColor:(UIColor *)color;
- (NSMutableAttributedString *)changeIntoABStringWithFont:(UIFont *)font range:(NSRange)range;
/*!  多媒体字符串颜色color、字体font、区域range  */
- (NSMutableAttributedString *)changeIntoABStringWithFont:(UIFont *)font color:(UIColor *)color range:(NSRange)range;
- (NSMutableAttributedString *)changeIntoABStringWithFont:(UIFont *)font color:(UIColor *)color;
/** 删除线 */
- (NSAttributedString *)ABStrStrikethrough;
- (NSAttributedString *)ABStrStrikethroughWithFont:(UIFont *)font color:(UIColor *)color;
/*!  行间距  */
- (NSAttributedString *)ABSpacing:(CGFloat)lineSpacing font:(UIFont *)font;
- (NSAttributedString *)ABSpacing:(CGFloat)lineSpacing firstLineHeadIndent:(CGFloat)firstLineHeadIndent font:(UIFont *)font;
- (NSAttributedString *)ABStrUnderlineSpacing:(CGFloat)lineSpacing font:(UIFont *)font color:(UIColor *)color;

@end
