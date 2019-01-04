//
//  FMStageView.h
//  golden_iphone
//
//  Created by dangfm on 15/6/11.
//  Copyright (c) 2015年 golden. All rights reserved.
//

#import "FMBaseView.h"
#import "FMKLineModel.h"
#import "FMBackgroundScrollView.h"
#import "FMKLineChart.h"
#import "FMBaseLine.h"
@class FMKLineChart;
@interface FMStageView : FMBaseView
@property(assign,nonatomic)BOOL isBlackBG;
-(instancetype)initWithFrame:(CGRect)frame Model:(FMKLineModel*)model;
-(instancetype)initWithFrame:(CGRect)frame Model:(FMKLineModel*)model KLineChart:(FMKLineChart*)chart;
@end
