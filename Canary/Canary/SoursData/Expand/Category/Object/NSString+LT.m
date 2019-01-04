//
//  NSString+LT.m
//  LTDevDemo
//
//  Created by litong on 2017/1/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "NSString+LT.h"
#import "NSObject+LT.h"

@implementation NSString (LT)

#pragma mark 判空

/** 是否为空(nil、NULL、[NSNull class]、空格)字符串
 * 空：yes   非空：no  */
+ (BOOL)emptyString:(NSString *)str {
    return ![NSString notEmptyString:str];
}

+ (BOOL)notEmptyString:(NSString *)str {
    
    if (![str isKindOfClass:[NSString class]])
    {
        str=[NSString stringWithFormat:@"%@",str];
    }
    
    BOOL bl = [NSObject isNotNull:str];
    
    if (!bl) {
        return NO;
    }
    else if ([str isEqualToString:@"(null)"]) {//stringWithFormat (nil，Nil，NULL) --> @"(null)"
        return NO;
    }
    else if ([str isEqualToString:@"<null>"]) {//stringWithFormat ([NSNull null]) --> @"<null>"
        return NO;
    }
    
    NSString *s = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (s.length == 0) {
        return NO;
    }
    
    return YES;
}

#pragma mark - 计算字符串宽高
-(CGSize)sizeWithFont:(UIFont *)font {
    CGSize size = [self sizeWithAttributes: @{NSFontAttributeName: font}];
    return size;
}
- (CGSize)boundingSize:(CGSize)size font:(UIFont *)font {
    return [self boundingRectWithSize:size
                              options:NSStringDrawingTruncatesLastVisibleLine |
                                           NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingUsesFontLeading
                           attributes:@{NSFontAttributeName:font}
                              context:nil].size;
}

//计算文字高度
- (CGSize)boundingH:(CGFloat)maxW font:(UIFont *)font {
    return [self boundingSize:CGSizeMake(maxW, CGFLOAT_MAX) font:font];
}

//计算文字宽度
- (CGSize)boundingW:(CGFloat)maxH font:(UIFont *)font {
    return [self boundingSize:CGSizeMake(CGFLOAT_MAX, maxH) font:font];
}

- (CGFloat)autoFitW:(CGFloat)fs {
    CGFloat w = [self boundingW:fs font:[UIFont fontOfSize:fs]].width;
    return w;
}




#pragma mark - 常用系统方法

- (NSString *)replacStr:(NSString *)s1 withStr:(NSString *)s2 {
    return [self stringByReplacingOccurrencesOfString:s1 withString:s2];
}

- (NSArray *)splitWithStr:(NSString *)separator {
    if ([self contains:separator]) {
        NSArray *arr = [self componentsSeparatedByString:separator];
        return [NSArray arrayWithArray:arr];
    }
    return [NSArray array];
}

- (BOOL)contains:(NSString *)str {
    if (nil == str || [str length] < 1) {
        return NO;
    }
    
    return [self rangeOfString:str].location != NSNotFound;
}

- (NSString *)removeSubStr:(NSString *)subStr {
    NSRange range = [self rangeOfString:subStr];
    NSString *str = [self substringFromIndex:range.length];
    return str;
}

// 忽略大小写比较两个字符串
- (BOOL)equalsIgnoreCase:(NSString *)str {
    if (nil == str) {
        return NO;
    }
    
    return [[str lowercaseString] isEqualToString:[self lowercaseString]];
}


#pragma mark - TO (转换)

- (NSURL *)toURL {
    NSURL *URL=[NSURL URLWithString:self];
    return URL;
}

- (NSURLRequest *)toURLRequest {
    NSURLRequest *URLRequest=[NSURLRequest requestWithURL:[self toURL]];
    return URLRequest;
}

//文件名称 -> NSString
- (NSString *)toFilePath {
    NSString *basePath = [[NSBundle mainBundle] bundlePath];
    NSString *filePath = [basePath stringByAppendingPathComponent:self];
    return filePath;
}

//文件名称 -> FileURL
- (NSURL *)toFileURL {
    NSString *filePath = [self toFilePath];
    NSURL *URL = [NSURL fileURLWithPath:filePath];
    return URL;
}

//文件名称 -> FileURLRequest
- (NSURLRequest *)toFileURLRequest {
    NSURLRequest *URLRequest=[NSURLRequest requestWithURL:[self toFileURL]];
    return URLRequest;
}

// cString -> NSString
+ (NSString *)stringWithCString:(const char *)cString {
    return [NSString stringWithCString:cString encoding:NSUTF8StringEncoding];
}

// double 字符串 去掉0   如：23.9000000001   --> 23.9
- (NSString *)doubleStringNullZero {
    return [NSString stringWithFormat:@"%g",[self doubleValue]];
}

// 字符串 -> NSNumber
- (NSNumber *)toNumber {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    id result = [f numberFromString:self];
    if(result) {
        return result;
    }
    return nil;
}

// NSInteger -> 字符串
+ (NSString *)stringWithInteger:(NSInteger)num {
    return [[NSNumber numberWithInteger:num] stringValue];
}

// int -> 字符串
+ (NSString *)stringWithInt:(int)num {
    return [[NSNumber numberWithInt:num] stringValue];
}


#pragma mark - 其他


