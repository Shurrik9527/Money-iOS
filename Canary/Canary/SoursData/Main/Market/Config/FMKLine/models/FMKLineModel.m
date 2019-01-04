//
//  FMKLineModel.m
//  golden_iphone
//
//  Created by dangfm on 15/6/11.
//  Copyright (c) 2015年 golden. All rights reserved.
//

#import "FMKLineModel.h"
#import "FMStockIndexs.h"

@implementation FMKLineModel

-(instancetype)init{
    if (self==[super init]) {
        
        // 初始化
        self.type = 0;
        self.isChangeData = NO;
        self.isFinished = YES;
        self.isHideLeft = YES;
        self.isHideRight = NO;
        self.isShowMiddleLine = NO;
        self.isStopDraw = NO;
        self.isZooming = NO;
        self.isShowSide = NO;
        self.isShadow = NO;
        self.isReset = YES;
        self.isHasLastTianji = NO;
        
        self.maxPrice = 0;
        self.minPrice = CGFLOAT_MAX;
        self.bottomMaxPrice = 0;
        self.bottomMinPrice = CGFLOAT_MAX;
        
        self.klineWidth = 6;
        self.klinePadding = 2;
        
        self.prices = [NSMutableArray new];
        self.points = [NSMutableDictionary new];
        self.allPoints = [NSMutableDictionary new];
        self.times = [NSMutableArray new];
        self.lastTianjiLine= [NSMutableArray new];
        
        self.stockIndexType = FMStockIndexType_SAM;
        self.stockIndexBottomType = FMStockIndexType_MACD;
        
        self.width = [[UIScreen mainScreen] bounds].size.width - 20;
        self.height = self.width;
        
        self.offsetStart = -1;
        self.drawOffsetStart = 0;
        
        self.leftEmptyKline = 5;
        self.rightEmptyKline = 5;
        
    }
    return self;
}
//k线接口返回数据   根据type格式化时间
+ (NSMutableArray *)objsWithList:(NSArray *)list type:(NSString *)type {
    NSMutableArray *ms = [NSMutableArray new];
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc]init];
    //获取当前时间的年
    [dateFomatter setDateFormat:@"YYYY"];
    NSString *yyyy = [dateFomatter stringFromDate:[NSDate date]];
    //时间格式 ：年-月-日 时:分:秒
    [dateFomatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    for (NSDictionary *item in list) {
        NSString *time = [item objectForKey:@"t"];
        if([type isEqual:@"6"] || [type isEqual:@"7"] || [type isEqual:@"8"]) {
            //6、7、8         t: "2015-07-14"  需要在后面添加时分秒（00:00:00）
            time = [NSString stringWithFormat:@"%@ 00:00:00",time];
        } else {
            //t: "07-01 04:00",  需要在前面补年（yyyy）后面补秒（:00）
            time = [NSString stringWithFormat:@"%@-%@:00",yyyy,time];
        }
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[dateFomatter dateFromString:time] timeIntervalSince1970]];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    timeSp,@"time",
                                    [item objectForKey:@"c"],@"closePrice",
                                    [item objectForKey:@"v"],@"volume",
                                    [item objectForKey:@"h"],@"heightPrice",
                                    [item objectForKey:@"l"],@"lowPrice",
                                    [item objectForKey:@"o"],@"openPrice",
                                    nil];

        [ms addObject:dic];
    }

    return ms;
}
//k线接口返回数据   根据type格式化时间
//+ (NSMutableArray *)objsWithList:(NSArray *)list type:(NSString *)type {
//    NSMutableArray *ms = [NSMutableArray new];
//    for (NSDictionary *item in list) {
//        NSString *time = [item objectForKey:@"time"];
//        long long longValue =time.longLongValue/1000;
//        long long  lastValue =longValue - 3*60*60*1000;
//        NSNumber *longNumber = [NSNumber numberWithLong:lastValue];
//        NSString *longStr = [longNumber stringValue];
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                    longStr,@"time",
//                                    [item objectForKey:@"close"],@"closePrice",
//                                    [item objectForKey:@"volume"],@"volume",
//                                    [item objectForKey:@"high"],@"heightPrice",
//                                    [item objectForKey:@"low"],@"lowPrice",
//                                    [item objectForKey:@"open"],@"openPrice",
//                                    nil];
//        [ms addObject:dic];
//    }
//    return ms;
//}
//k线接口返回数据   根据type格式化时间  兼容老版本
+ (NSDictionary *)dictWithList:(NSArray *)list type:(NSString *)type {
    NSMutableArray *ms = [FMKLineModel objsWithList:list type:type];
    NSDictionary *data = [NSDictionary dictionaryWithObject:ms forKey:@"list"];
    return data;
}


@end
