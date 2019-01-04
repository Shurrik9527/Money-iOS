//
//  PublicData.m
//  Canary
//
//  Created by litong on 2017/5/11.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "PublicData.h"

@implementation PublicData

@synthesize isCustomer;
@synthesize replayCellHeight;
@synthesize mineInfoAtChatroom;
@synthesize chatRoomId;
@synthesize timeList;
@synthesize json_stockindexs;
@synthesize json_defProTypeList;
static PublicData* sharedInstance = nil;

+ (PublicData *)sharedData {
    @synchronized ([PublicData class]) {
        if (sharedInstance==nil) {
            sharedInstance=[[PublicData alloc]init];
            return sharedInstance;
        }
    }
    return sharedInstance;
}

+ (id)alloc {
    @synchronized ([PublicData class]) {
        sharedInstance = [super alloc];
        return sharedInstance;
    }
    return nil;
}

- (PublicData *)init {
    if (self = [super init]) {
        isCustomer=NO;
        timeList=[[NSMutableArray alloc]init];
        json_stockindexs= @[
                           @{@"name":@"只显示K线",@"code":@"CLEAR"},
                           @{@"name":@"SMA均线",@"code":@"SMA"},
                           @{@"name":@"EMA均线",@"code":@"EMA"},
                           @{@"name":@"BOLL均线",@"code":@"BOLL"},
                           @{@"name":@"MACD指标",@"code":@"MACD"},
                           @{@"name":@"KDJ随机指标",@"code":@"KDJ"},
                           @{@"name":@"RSI强弱指标",@"code":@"RSI"}
                           ];
        json_defProTypeList=@[
                                            @{@"name":@"自选",@"code":@"ZiXuan"},
                                            @{@"name":@"外汇",@"code":@"FXBTG"},
                                            @{@"name":@"贵金属",@"code":@"FXBTG"},
                                            @{@"name":@"原油",@"code":@"FXBTG"},
                                            @{@"name":@"CFD",@"code":@"FXBTG"},
                                        ];
    }
    return self;
}
-(BOOL)isNull:(id)object
{
    // 判断是否为空串
    if ([object isEqual:[NSNull null]])
    {
        return NO;
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return NO;
    }
    else if (object==nil)
    {
        return NO;
    }
    return YES;
}

@end
