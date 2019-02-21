//
//  SocketModel.h
//  Canary
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SocketMarketTimeModel;
@class SocketCreateTimeModel;

@interface SocketModel : NSObject
@property (nonatomic,copy)NSString * dataStr;//日期
@property (nonatomic,copy)NSString * symbol;//品种
@property (nonatomic,copy)NSString * timeStr;//时间
@property (nonatomic,copy)NSString * buy_out;//卖出价
@property (nonatomic,copy)NSString * buy_in;//买入价
@property (nonatomic,copy)NSString * closePrice;
@property (nonatomic,copy)NSString * symbol_cn;
@property (nonatomic,copy)NSString * price;
@property (nonatomic,copy)NSString * symbolCode;
@property (nonatomic,strong)NSString * id;
@property (nonatomic,strong)SocketCreateTimeModel * createTime;
@property (nonatomic,strong)SocketMarketTimeModel * marketTime;

@end

@interface SocketCreateTimeModel : NSObject

@property (nonatomic,copy)NSString * date;
@property (nonatomic,copy)NSString * day;
@property (nonatomic,copy)NSString * hours;
@property (nonatomic,copy)NSString * minutes;
@property (nonatomic,copy)NSString * month;
@property (nonatomic,copy)NSString * seconds;
@property (nonatomic,copy)NSString * time;
@property (nonatomic,copy)NSString * timezoneOffset;
@property (nonatomic,copy)NSString * year;

@end

@interface SocketMarketTimeModel : NSObject

@property (nonatomic,copy)NSString * date;
@property (nonatomic,copy)NSString * day;
@property (nonatomic,copy)NSString * hours;
@property (nonatomic,copy)NSString * minutes;
@property (nonatomic,copy)NSString * month;
@property (nonatomic,copy)NSString * seconds;
@property (nonatomic,copy)NSNumber * time;
@property (nonatomic,copy)NSString * timezoneOffset;
@property (nonatomic,copy)NSString * year;

@end
