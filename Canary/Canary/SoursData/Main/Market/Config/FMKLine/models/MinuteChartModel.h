//
//  MinuteChartModel.h
//  FMStock
//
//  Created by dangfm on 15/4/15.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MinuteChartModel : NSObject

@property (nonatomic,retain) NSString *transationPrice;     // 个股中表示每分钟的最后及时成交价
@property (nonatomic,retain) NSString *volume;              // 成交股数
@property (nonatomic,retain) NSString *volumePrice;         // 成交额
@property (nonatomic,retain) NSString *closePrice;          // 昨日收盘价
@property (nonatomic,retain) NSString *openPrice;           // 开盘价
@property (nonatomic,retain) NSString *heightPrice;         // 最高价
@property (nonatomic,retain) NSString *lowPrice;            // 最低价
@property (nonatomic,retain) NSString *seconds;             // 距离下次更新秒数
@property (nonatomic,retain) NSString *time;                // 时间
@property (nonatomic,retain) NSString *turnoverRate;        // 换手率


-(id)initWithDic:(NSDictionary *)dic;
@end
