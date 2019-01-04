//
//  SelectProvinceVCtrl.h
//  Canary
//
//  Created by litong on 2017/6/2.
//  Copyright © 2017年 litong. All rights reserved.
//
//  选择省份

#import "BaseTableVCtrl.h"

@class ProvinceMO;
@protocol SelectProvinceDelegate <NSObject>

- (void)selectProvince:(ProvinceMO *)mo;

@end

@interface SelectProvinceVCtrl : BaseTableVCtrl

@property (nonatomic,assign) id<SelectProvinceDelegate> delegate;

@end


@interface ProvinceMO : BaseMO

@property (nonatomic,copy) NSString *code;//省编码
@property (nonatomic,copy) NSString *name;//省名称

@end