//过滤emoji表情
- (BOOL)stringContainsEmoji {
    __block BOOL returnValue = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              const unichar hs = [substring characterAtIndex:0];
                              if (0xd800 <= hs && hs <= 0xdbff) {
                                  if (substring.length > 1) {
                                      const unichar ls = [substring characterAtIndex:1];
                                      const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                      if (0x1d000 <= uc && uc <= 0x1f77f) {
                                          returnValue = YES;
                                      }
                                  }
                              } else if (substring.length > 1) {
                                  const unichar ls = [substring characterAtIndex:1];
                                  if (ls == 0x20e3) {
                                      returnValue = YES;
                                  }
                              } else {
                                  if (0x2100 <= hs && hs <= 0x27ff) {
                                      returnValue = YES;
                                  } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                      returnValue = YES;
                                  } else if (0x2934 <= hs && hs <= 0x2935) {
                                      returnValue = YES;
                                  } else if (0x3297 <= hs && hs <= 0x3299) {
                                      returnValue = YES;
                                  } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                      returnValue = YES;
                                  }
                              }
                          }];
    
    return returnValue;
}

/*
 不允许键入emoji
 - (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
 // 不让输入表情
 if ([textView isFirstResponder]) {
 if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage]) {
 return NO;
 }
 }
 return YES;
 }
 */
#pragma mark - 富媒体文本

- (NSAttributedString *)attrStringFont:(UIFont *)font color:(UIColor *)color {
    NSDictionary *dict = @{
                           NSForegroundColorAttributeName:color,
                           NSFontAttributeName:[UIFont fontOfSize:12.f]
                           };
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self attributes:dict];
    return attrString;
}

- (NSMutableAttributedString *)changeIntoABStringWithColor:(UIColor *)color range:(NSRange)range {
    NSMutableAttributedString *ABStr = [[NSMutableAttributedString alloc]initWithString:self];
    [ABStr addAttribute:NSForegroundColorAttributeName
                  value:color
                  range:range];
    return ABStr;
}

- (NSMutableAttributedString *)changeIntoABStringWithColor:(UIColor *)color {
    return [self changeIntoABStringWithColor:color range:NSMakeRange(0, self.length)];
}

- (NSMutableAttributedString *)changeIntoABStringWithFont:(UIFont *)font range:(NSRange)range {
    NSMutableAttributedString *ABStr = [[NSMutableAttributedString alloc]initWithString:self];
    [ABStr setAttributes:@{NSFontAttributeName:font}
                   range:range];
    return ABStr;
}


- (NSMutableAttributedString *)changeIntoABStringWithFont:(UIFont *)font color:(UIColor *)color range:(NSRange)range {
    NSMutableAttributedString *ABStr = [[NSMutableAttributedString alloc]initWithString:self];
    [ABStr setAttributes:@{NSForegroundColorAttributeName:color,
                           NSFontAttributeName:font}
                   range:range];
    return ABStr;
}

- (NSMutableAttributedString *)changeIntoABStringWithFont:(UIFont *)font color:(UIColor *)color {
    return [self changeIntoABStringWithFont:font color:color range:NSMakeRange(0, self.length)];
}


- (NSAttributedString *)ABSpacing:(CGFloat)lineSpacing font:(UIFont *)font {
    
    NSString *str = [NSString stringWithFormat:@"%@",self];
    NSMutableAttributedString *ABStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSRange range = NSMakeRange(0, str.length);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    [ABStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [ABStr addAttribute:NSFontAttributeName value:font range:range];
    
    return ABStr;
}

- (NSAttributedString *)ABSpacing:(CGFloat)lineSpacing firstLineHeadIndent:(CGFloat)firstLineHeadIndent font:(UIFont *)font {
    
    NSString *str = [NSString stringWithFormat:@"%@",self];
    NSRange range = NSMakeRange(0, str.length);
    NSMutableAttributedString *ABStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.firstLineHeadIndent = firstLineHeadIndent;
    
    NSDictionary *dict = @{
                           NSParagraphStyleAttributeName:paragraphStyle,
                           NSFontAttributeName:font,
                           };
    [ABStr setAttributes:dict range:range];
    
    return ABStr;
}


- (NSAttributedString *)ABStrStrikethrough {
    NSString *str = [NSString stringWithFormat:@"%@",self];
    NSMutableAttributedString *ABStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange range = NSMakeRange(0, str.length);
    [ABStr setAttributes:@{
                           NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)
                           }
                   range:range];
    return ABStr;
}

- (NSAttributedString *)ABStrStrikethroughWithFont:(UIFont *)font color:(UIColor *)color {
    NSString *str = [NSString stringWithFormat:@"%@",self];
    NSMutableAttributedString *ABStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange range = NSMakeRange(0, str.length);
    [ABStr setAttributes:@{
                           NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),
                           NSFontAttributeName:font,
                           NSForegroundColorAttributeName:color}
                   range:range];
    return ABStr;
}

- (NSAttributedString *)ABStrUnderlineSpacing:(CGFloat)lineSpacing font:(UIFont *)font color:(UIColor *)color {
    NSString *str = [NSString stringWithFormat:@"%@",self];
    NSRange range = NSMakeRange(0, str.length);
    NSMutableAttributedString *ABStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    
    NSDictionary *dict = @{
                           NSParagraphStyleAttributeName:paragraphStyle,
                           NSFontAttributeName:font,
                           NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),
                           NSForegroundColorAttributeName:color
                           };
    [ABStr setAttributes:dict range:range];
    return ABStr;
}





@end
