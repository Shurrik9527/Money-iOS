//
//  PushRemindModel.m
//  ixit
//
//  Created by Brain on 2017/2/10.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "PushRemindModel.h"

@implementation PushRemindModel


//5点 | %@ - %@ 有效
- (NSString *)wave_fmd {
//    NSString *validity = self.cycleType == 1 ? @"提醒24小时有效" : @"提醒7日内有效";
    NSString *validity = [self validTime_fmd];
    NSString *str = [NSString stringWithFormat:@"%@ | %@",self.floatUpProfit,validity];
    return str;
}

- (NSString *)validTime_fmd {
    NSTimeInterval oneDayHS = LIT_ONE_DAY;
    NSTimeInterval beginTime = [self.createTime doubleValue]/1000;
    NSTimeInterval midTime = self.cycleType == 1 ? oneDayHS : 7 * oneDayHS;
    NSTimeInterval endTime =  beginTime + midTime;
    
//    NSString *beginStr = [NSDate timeInterval:beginTime withFMT:@"MM/dd HH:mm"];
//    NSString *endStr = [NSDate timeInterval:endTime withFMT:@"MM/dd HH:mm"];
//    NSString *res = [NSString stringWithFormat:@"%@ - %@ 有效",beginStr,endStr];
    
    NSString *endStr = [NSDate timeInterval:endTime withFMT:@"MM/dd HH:mm"];
    NSString *res = [NSString stringWithFormat:@"有效期至：%@",endStr];
    
    return res;
}

+ (PushRemindModel *)testMO {
    PushRemindModel *mo = [[PushRemindModel alloc] init];
    mo.createTime = @"1487333047000";
    mo.customizedProfit = @"3001.1";
    mo.exchangeName = @"哈贵所";
    mo.expirationTime = @"1487419447000";
    mo.floatDownProfit = @"10";
    mo.floatUpProfit = @"10";
    mo.pid = @"121";

    mo.productCode = @"HGNI";
    mo.productExcode = @"HPME";
    mo.productName = @"哈贵镍";
    mo.reminderProfit = @"";
    mo.sendTime = @"<null>";

    mo.updateTime = @"<null>";
    mo.userId = @"125068";
    mo.userLever = @"7";
    mo.userMobile = @"18521302526";
    mo.userName = @"userName";
    
    
    mo.margin = @(0);
    mo.mq = @(0).stringValue;

    mo.cycleType = 1;
    mo.exchangeId = 8;
    mo.status = 1;
    mo.type = 2;
    return mo;
}

@end
