//
//  RechargeVCtrl.h
//  Canary
//
//  Created by litong on 2017/5/16.
//  Copyright © 2017年 litong. All rights reserved.
//
//  入金  有网页提供

#import "BaseVCtrl.h"

@interface RechargeVCtrl : BaseVCtrl

@property (nonatomic, copy) void(^rechargeSuccess)();
- (void)configBackType:(BackType)backType;

@end
