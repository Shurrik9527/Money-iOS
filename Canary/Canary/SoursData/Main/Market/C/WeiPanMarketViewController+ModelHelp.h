//
//  WeiPanMarketViewController+ModelHelp.h
//  ixit
//
//  Created by Brain on 2016/11/27.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "WeiPanMarketViewController.h"

@interface WeiPanMarketViewController (ModelHelp)
-(void)configStockWithDic:(NSDictionary *)dic;

-(void)initMinModel;
-(void)initDaysModel;

-(void)getMinuteStockData;
-(void)getDaysStockData;

-(void)updateMinModelWithStock:(QuotationDetailModel *)stock;
-(void)updateDaysModelWithStock:(QuotationDetailModel *)stock;

@end
