//
//  FMBaseLine.h
//  golden_iphone
//
//  Created by dangfm on 15/6/11.
//  Copyright (c) 2015年 golden. All rights reserved.
//

#import "FMBaseView.h"
#import "FMKLineModel.h"
@interface FMBaseLine : FMBaseView

#pragma mark K线初始化并画图
-(instancetype)initWithFrame:(CGRect)frame Model:(FMKLineModel*)model PointKey:(NSString*)key;
-(void)updateWithModel:(FMKLineModel *)model;
@property(assign,nonatomic)BOOL isBlack;

@end
