//
//  NSNumber+LT.h
//  LTDevDemo
//
//  Created by litong on 2017/1/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSNumber (LT)

//to字符串
- (NSString *)toString;
//  @(123456789) -> @"123,456,789"
- (NSString *)numberDecimalFmt;

@end



/**
 typedef NSUInteger NSNumberFormatterStyle;
 
 123456789对应的输出
 
 number string:123456789
 NSNumberFormatterNoStyle = kCFNumberFormatterNoStyle,
 
 number string:123,456,789
 NSNumberFormatterDecimalStyle = kCFNumberFormatterDecimalStyle,
 
 //输出会根据系统设置的语言区域的不同而不同
 number string:￥123,456,789.00
 NSNumberFormatterCurrencyStyle = kCFNumberFormatterCurrencyStyle,
 
 number string:-539,222,988%
 NSNumberFormatterPercentStyle = kCFNumberFormatterPercentStyle,
 
 number string:1.23456789E8
 NSNumberFormatterScientificStyle = kCFNumberFormatterScientificStyle,
 
 //输出会根据系统设置的语言区域的不同而不同
 number string:一亿二千三百四十五万六千七百八十九
 NSNumberFormatterSpellOutStyle = kCFNumberFormatterSpellOutStyle
 
 */
