//
//  DealHistoryMO.h
//  Canary
//
//  Created by litong on 2017/6/5.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BaseMO.h"

@interface DealHistoryMO : BaseMO

@property (nonatomic,copy) NSString *orderId;//订单ID
@property (nonatomic,copy) NSString *productId;//产品ID
@property (nonatomic,copy) NSString *productName;//产品名称
@property (nonatomic,copy) NSString *code;//产品code

@property (nonatomic,copy) NSString *amount;//建仓消费金额
@property (nonatomic,copy) NSString *createPrice;//建仓行情价格
@property (nonatomic,copy) NSString *createTime;//建仓时间

@property (nonatomic,copy) NSString *closePrice;//平仓行情价格
@property (nonatomic,copy) NSString *closeTime;//平仓时间
@property (nonatomic,copy) NSString *closeType;//平仓类型3.手动平仓,4.止盈平仓,5.止损平仓,6.爆仓,7.休市平仓

@property (nonatomic,copy) NSString *deferred;//累计过夜费
@property (nonatomic,copy) NSString *fee;//手续费
@property (nonatomic,copy) NSString *isProfit;//是否是盈利单 0.持平,1.盈利,2.亏损

@property (nonatomic,copy) NSString *type;//购买方向1.跌 2.涨
@property (nonatomic,copy) NSString *orderNumber;//购买手数
@property (nonatomic,copy) NSString *profitLoss;//盈亏

@property (nonatomic,copy) NSString *stopLoss;//止损
@property (nonatomic,copy) NSString *stopProfit;//止盈


-(NSString *)amount_fmt;//建仓金额
-(NSString *)profitLoss_fmt;
-(NSString *)deferred_fmt;
-(NSString *)fee_fmt;

-(NSString *)createPrice_fmt;//建仓价
-(NSString *)closePrice_fmt;//持仓价
-(NSString *)stopLoss_fmt;
-(NSString *)stopProfit_fmt;

- (NSString *)closeTime_fmt;

/**
 amount = 9000;//
 closePrice = "1262.18";//
 closeTime = "2017-06-02 21:05:25";//
 
 closeType = "<null>";//
 createPrice = "1262.63";//
 createTime = "2017-06-02 21:05:21";//
 
 deferred = 0;//
 fee = 270;//
 isProfit = 2;//
 
 orderId = 6739035;//
 orderNumber = 9;//
 productId = 3b76f3c351e6e494;//
 
 productName = "\U9ec4\U91d1";//
 profitLoss = "-675";//
 type = 2;//

 
 */
-(NSString *)closeTypeStr;
@end
