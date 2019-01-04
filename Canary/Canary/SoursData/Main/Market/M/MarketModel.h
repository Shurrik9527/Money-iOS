//
//  MarketModel.h
//  Canary
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarketModel : NSObject
@property (nonatomic,copy)NSString * symbol;//品种名称
@property (nonatomic,copy)NSString *symbol_cn;//中文名称
@property (nonatomic,copy)NSString * buy_out;//卖出价
@property (nonatomic,copy)NSString *buy_in;//买入价
@property (nonatomic,copy)NSString * timeStr;
@property (nonatomic,copy)NSString * dataStr;
@property (nonatomic,copy)NSString * open;
@property (nonatomic,copy)NSString * high;
@property (nonatomic,copy)NSString * low;
@property (nonatomic,copy)NSString *close;
@property (nonatomic,copy)NSString *stops_level;//浮动点
@property (nonatomic,assign)NSInteger  isAllSelect;
@property (nonatomic,assign)NSUInteger  digit;//小数点点位数
@property (nonatomic,assign)BOOL visible;//是否显示
@property (nonatomic,assign)BOOL trading;//是否可交易
@end
