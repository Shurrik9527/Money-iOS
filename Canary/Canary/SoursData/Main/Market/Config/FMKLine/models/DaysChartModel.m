//
//  DaysChartModel.m
//  FMStock
//
//  Created by dangfm on 15/4/21.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

#import "DaysChartModel.h"

@implementation DaysChartModel

-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.openPrice = [dic objectForKey:@"openPrice"]; // 开盘价
        if (!self.openPrice||![self.openPrice isKindOfClass:[NSString class]]) {
            self.openPrice=@"";
        }
        self.closePrice = [dic objectForKey:@"closePrice"]; // 收盘价
        if (!self.closePrice||![self.closePrice isKindOfClass:[NSString class]]) {
            self.closePrice=@"";
        }
        self.heightPrice = [dic objectForKey:@"heightPrice"]; // 最高价
        if (!self.heightPrice||![self.heightPrice isKindOfClass:[NSString class]]) {
            self.heightPrice=@"";
        }
        self.lowPrice = [dic objectForKey:@"lowPrice"]; // 最高价
        if (!self.lowPrice||![self.lowPrice isKindOfClass:[NSString class]]) {
            self.lowPrice=@"";
        }
        self.volume = [dic objectForKey:@"volume"]; // 成交量
        if (!self.volume||![self.volume isKindOfClass:[NSString class]]) {
            self.volume=@"";
        }
        self.volumePrice = [dic objectForKey:@"volumePrice"]; // 成交额
        if (!self.volumePrice||![self.volumePrice isKindOfClass:[NSString class]]) {
            self.volumePrice=@"";
        }
        self.turnoverRate = [dic objectForKey:@"turnoverRate"]; // 换手率
        if (!self.turnoverRate||![self.turnoverRate isKindOfClass:[NSString class]]) {
            self.turnoverRate=@"";
        }
        self.changeValue = [dic objectForKey:@"changeValue"]; // 涨跌额
        if (!self.changeValue||![self.changeValue isKindOfClass:[NSString class]]) {
            self.changeValue=@"";
        }
        self.changeRate = [dic objectForKey:@"changeRate"]; // 涨跌幅
        if (!self.changeRate||![self.changeRate isKindOfClass:[NSString class]]) {
            self.changeRate=@"";
        }
        self.MA5 = [dic objectForKey:@"MA5"]; // 5日均线
        if (!self.MA5||![self.MA5 isKindOfClass:[NSString class]]) {
            self.MA5=@"";
        }else {
//            NSLog(@"MA5 Is Not Null");
        }
        self.MA10 = [dic objectForKey:@"MA10"]; // 10日均线
        if (!self.MA10||![self.MA10 isKindOfClass:[NSString class]]) {
            self.MA10=@"";
        }
        self.MA20 = [dic objectForKey:@"MA20"]; // 20日均线
        if (!self.MA20||![self.MA20 isKindOfClass:[NSString class]]) {
            self.MA20=@"";
        }
        self.MA60 = [dic objectForKey:@"MA60"]; // 20日均线
        if (!self.MA60||![self.MA60 isKindOfClass:[NSString class]]) {
            self.MA60=@"";
        }
        self.MA120 = [dic objectForKey:@"MA120"]; // 20日均线
        if (!self.MA120||![self.MA120 isKindOfClass:[NSString class]]) {
            self.MA120=@"";
        }
        self.volMA5 = [dic objectForKey:@"volMA5"];  // 成交量5日均值
        if (!self.volMA5||![self.volMA5 isKindOfClass:[NSString class]]) {
            self.volMA5=@"";
        }
        self.volMA10 = [dic objectForKey:@"volMA10"];  // 成交量10日均值
        if (!self.volMA10||![self.volMA10 isKindOfClass:[NSString class]]) {
            self.volMA10=@"";
        }
        self.time = [dic objectForKey:@"time"]; // 日期或者时间
//        if (!self.time||![self.time isKindOfClass:[NSString class]]) {
//            self.time=@"";
//        }
        self.MACD_DIF = [dic objectForKey:@"MACD_DIF"]; // MACD DIF值
        if (!self.MACD_DIF||![self.MACD_DIF isKindOfClass:[NSString class]]) {
            self.MACD_DIF=@"";
        }
        self.MACD_DEA = [dic objectForKey:@"MACD_DEA"]; // MACD DEA值
        if (!self.MACD_DEA||![self.MACD_DEA isKindOfClass:[NSString class]]) {
            self.MACD_DEA=@"";
        }
        self.MACD_M = [dic objectForKey:@"MACD_M"]; // MACD M值
        if (!self.MACD_M||![self.MACD_M isKindOfClass:[NSString class]]) {
            self.MACD_M=@"";
        }
        self.MACD_12EMA = [dic objectForKey:@"MACD_12EMA"]; // MACD 12EMA值
        if (!self.MACD_12EMA||![self.MACD_12EMA isKindOfClass:[NSString class]]) {
            self.MACD_12EMA=@"";
        }
        self.MACD_26EMA = [dic objectForKey:@"MACD_26EMA"]; // MACD 26EMA值
        if (!self.MACD_26EMA||![self.MACD_26EMA isKindOfClass:[NSString class]]) {
            self.MACD_26EMA=@"";
        }
        
        self.KDJ_K = [dic objectForKey:@"KDJ_K"]; // KDJ K值
        if (!self.KDJ_K||![self.KDJ_K isKindOfClass:[NSString class]]) {
            self.KDJ_K=@"";
        }
        self.KDJ_D = [dic objectForKey:@"KDJ_D"]; // KDJ D值
        if (!self.KDJ_D||![self.KDJ_D isKindOfClass:[NSString class]]) {
            self.KDJ_D=@"";
        }
        self.KDJ_J = [dic objectForKey:@"KDJ_J"]; // KDJ J值
        if (!self.KDJ_J||![self.KDJ_J isKindOfClass:[NSString class]]) {
            self.KDJ_J=@"";
        }
        self.RSI_1 = [dic objectForKey:@"RSI_1"]; // RSI_1 6
        self.RSI_2 = [dic objectForKey:@"RSI_2"]; // RSI_2 12
        self.RSI_3 = [dic objectForKey:@"RSI_3"]; // RSI_2 24
        self.EMA = [dic objectForKey:@"EMA"]; // EMA 20
        self.EMA_Tianji_1 = [dic objectForKey:@"EMA_Tianji_1"]; // EMA 天玑线周期1的值
        self.EMA_Tianji_2 = [dic objectForKey:@"EMA_Tianji_2"]; // EMA 天玑线周期2的值
        self.BOLL_UP = [dic objectForKey:@"BOLL_UP"];
        self.BOLL_MIDDLE = [dic objectForKey:@"BOLL_MIDDLE"]; // N=20
        self.BOLL_DOWN = [dic objectForKey:@"BOLL_DOWN"]; // K=2
        self.SMA = [dic objectForKey:@"SMA"];
        
    }
    return self;
}


@end
