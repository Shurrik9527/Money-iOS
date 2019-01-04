//
//  SocketModel.h
//  Canary
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocketModel : NSObject
@property (nonatomic,copy)NSString * dataStr;//日期
@property (nonatomic,copy)NSString * symbol;//品种
@property (nonatomic,copy)NSString * timeStr;//时间
@property (nonatomic,copy)NSString * buy_out;//卖出价
@property (nonatomic,copy)NSString * buy_in;//买入价
@property (nonatomic,copy)NSString * closePrice;
@end
