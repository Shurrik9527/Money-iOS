//
//  TrendModel.h
//  Canary
//
//  Created by apple on 2018/3/22.
//  Copyright © 2018年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrendModel : NSObject
@property (nonatomic ,copy)NSString * time;//时间
@property (nonatomic ,copy)NSString *open;//开仓价格
@property (nonatomic ,copy)NSString * high;//高点
@property (nonatomic ,copy)NSString *low;//低点
@property (nonatomic ,copy)NSString * close;//平仓价格

@end
