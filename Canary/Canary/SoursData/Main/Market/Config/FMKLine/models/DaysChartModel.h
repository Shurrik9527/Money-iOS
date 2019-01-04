//
//  DaysChartModel.h
//  FMStock
//
//  Created by dangfm on 15/4/21.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMKLineModel.h"

@interface DaysChartModel : NSObject

@property (nonatomic,copy) NSString *openPrice;
@property (nonatomic,copy) NSString *closePrice;
@property (nonatomic,copy) NSString *heightPrice;
@property (nonatomic,copy) NSString *lowPrice;
@property (nonatomic,copy) NSString *volume;
@property (nonatomic,copy) NSString *volumePrice;
@property (nonatomic,copy) NSString *turnoverRate;
@property (nonatomic,copy) NSString *changeValue;
@property (nonatomic,copy) NSString *changeRate;
@property (nonatomic,copy) NSString *MA5;
@property (nonatomic,copy) NSString *MA10;
@property (nonatomic,copy) NSString *MA20;
@property (nonatomic,copy) NSString *MA60;
@property (nonatomic,copy) NSString *MA120;
@property (nonatomic,copy) NSString *volMA5;
@property (nonatomic,copy) NSString *volMA10;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *MACD_DIF;
@property (nonatomic,copy) NSString *MACD_DEA;
@property (nonatomic,copy) NSString *MACD_M;
@property (nonatomic,copy) NSString *MACD_12EMA;
@property (nonatomic,copy) NSString *MACD_26EMA;
@property (nonatomic,copy) NSString *KDJ_K;
@property (nonatomic,copy) NSString *KDJ_D;
@property (nonatomic,copy) NSString *KDJ_J;
@property (nonatomic,copy) NSString *RSI_1;
@property (nonatomic,copy) NSString *RSI_2;
@property (nonatomic,copy) NSString *RSI_3;
@property (nonatomic,copy) NSString *EMA;
@property (nonatomic,copy) NSString *EMA_Tianji_1;
@property (nonatomic,copy) NSString *EMA_Tianji_2;
@property (nonatomic,copy) NSString *BOLL_UP;
@property (nonatomic,copy) NSString *BOLL_MIDDLE;
@property (nonatomic,copy) NSString *BOLL_DOWN;
@property (nonatomic,copy) NSString *SMA;
@property (nonatomic,assign) FMKLineTianjiLineDirection tianjiLineDirection;

-(id)initWithDic:(NSDictionary *)dic;

@end
