//
//  SelectCityVCtrl.h
//  Canary
//
//  Created by litong on 2017/6/2.
//  Copyright © 2017年 litong. All rights reserved.
//
//  选择城市

#import "BaseTableVCtrl.h"


@class CityMO;
@protocol SelectCityDelegate <NSObject>

- (void)selectCity:(CityMO *)mo;

@end

@interface SelectCityVCtrl : BaseTableVCtrl

@property (nonatomic,copy) NSString *provinceCode;//省份code
@property (nonatomic,assign) id<SelectCityDelegate> delegate;

@end


@interface CityMO : BaseMO

@property (nonatomic,copy) NSString *provinceCode;//省编码
@property (nonatomic,copy) NSString *code;//城市编码
@property (nonatomic,copy) NSString *name;//城市名称

@end

