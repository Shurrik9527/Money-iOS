//
//  FMCalculationKLine.h
//  golden_iphone
//
//  Created by dangfm on 15/6/11.
//  Copyright (c) 2015年 golden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMKLineModel.h"
@interface FMCalculationKLine : NSObject

@property (nonatomic,copy) CalculationFinished calculationFinished;         // 计算完成
// 初始化
-(instancetype)initWithModel:(FMKLineModel*)model CalculationFinished:(CalculationFinished)calculationFinished;
-(instancetype)initWithModel:(FMKLineModel *)model CalculationFinished:(CalculationFinished)calculationFinished UpdateAll:(BOOL)updateAll;
@end
