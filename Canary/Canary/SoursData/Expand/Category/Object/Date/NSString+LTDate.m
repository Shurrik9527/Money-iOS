//
//  NSString+LTDate.m
//  LTDevDemo
//
//  Created by litong on 2017/1/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "NSString+LTDate.h"

@implementation NSString (LTDate)


/** 返回fmd格式字符串
 self：必须是@"yyyy-MM-dd HH:mm:ss" 否则返回错误字符串
 backFMD：返回的格式
 */
- (NSString *)stringFMD:(NSString *)backFMD {
    return [self stringFMD:backFMD withSelfFMT:kyMd_Hms];
}
/** 日期字符串 转换
 sFMT  - > backFMD 日期格式的字符串
 */
- (NSString *)stringFMD:(NSString *)backFMD withSelfFMT:(NSString *)sFMT {
    return [NSDate stringFMT:backFMD withDateString:self andFMT:sFMT];
}


/**毫秒数 - > 字符串时间（backFMD格式）
 backFMD:返回格式
 self：毫秒数字符串
 eg.    [@"1734567000" timeIntervalStringToFMD:@"yyyy-MM-dd HH:mm:ss"];
 */
- (NSString *)timeIntervalStringToFMD:(NSString *)backFMD {
    NSTimeInterval t = [self doubleValue];
    return [NSString stringFMD:backFMD withTimeInterval:t];
}

/**毫秒数 - > 字符串时间（backFMD格式）
 backFMD:返回格式
 t：毫秒数
 eg.    [NSString stringFMD:kyMd_Hms withTimeInterval:t];
 */
+ (NSString *)stringFMD:(NSString *)backFMD withTimeInterval:(NSTimeInterval)t {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    NSString *dateString = [date chinaFmt:backFMD];
    return dateString;
}



#pragma mark  - 距离当前时间

- (NSInteger)toTimeIntervalSinceNow {
    NSDate *date = [NSDate dateFromString:self withFMT:kyMd_Hms];
    NSTimeInterval time = [date timeIntervalSinceNow];
    return time;
}

- (NSString *)distanceNowYMDHMS {
    NSTimeInterval disTime = [self  toTimeIntervalSinceNow]/(-1.0);
    return [NSString timeFormatter:disTime];
}

- (NSString *)distanceNowDoubleString {
    NSTimeInterval ti = [self doubleValue];
    NSTimeInterval nowTi = [[NSDate date] timeIntervalSince1970];
    
    NSTimeInterval disTime = nowTi - ti/1000;
    return [NSString timeFormatter:disTime];
}

+ (NSString *)distanceNowWithDouble:(NSTimeInterval)ti {
    NSTimeInterval nowTi = [[NSDate date] timeIntervalSince1970];
    
    NSTimeInterval disTime = nowTi - ti/1000;
    return [NSString timeFormatter:disTime];
}

/* 刚刚、几分钟前... */
+ (NSString *)timeFormatter:(NSTimeInterval)disTime {
    if (disTime >= LTOneYear) {
        return @"一年前";
    } else if (disTime >= LTOneMonth) {
        NSInteger month = disTime / LTOneMonth;
        return [NSString stringWithFormat:@"%ld个月前",month];
    } else if (disTime >= LTOneDay) {
        NSInteger day = disTime / LTOneDay;
        return [NSString stringWithFormat:@"%ld天前",day];
    } else if (disTime >= LTOneHour) {
        NSInteger hour = disTime / LTOneHour;
        return [NSString stringWithFormat:@"%ld小时前",hour];
    } else if (disTime >= LTOneMinute) {
        NSInteger min = disTime / LTOneMinute;
        return [NSString stringWithFormat:@"%ld分钟前",min];
    } else {
        return @"刚刚";
    }
}

#pragma mark - 倒计时

#define LTTimeRate  100  //刷新频率
//1%秒
+ (NSString *)countDownMSPerS:(NSInteger)t {
    NSInteger min = (t/LTTimeRate) / 60;//分钟
    NSInteger sec = (t/LTTimeRate) % 60;//分钟余数==秒
    NSInteger ms = t % LTTimeRate;//0.01秒
    return [self stringA:min B:sec C:ms];
}

+ (NSString *)countDownHMS:(NSInteger)t {
    NSInteger h = t / LTOneHour;//时
    NSInteger m = (t % LTOneHour) / LTOneMinute;//分
    NSInteger s = (t % LTOneMinute);//秒
    return [self stringA:h B:m C:s];
}


+ (NSString *)countDownDHM:(NSInteger)t {
    NSInteger day = t / LTOneDay;//天
    NSInteger hour = (t % LTOneDay) / LTOneHour;//小时
    NSInteger min = (t % LTOneHour)  / LTOneMinute;//分钟
    return [self stringA:day B:hour C:min];
}

+ (NSString *)stringA:(NSInteger)a B:(NSInteger)b C:(NSInteger)c {
    NSString *aStr = [[NSNumber numberWithInteger:a] stringValue];
    if (aStr.length == 1) {
        aStr = [NSString stringWithFormat:@"0%@",aStr];
    }
    
    NSString *bStr = [[NSNumber numberWithInteger:b] stringValue];
    if (bStr.length == 1) {
        bStr = [NSString stringWithFormat:@"0%@",bStr];
    }
    
    NSString *cStr =[[NSNumber numberWithInteger:c] stringValue];
    if (cStr.length == 1) {
        cStr = [NSString stringWithFormat:@"0%@",cStr];
    }
    return [NSString stringWithFormat:@"%@:%@:%@",aStr,bStr,cStr];
}



@end
