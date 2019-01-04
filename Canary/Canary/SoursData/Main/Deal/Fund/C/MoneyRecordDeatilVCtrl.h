//
//  MoneyRecordDeatilVCtrl.h
//  Canary
//
//  Created by litong on 2017/6/2.
//  Copyright © 2017年 litong. All rights reserved.
//
//  出金、入金详情VC

#import "BaseTableVCtrl.h"
#import "MoneyRecordCell.h"

@interface MoneyRecordDeatilVCtrl : BaseTableVCtrl

@property (nonatomic,assign) MoneyRecordType typ;
@property (nonatomic,strong) MoneyRecordMO *mo;

@end
