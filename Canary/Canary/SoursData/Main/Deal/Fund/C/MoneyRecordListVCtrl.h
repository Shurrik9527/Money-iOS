//
//  MoneyRecordListVCtrl.h
//  Canary
//
//  Created by litong on 2017/6/2.
//  Copyright © 2017年 litong. All rights reserved.
//
// 出入金记录列表VC

#import "BaseTableVCtrl.h"
#import "MoneyRecordCell.h"



@protocol MoneyRecordDelegate <NSObject>

- (void)pushDetails:(MoneyRecordMO *)obj typ:(MoneyRecordType)typ;

@end

@interface MoneyRecordListVCtrl : BaseTableVCtrl

@property (nonatomic,assign) MoneyRecordType typ;
@property (nonatomic,assign) id<MoneyRecordDelegate> delegate;

@end
