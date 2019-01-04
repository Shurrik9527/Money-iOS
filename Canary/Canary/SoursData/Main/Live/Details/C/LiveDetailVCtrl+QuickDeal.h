//
//  LiveDetailVCtrl+QuickDeal.h
//  ixit
//
//  Created by litong on 2017/3/13.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "LiveDetailVCtrl.h"

/** 快速交易 */
@interface LiveDetailVCtrl (QuickDeal)<SelectProductViewDelegate>

- (void)createQuickDealView;
- (void)createSelectProductView;
- (void)loadProductList;
- (void)loadProductList:(BOOL)showError refSelectProuct:(BOOL)refSelectProuct needShow:(BOOL)needShow;

@end
