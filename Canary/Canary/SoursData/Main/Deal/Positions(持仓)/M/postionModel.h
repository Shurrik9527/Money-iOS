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
@property (nonatomic,copy)NSString *sl;//止损
@property (nonatomic,copy)NSString *tp;//止盈
@property (nonatomic,copy)NSString *symbol;//品种
@property (nonatomic,copy)NSString *ticket;//交易单号
@property (nonatomic,copy)NSString *volume;//手数
@property (nonatomic,copy)NSString *cmd;//交易类型

@property (nonatomic,copy)NSString * price_in;
@property (nonatomic,copy)NSString * price_out;

@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *loginName;
@property (nonatomic,copy)NSString *symbolCode;//产品编码
@property (nonatomic,copy)NSString *symbolName;//
@property (nonatomic,copy)NSString *createTime;//建仓时间
@property (nonatomic,assign)NSInteger lot;//手数
@property (nonatomic,assign)CGFloat unitPrice;//建仓成本
@property (nonatomic,assign)CGFloat money;//金额 （手数 X 建仓成本）
@property (nonatomic,assign)CGFloat overnightFee;//过夜费
@property (nonatomic,assign)CGFloat commissionCharges;//手续费
@property (nonatomic,assign)NSInteger transactionStatus;//交易状态 1建仓 2平仓 3挂单 4取消 5爆仓
@property (nonatomic,assign)CGFloat exponent;//建仓价格
@property (nonatomic,assign)CGFloat closeOutPrice;//平仓价格
@property (nonatomic,copy)NSString *entryOrdersPrice;//挂单价格
@property (nonatomic,copy)NSString *errorRange;//挂单浮动点位
@property (nonatomic,copy)NSString *entryOrdersStratPrice;
@property (nonatomic,copy)NSString *entryOrdersEndPrice;
@property (nonatomic,copy)NSString *endTime;//平仓时间
@property (nonatomic,copy)NSString *stopLossExponent;
@property (nonatomic,copy)NSString *stopProfitExponent;
@property (nonatomic,assign)CGFloat stopLossCount;//止损点数
@property (nonatomic,assign)CGFloat stopProfitCount;//止盈点数
@property (nonatomic,assign)NSInteger ransactionType;//1买涨 2买跌
@property (nonatomic,assign)NSInteger isOvernight;//1过夜 2不过夜
@property (nonatomic,copy)NSString *entryOrdersTime;//挂单时间
@property (nonatomic,assign)CGFloat profit;//收益
@property (nonatomic,assign)CGFloat presentPrice;//当前价格

@end
