//
//  FMStockIndexs.h
//  FMStock
//
//  Created by dangfm on 15/5/7.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMKLineModel.h"
@interface FMStockIndexs : NSObject
#pragma mark 计算EMA
+(double)getEMA:(NSMutableArray*)list Number:(int)number;
#pragma mark 计算MACD值
+(NSMutableDictionary*)getMACD:(NSMutableArray*)list andDays:(int)day DhortPeriod:(int)shortPeriod LongPeriod:(int)longPeriod MidPeriod:(int)midPeriod;

#pragma mark 计算KDJ值
+(NSMutableDictionary*)getKDJMap:(NSArray*)m_kData;

#pragma mark 计算MA均线值
+(void)CalculateMA:(NSArray*)data;

#pragma mark 计算RSI值
+(void)getRSIWithDay:(int)day Key:(NSString*)key Number:(int)number Data:(NSArray*)data;
#pragma mark 新计算RSI值
+(float)RSI:(int)day N:(int)N list:(NSArray*)list ly:(float*)ly ly1:(float*)ly1;
#pragma mark 获取BOLL值
+(NSMutableDictionary*)getBOLLWithDay:(int)day K:(int)k N:(int)n Data:(NSArray*)data;

#pragma mark 计算MA均线
+(CGFloat)createMAWithPrices:(NSArray*)prices MA:(CGFloat)ma Index:(int)index;
#pragma mark 计算单个item
+(NSMutableDictionary *)klineItemWithArray:(NSMutableArray *)array
                                Dictionary:(NSDictionary *)item
                                     index:(int)i
                                       KDJ:(NSMutableDictionary *)KDJ;
#pragma mark - REF算法
/**
 *  REF
 *
 *  @param key  model字段
 *  @param day 下标天数
 *  @param list 模型数据
 *
 */
+(CGFloat)REF:(NSString *)key day:(NSInteger)day list:(NSArray *)list;
@end
