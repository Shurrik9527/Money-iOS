//
//  NSDate+LT.m
//  LTDevDemo
//
//  Created by litong on 2017/1/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "NSDate+LT.h"

@implementation NSDate (LT)

//当前毫秒数 *1000
+ ( long long int)curMS {
    NSDate *date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSince1970]*1000;
    long long int timestamp = ceil(time);
    return timestamp;
}

//当前毫秒数 *1000 的 字符串
+ (NSString *)curMSString {
    return [NSString stringWithFormat:@"%lld",[NSDate curMS]];
}


- (NSString *)defaultFmt:(NSString *)fmt {
    NSDateFormatter *df = [NSDateFormatter defaultDateFmt:fmt];
    return [df stringFromDate:self];
}

//北京时间格式化
- (NSString *)chinaFmt:(NSString *)fmt {
    NSDateFormatter *df = [NSDateFormatter chinaDateFmt:fmt];
    return [df stringFromDate:self];
}

//返回 @"yyyy-MM-dd" 格式的字符串
- (NSString *)chinaYMDString {
    return [self chinaFmt:kyMd];
}

//返回 当前时间 @"yyyy-MM-dd" 格式的字符串
+ (NSString *)todayYMD {
    return [[NSDate date] chinaYMDString];
}

//返回 @"yyyy-MM-dd HH:mm:ss" 格式的字符串
- (NSString *)chinaYMDHMSString {
    return [self chinaFmt:kyMd_Hms];
}
//返回 当前时间 @"yyyy-MM-dd HH:mm:ss" 格式的字符串
+ (NSString *)todayYMDHMS {
    return [[NSDate date] chinaYMDHMSString];
}

//毫秒数 -> fmt格式的 字符串
+ (NSString *)timeInterval:(NSTimeInterval)time withFMT:(NSString *)fmt {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    return [date chinaFmt:fmt];
}

//字符串 - > NSDate
+ (NSDate *)dateFromString:(NSString *)string withFMT:(NSString *)fmt {
    NSDateFormatter *df = [NSDateFormatter chinaDateFmt:fmt];
    return [df dateFromString:string];
}

//dateStringFMT 格式的字符串 -> backFMT格式字符串
+ (NSString *)stringFMT:(NSString *)backFMT withDateString:(NSString *)dateString andFMT:(NSString *)dateStringFMT {
    NSDate *date = [NSDate dateFromString:dateString withFMT:dateStringFMT];
    NSString *string = [date chinaFmt:backFMT];
    return string;
}

//字符串 -> backFMT格式字符串  ,yMdHmsStr 格式必须是 @"yyyy-MM-dd HH:mm:ss"
+ (NSString *)stringFMT:(NSString *)backFMT withString_yMdHms:(NSString *)yMdHmsStr {
    return [NSDate stringFMT:backFMT withDateString:yMdHmsStr andFMT:kyMd_Hms];
}


@end
