//
//  ProductVCtrl.h
//  Canary
//
//  Created by Brain on 2017/5/17.
//  Copyright © 2017年 litong. All rights reserved.
//
//  产品列表VC

#import "BaseTableVCtrl.h"

@interface ProductVCtrl : BaseTableVCtrl


//产品轮询
//- (void)pollingProducts;
//取消产品轮询
- (void)canclePollingProducts;

- (void)showWarningAddHeader:(BOOL)bl;

@end
