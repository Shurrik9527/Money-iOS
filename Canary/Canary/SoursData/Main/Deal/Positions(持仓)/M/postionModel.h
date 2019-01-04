//
//  postionModel.h
//  Canary
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface postionModel : NSObject
@property (nonatomic,copy)NSString *login;//mt4id
@property (nonatomic,copy)NSString *close_price;//平仓价格
@property (nonatomic,copy)NSString *close_time;//平仓时间
@property (nonatomic,copy)NSString *open_price;//开仓价格
@property (nonatomic,copy)NSString *open_time;//开仓时间
@property (nonatomic,copy)NSString *profit;//收益
@property (nonatomic,copy)NSString *sl;//止损
@property (nonatomic,copy)NSString *tp;//止盈
@property (nonatomic,copy)NSString *symbol;//品种
@property (nonatomic,copy)NSString *ticket;//交易单号
@property (nonatomic,copy)NSString *volume;//手数
@property (nonatomic,copy)NSString *cmd;//交易类型

@property (nonatomic,copy)NSString * price_in;
@property (nonatomic,copy)NSString * price_out;


@end
