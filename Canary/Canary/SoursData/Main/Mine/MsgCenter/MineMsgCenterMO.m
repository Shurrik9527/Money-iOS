//
//  MineMsgCenterMO.m
//  ixit
//
//  Created by litong on 2017/3/10.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "MineMsgCenterMO.h"

@implementation MineMsgCenterMO

- (BOOL)showRed {
    //	Integer	消息状态（1:未读，2:已读,3失败）
    BOOL show = (self.status == 1);
    return show;
}

- (NSString *)createTime_fmt {
    NSTimeInterval t = [_createTime doubleValue]/1000;
    NSString *time = [NSString stringFMD:@"yyyy-MM-dd HH:mm" withTimeInterval:t];
    return time;
}

- (MineMsgType)mineMsgType {
    NSInteger typ = self.messageType;
    if (typ == 1 || typ == 8) {
        //官 -- 1：系统消息; 8：交易风险-系统提示;
        return MineMsgType_System;
    }
    else if (typ == 4 || typ == 5 || typ == 6) {
        //券 --  4,代金券-到账提醒;5,代金券-到期提现;6,代金券-即将到期;
        return MineMsgType_Quan;
    }
    else if (typ == 3 || typ == 7) {
        //仓 -- 3,系统平仓-爆仓提醒;7,系统平仓-止盈止损;
        return MineMsgType_Deal;
    } else {
        
        return MineMsgType_Normal;
    }
}


+ (NSArray *)testDatas {
    
    NSDictionary *dict0 = @{
                            @"messageId":@"100",
                            @"messageDetailId":@"10",
                            @"messageType":@(4),
                            @"messageTitle":@"代金券 到账提醒",
                            @"messageContent":@"8元哈贵镍代金券已到账",
                            @"createTime":@"1488877962996",
                            @"status":@(1),//
                            @"excode":@"",
                            @"orderId":@"",
                            @"url":@""
                            };
    NSDictionary *dict1 = @{
                            @"messageId":@"1",
                            @"messageDetailId":@"11",
                            @"messageType":@(7),
                            @"messageTitle":@"系统自动平仓 (止损平仓)",
                            @"messageContent":@"买涨 吉尿素 0.1批 10手（-16.5元）",
                            @"createTime":@"1488877962996",
                            @"status":@(1),//
                            @"excode":@"",
                            @"orderId":@"",
                            @"url":@""
                            };
    NSDictionary *dict2 = @{
                            @"messageId":@"2",
                            @"messageDetailId":@"12",
                            @"messageType":@(8),
                            @"messageTitle":@"交易风险系统提醒",
                            @"messageContent":@"您的操作存在一定风险，请谨慎投资",
                            @"createTime":@"1488877962996",
                            @"status":@(1),//
                            @"excode":@"",
                            @"orderId":@"",
                            @"url":@""
                            };
    NSDictionary *dict3 = @{
                            @"messageId":@"3",
                            @"messageDetailId":@"13",
                            @"messageType":@(5),
                            @"messageTitle":@"代金券 到期提醒",
                            @"messageContent":@"您有一张8元哈贵银代金券，到期失效",
                            @"createTime":@"1488877962996",
                            @"status":@(2),//
                            @"excode":@"",
                            @"orderId":@"",
                            @"url":@""
                            };
    
    NSDictionary *dict4 = @{
                            @"messageId":@"4",
                            @"messageDetailId":@"14",
                            @"messageType":@(6),
                            @"messageTitle":@"代金券 即将到期",
                            @"messageContent":@"您有一张8元哈贵银代金券，将于24小时后到期失效",
                            @"createTime":@"1488877962996",
                            @"status":@(2),//
                            @"excode":@"",
                            @"orderId":@"",
                            @"url":@""
                            };
    
    NSDictionary *dict5 = @{
                            @"messageId":@"5",
                            @"messageDetailId":@"15",
                            @"messageType":@(3),
                            @"messageTitle":@"系统平仓-爆仓提醒",
                            @"messageContent":@"买涨 吉尿素 0.1批 10手（+0元）",
                            @"createTime":@"1488877962996",
                            @"status":@(1),//
                            @"excode":@"",
                            @"orderId":@"",
                            @"url":@""
                            };
    NSDictionary *dict6 = @{
                            @"messageId":@"6",
                            @"messageDetailId":@"16",
                            @"messageType":@(1),
                            @"messageTitle":@"系统升级提醒",
                            @"messageContent":@"本周周末（03.07-0.08）系统升级，届时将有部分用户出现登录异常，请知晓！",
                            @"createTime":@"1488877962996",
                            @"status":@(1),//
                            @"excode":@"",
                            @"orderId":@"",
                            @"url":@""
                            };
    
    NSArray *arr0 = [NSArray arrayWithObjects:dict0, dict1, dict2,
                    dict3, dict4, dict5, dict6, nil];
    NSArray *arr = [MineMsgCenterMO objsWithList:arr0];
//    NSString *arrJson = [arr toJsonString];
//    NSLog(@"arrJson == %@",arrJson);
    return arr;
}

@end
