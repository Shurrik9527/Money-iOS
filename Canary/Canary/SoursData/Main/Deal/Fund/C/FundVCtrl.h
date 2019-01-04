//
//  FundVCtrl.h
//  Canary
//
//  Created by litong on 2017/5/16.
//  Copyright © 2017年 litong. All rights reserved.
//
//  资金VC

#import "BaseTableVCtrl.h"

#define kStr_FundRecharge                  @"入金"
#define kStr_FundWithdraw                   @"出金"
#define kStr_FundManagerBankCard    @"管理银行卡"
#define kStr_FundDealHistory                @"交易历史"
#define kStr_FundMoneyRecord            @"出入金记录"


@protocol FundVCtrlDelegate <NSObject>

- (void)fundPush:(NSString *)tit;

@end

@interface FundVCtrl : BaseTableVCtrl

@property (nonatomic,assign) id<FundVCtrlDelegate> delegate;
- (void)showWarningAddHeader:(BOOL)bl;

@end
