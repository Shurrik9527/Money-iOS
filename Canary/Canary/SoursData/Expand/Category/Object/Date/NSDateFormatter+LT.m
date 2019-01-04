//
//  NSDateFormatter+LT.m
//  LTDevDemo
//
//  Created by litong on 2017/1/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "NSDateFormatter+LT.h"

@implementation NSDateFormatter (LT)


+ (NSDateFormatter *)chinaDateFmt:(NSString *)fmt {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:LTOneHour * 8]];
    [df setDateFormat:fmt];
    return df;
}

+ (NSDateFormatter *)chinaDateYMD {
    return [NSDateFormatter chinaDateFmt:@"yyyy-MM-dd"];
}

+ (NSDateFormatter *)chinaDateYMDHMS {
    return [NSDateFormatter chinaDateFmt:kyMd_Hms];
}

+ (NSDateFormatter *)localDateFmt {
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    df.dateFormat = kyMd_Hms;
    return df;
}

+ (NSDateFormatter *)defaultDateFmt:(NSString *)fmt {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone defaultTimeZone]];
    [df setDateFormat:fmt];
    return df;
}


@end
