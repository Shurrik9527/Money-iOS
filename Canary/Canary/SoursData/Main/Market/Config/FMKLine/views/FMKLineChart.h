//
//  FMKLineChart.h
//  golden_iphone
//
//  Created by dangfm on 15/6/11.
//  Copyright (c) 2015年 golden. All rights reserved.
//

#import "FMBaseView.h"
#import "FMStageView.h"
#import "loadingView.h"
@interface FMKLineChart : FMBaseView
@property(copy,nonatomic) DrawEndBlock endBlock;
@property(copy,nonatomic) CrossLineTipBlock crossLineTipBlock;
@property(copy,nonatomic) TapBoxBlock tapBoxBlock;
@property(retain,nonatomic) loadingView *loadingView;   // 加载视图
@property(assign,nonatomic)BOOL isBlack;

//push Remind
@property(assign,nonatomic)BOOL isShowLine;//是否显示辅助线
@property(assign,nonatomic)NSInteger limitSize;//是否显示辅助线

-(instancetype)initWithFrame:(CGRect)frame Model:(FMKLineModel*)model;
-(void)updateWithModel:(FMKLineModel*)model;
-(void)start;
-(void)end;
-(void)auxiliaryLineWithList:(NSMutableArray *)array isShow:(BOOL)isShow limitSize:(NSInteger)limitSize;//推送提醒辅助线
-(void)positionLineWithList:(NSMutableArray *)array isShow:(BOOL)isShow;//持仓辅助线

-(void)error;
@end
