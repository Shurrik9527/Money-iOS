//
//  NSDateFormatter+LT.h
//  LTDevDemo
//
//  Created by litong on 2017/1/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LTOneMinute         (60)
#define LTOneHour            (60 * LTOneMinute)
#define LTOneDay             (24 * LTOneHour)
#define LTOneMonth          (30 * LTOneDay)
#define LTOneYear             (12 * LTOneMonth)

#define kyMd_Hms    @"yyyy-MM-dd HH:mm:ss"
#define kyMd    @"yyyy-MM-dd"
#define kHms    @"HH:mm:ss"


@interface NSDateFormatter (LT)

//背景时间
+ (NSDateFormatter *)chinaDateFmt:(NSString *)fmt;
+ (NSDateFormatter *)chinaDateYMD;
+ (NSDateFormatter *)chinaDateYMDHMS;


+ (NSDateFormatter *)localDateFmt;
+ (NSDateFormatter *)defaultDateFmt:(NSString *)fmt;

@end




/*
 *
 **  PS: iOS-NSDateFormatter 格式说明：
 
 G: 公元时代，例如AD公元
 yy: 年的后2位
 yyyy: 完整年
 MM: 月，显示为1-12
 MMM: 月，显示为英文月份简写,如 Jan
 MMMM: 月，显示为英文月份全称，如 Janualy
 dd: 日，2位数表示，如02
 d: 日，1-2位显示，如 2
 EEE: 简写星期几，如Sun
 EEEE: 全写星期几，如Sunday
 aa: 上下午，AM/PM
 HH: 时，24小时制，0-23
 KK：时，12小时制，0-11
 m: 分，1-2位
 mm: 分，2位
 s: 秒，1-2位
 ss: 秒，2位
 S: 毫秒
 *
 */
