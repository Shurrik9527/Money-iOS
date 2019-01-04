//
//  NSDate+LT.h
//  LTDevDemo
//
//  Created by litong on 2017/1/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDateFormatter+LT.h"
#import "NSString+LTDate.h"

@interface NSDate (LT)

//当前毫秒数 *1000
+ ( long long int)curMS;
//当前毫秒数 *1000 的 字符串
+ (NSString *)curMSString;

//北京时间格式化
- (NSString *)chinaFmt:(NSString *)fmt;
//默认时间格式化
- (NSString *)defaultFmt:(NSString *)fmt;
//返回 @"yyyy-MM-dd" 格式的字符串
- (NSString *)chinaYMDString;
//返回 @"yyyy-MM-dd HH:mm:ss" 格式的字符串
- (NSString *)chinaYMDHMSString;
//返回 当前时间 @"yyyy-MM-dd" 格式的字符串

+ (NSString *)todayYMD;
//返回 当前时间 @"yyyy-MM-dd HH:mm:ss" 格式的字符串
+ (NSString *)todayYMDHMS;

//毫秒数 -> fmt格式的 字符串
+ (NSString *)timeInterval:(NSTimeInterval)time withFMT:(NSString *)fmt;

//字符串 - > NSDate
+ (NSDate *)dateFromString:(NSString *)string withFMT:(NSString *)fmt;

//dateStringFMT 格式的字符串 -> backFMT格式字符串
+ (NSString *)stringFMT:(NSString *)backFMT withDateString:(NSString *)dateString andFMT:(NSString *)dateStringFMT;
//字符串 -> backFMT格式字符串  ,yMdHmsStr 格式必须是 @"yyyy-MM-dd HH:mm:ss"
+ (NSString *)stringFMT:(NSString *)backFMT withString_yMdHms:(NSString *)yMdHmsStr;

@end
