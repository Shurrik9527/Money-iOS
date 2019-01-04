//
//  MinuteChartModel.m
//  FMStock
//
//  Created by dangfm on 15/4/15.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

#import "MinuteChartModel.h"

@implementation MinuteChartModel

-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        // 个股中表示每分钟的最后及时成交价，大盘中表示每分钟的大盘指数
        self.transationPrice = [dic objectForKey:@"transationPrice"];
        if (![self.transationPrice isKindOfClass:[NSString class]]) {
            self.transationPrice=@"";
        }
        self.volume = [dic objectForKey:@"volume"];
        if (![self.volume isKindOfClass:[NSString class]]) {
            self.volume=@"";
        }
        self.volumePrice = [dic objectForKey:@"volumePrice"]; 
        if (![self.volumePrice isKindOfClass:[NSString class]]) {
            self.volumePrice=@"";
        }
        self.closePrice = [dic objectForKey:@"closePrice"]; 
        if (![self.closePrice isKindOfClass:[NSString class]]) {
            self.closePrice=@"";
        }
        self.time = [NSString stringWithFormat:@"%@",[dic objectForKey:@"time"]];
        if (![self.time isKindOfClass:[NSString class]]) {
            self.time=@"";
        }
        self.seconds = [dic objectForKey:@"second"];
        if (![self.seconds isKindOfClass:[NSString class]]) {
            self.seconds=@"";
        }
        self.turnoverRate = [dic objectForKey:@"turnoverRate"]; 
        if (![self.turnoverRate isKindOfClass:[NSString class]]) {
            self.turnoverRate=@"";
        }
        self.openPrice = [dic objectForKey:@"openPrice"];
        if (![self.openPrice isKindOfClass:[NSString class]]) {
            self.openPrice=@"";
        }
        self.heightPrice = [dic objectForKey:@"heightPrice"];
        if (![self.heightPrice isKindOfClass:[NSString class]]) {
            self.heightPrice=@"";
        }
        self.lowPrice = [dic objectForKey:@"lowPrice"];
        if (![self.lowPrice isKindOfClass:[NSString class]]) {
            self.lowPrice=@"";
        }
    }
    return self;
}



@end
