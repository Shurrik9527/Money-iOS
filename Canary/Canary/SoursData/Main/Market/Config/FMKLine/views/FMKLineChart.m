//
//  FMKLineChart.m
//  golden_iphone
//
//  Created by dangfm on 15/6/11.
//  Copyright (c) 2015年 golden. All rights reserved.
//

#import "FMKLineChart.h"
#import "FMCalculationOperationQueue.h"
#import "FMCalculationKLine.h"
#import "FMCalculationMinuteLine.h"
#import "PushRemindModel.h"
@interface FMKLineChart(){
}
@property(strong,nonatomic)    FMKLineModel *model;//模型
@property(strong,nonatomic)  FMStageView *stageView;//图
@property(strong,nonatomic)FMCalculationOperationQueue *operationQueue;//线程

@end

@implementation FMKLineChart

-(instancetype)initWithFrame:(CGRect)frame Model:(FMKLineModel *)model{
    if (self==[super initWithFrame:frame]){
        NSLog(@"fmKLine super model.points=%@",_model.points);
        _model = model;
        _isBlack=NO;
        //[self createViews];
        // 创建计算队列
        [self createOperationQueue];
    }
    return self;
}

-(void)updateWithModel:(FMKLineModel *)model
{
    self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y, _model.width, _model.height);
    _model = model;

    [self updateLoadingViewFrame];
    // 创建计算队列
    [self createOperationQueue];
}

-(void)updateLoadingViewFrame
{
    if (_loadingView)
    {
        self.loadingView.frame = CGRectMake((Screen_width-kLoading_width)/2-self.frame.origin.x, (_model.height-kLoading_height)/2, kLoading_width, kLoading_height);
        if (_model.kLineDirectionStyle==FMKLineDirection_Horizontal)
        {
            self.loadingView.frame = CGRectMake((Screen_height-kLoading_width)/2-self.frame.origin.x, (_model.height-kLoading_height)/2, kLoading_width, kLoading_height);
        }
    }
}
-(void)start {
    if (!_isBlack) {
        return;
    }
    if (!self.loadingView) {
        self.loadingView = [[loadingView alloc] initWithTitle:@"数据加载中" Frame:CGRectMake((Screen_width-kLoading_width)/2, (_model.height-kLoading_height)/2, kLoading_width, kLoading_height)];
        [self addSubview:self.loadingView];
    }
    [self updateLoadingViewFrame];
    [self bringSubviewToFront:_loadingView];
    [_loadingView start];
}
-(void)end {
    _endBlock?_endBlock():nil;
    if (!_isBlack) {
        return;
    }
    [_loadingView stop];
}

-(void)error {
    [self updateLoadingViewFrame];
    if (_loadingView) {
        [_loadingView setError:@"暂时无法获取数据"];
    }
    
}

-(void)createViews {
    // 是否停止绘画
    if (_model.isStopDraw) {
        return;
    }
    if (!_stageView) {
        _stageView = [[FMStageView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, _model.height+20) Model:_model KLineChart:self];
        _stageView.isBlackBG=_isBlack;
        NSLog(@"_isBlack=%i",_isBlack);
        _stageView.backgroundColor=KLineBoxBG;
        [self addSubview:_stageView];
    }
    CGFloat w = Screen_width;
    CGFloat h = _model.height;
    if (_model.kLineDirectionStyle==FMKLineDirection_Horizontal) {
        w = Screen_height;
        h = _model.height;
    }
    _stageView.frame = CGRectMake(0, 0, w, h);
    _stageView.isBlackBG=_isBlack;
    [_stageView updateWithModel:_model];
    [self end];
}
-(void)auxiliaryLineWithList:(NSMutableArray *)array isShow:(BOOL)isShow limitSize:(NSInteger)limitSize {
    _isShowLine=isShow;
    _limitSize=limitSize;
    for(int i = 0;i<limitSize;i++){
        UIImageView *line=[self viewWithTag:1000000+i];
        if ([NSObject isNotNull:line]) {
            [line removeFromSuperview];
        }
    }
    if(isShow==NO){
        return;
    }
    for (int i = 0; i<array.count; i++) {
        PushRemindModel *model = array[i];
        CGFloat y = [self calculationY:[model.customizedProfit floatValue]];
//        CGFloat value = [model.customizedProfit floatValue];
        UIImageView *line=[[UIImageView alloc]initWithImage:[LTUtils dottedImageWithStartPoint:CGPointMake(0, 0) EndPoint:CGPointMake(self.w_, 0) Color:LTSureFontBlue Width:self.w_]];
        line.tag=1000000+i;
        [self addSubview:line];
        
        line.frame=CGRectMake(0, y, self.w_, 0.5);
        line.hidden=!isShow;
    }
}
-(void)positionLineWithList:(NSMutableArray *)array isShow:(BOOL)isShow{
    _isShowLine=isShow;
    for(int i = 0;i<10;i++){
        UIImageView *line=[self viewWithTag:100000+i];
        if ([line isNotNull]) {
            [line removeFromSuperview];
            line=nil;
        }
    }
    if(isShow==NO){
        return;
    }

}
-(void)createOperationQueue {
    if (_model.prices.count<=0) {
        return;
    }
    if(!_operationQueue) {
        _operationQueue = [[FMCalculationOperationQueue alloc] init];
    }
    //[_operationQueue waitUntilAllOperationsAreFinished];
    [_operationQueue cancelAllOperations];
    WS(ws);
    // 创建计算线程
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        //NSLog(@"start operation");
        if (ws.model.type>0)
        {
            NSLog(@"create Calculation");
            //计算K线
            FMCalculationKLine *calculation =
            [[FMCalculationKLine alloc] initWithModel:ws.model
                                  CalculationFinished:^(FMKLineModel*m){
                                      // 计算完成
                                      ws.model = m;
                                      // 更新界面
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          if (_model.prices.count>0) {
                                              [ws createViews];
                                          }
                                      });
                                  }
                                            UpdateAll:NO];
            calculation = nil;
        }
//        else
//        {
//            NSLog(@"create Calculation");
//
//            //计算分时
//            FMCalculationMinuteLine *calculation =
//            [[FMCalculationMinuteLine alloc] initWithModel:ws.model
//
//                                       CalculationFinished:^(FMKLineModel*m){
//
//                                      // 计算完成
//                                      ws.model = m;
//                                      // 更新界面
//                                      dispatch_async(dispatch_get_main_queue(), ^{
//                                          if (_model.prices.count>0) {
//                                              [ws createViews];
//                                          }
//                                      });
//                                  }
//                                                 UpdateAll:NO];
//            calculation = nil;
//        }
    }] ;
    // 加入队列
    [_operationQueue setMaxConcurrentOperationCount:1];
    
    [_operationQueue addOperation:operation];
    //[operation start];
}

-(CGFloat )calculationY:(CGFloat)price{
    CGFloat max= self.model.maxPrice;
    CGFloat min = self.model.minPrice;
    CGFloat sub = max - min;
    CGFloat subP=max - price;
    CGFloat addition = subP/sub;
    CGFloat y=self.frame.size.height *addition;
    return y;
}
@end
