//
//  MyGainModel.h
//  ixit
//
//  Created by litong on 2016/11/14.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "BaseMO.h"

/** 我的盈利单，我的交易记录 */
@interface MyGainModel : BaseMO

@property (nonatomic,copy) NSString *amount;  //"80.00";
@property (nonatomic,copy) NSString *closePrice;  //"2276.1";
@property (nonatomic,copy) NSString *closeTime;  //"2016-11-14 20:07:47";
@property (nonatomic,copy) NSString *closeType;  //"\U624b\U52a8\U5e73\U4ed3";
@property (nonatomic,copy) NSString *createPrice;  //"2277.2";
@property (nonatomic,copy) NSString *createTime;  //"2016-11-14 20:06:49";
@property (nonatomic,copy) NSString *exchangeName;  //"";
@property (nonatomic,copy) NSString *fee;  //"6.00";
@property (nonatomic,copy) NSString *isJuan;  //"\U672a\U4f7f\U7528";
@property (nonatomic,copy) NSString *isProfit;  //"<null>";
@property (nonatomic,copy) NSString *orderId;  //3014805;
@property (nonatomic,copy) NSString *productName;  //"\U6cb9";
@property (nonatomic,copy) NSString *productPrice;  //"80.00";
@property (nonatomic,copy) NSString *profitLoss;  //"1.10";
@property (nonatomic,copy) NSString *profitRate;  //"1%";
@property (nonatomic,copy) NSString *stopLoss;  //"";
@property (nonatomic,copy) NSString *stopProfit;  //"";
@property (nonatomic,copy) NSString *type;  //"";
@property (nonatomic,copy) NSString *unit;  //"\U5428";

@property (nonatomic,assign) NSInteger exchangeId;  //2;
@property (nonatomic,assign) NSInteger orderNumber;  //1;
@property (nonatomic,assign) CGFloat weight;  //1;


- (NSString *)price_fmt;

@end
