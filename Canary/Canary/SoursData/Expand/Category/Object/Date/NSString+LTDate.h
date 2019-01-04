//
//  NSString+LTDate.h
//  LTDevDemo
//
//  Created by litong on 2017/1/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+LT.h"

@interface NSString (LTDate)

/** 返回fmd格式字符串
 self：必须是@"yyyy-MM-dd HH:mm:ss" 否则返回错误字符串
 backFMD：返回的格式
 */
- (NSString *)stringFMD:(NSString *)backFMD;
/** 日期字符串 转换
 sFMT  - > backFMD 日期格式的字符串
 */
- (NSString *)stringFMD:(NSString *)backFMD withSelfFMT:(NSString *)sFMT;


/**毫秒数 - > 字符串时间（backFMD格式）
 backFMD:返回格式
 self：毫秒数字符串
 eg.    [@"1734567000" timeIntervalStringToFMD:@"yyyy-MM-dd HH:mm:ss"];
 */
- (NSString *)timeIntervalStringToFMD:(NSString *)backFMD;

/**毫秒数 - > 字符串时间（backFMD格式）
 backFMD:返回格式
 t：毫秒数
 eg.    [NSString stringFMD:kyMd_Hms withTimeInterval:t];
 */
+ (NSString *)stringFMD:(NSString *)backFMD withTimeInterval:(NSTimeInterval)t;



#pragma mark  - 距离当前时间

- (NSInteger)toTimeIntervalSinceNow;
- (NSString *)distanceNowYMDHMS;
- (NSString *)distanceNowDoubleString;
+ (NSString *)distanceNowWithDouble:(NSTimeInterval)ti;
/* 刚刚、几分钟前... */
+ (NSString *)timeFormatter:(NSTimeInterval)disTime;

#pragma mark - 倒计时
//1%秒
+ (NSString *)countDownMSPerS:(NSInteger)t;
+ (NSString *)countDownHMS:(NSInteger)t;
+ (NSString *)countDownDHM:(NSInteger)t;

@end
