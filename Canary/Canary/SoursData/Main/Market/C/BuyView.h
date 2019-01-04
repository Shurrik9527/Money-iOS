//
//  BuyView.h
//  Canary
//
//  Created by litong on 2017/5/26.
//  Copyright © 2017年 litong. All rights reserved.
//
//  建仓view

#import "BasePopView.h"
#import "ProductMO.h"
#define kBuyViewH 560

typedef void(^BuyFinish)();

@interface BuyView : BasePopView

@property (nonatomic,copy) BuyFinish buyFinish;
@property (nonatomic,copy)NSString * code;
@property (nonatomic,copy)NSString *stops_level;
@property (nonatomic,assign)NSInteger  dataly;//小数点位数

- (void)buyType:(BuyType)buyType;

-(void)addCode :(NSString *)code code_cn:(NSString *)code_cn prcieIn:(NSString*)priceI  priceOut:(NSString *)priceOut;

@end
