//
//  FMBackgroundScrollView.m
//  golden_iphone
//
//  Created by dangfm on 15/6/11.
//  Copyright (c) 2015年 golden. All rights reserved.
//

#import "FMBackgroundScrollView.h"
#import "FMBaseLine.h"
@interface FMBackgroundScrollView(){
    
    FMKLineModel *_model;       // 模型
    NSArray *_points;
    NSArray *_SMAPoints;
    BOOL _isfirst;
    FMBaseLine *_kLine;
    CGFloat _lastScale;
    CGFloat _lastWidth;
}
@end

@implementation FMBackgroundScrollView

-(instancetype)initWithFrame:(CGRect)frame Model:(FMKLineModel*)model{
    if (self == [super initWithFrame:frame]) {
        _model = model;
        self.backgroundColor = LTClearColor;
        self.scrollEnabled = YES;
        self.maximumZoomScale = 1.0;
        self.minimumZoomScale = 0.0;
        _isfirst = YES;
        _lastScale = 1.0;
        //self.decelerationRate = 0.5;
        _lastWidth = _model.klineWidth;
        [self updateView];
    }
    return self;
}

-(void)dealloc{
    _points = nil;
    _kLine = nil;
    _model = nil;
}

-(void)handlePinch:(UIPinchGestureRecognizer*)pinch{
    //NSLog(@"handlePinch:%lu",(unsigned long)pinch.numberOfTouches);
    _model.isZooming = YES;
    if (_model.type<=0) {
        return;
    }
    //当手指离开屏幕时,将lastscale设置为1.0
    if([(UIPinchGestureRecognizer*)pinch state] == UIGestureRecognizerStateEnded) {
        _model.isZooming = NO;
        _lastWidth = _model.klineWidth;
        //_lastScale = 1.0;
        //NSLog(@"pinchEnd");
        return;
    }
    
    if ([[NSString stringWithFormat:@"%f",_model.klineWidth] isEqualToString:@"nan"]) {
        _model.klineWidth = 2;
    }
    if ([(UIPinchGestureRecognizer*)pinch state] == UIGestureRecognizerStateChanged && pinch.numberOfTouches==2) {
        if (self.zoomingBlock && _model.klineWidth>0 && ![[NSString stringWithFormat:@"%f",_model.klineWidth] isEqualToString:@"nan"] && _model.isFinished) {
            // 手指速度
            CGFloat speed = pinch.velocity;
            _lastScale = speed;
            if (_lastScale>3) _lastScale = 3;
            if (_lastScale<-3) _lastScale = -3;
            ///NSLog(@"lastScale=%f",_lastScale);
            _model.scrollDerectionType = FMKLineScrollRight;
            _model.scale = _lastScale;
            _model.klineWidth += _lastScale;
            _model.klineWidth = _model.klineWidth>20?20:_model.klineWidth;
            _model.klineWidth = _model.klineWidth<2?2:_model.klineWidth;
            
            int pointCounts = floor((_model.width) / (_model.klineWidth + _model.klinePadding))+1;
            if (_model.prices.count<=0) {
                pointCounts = 0;
            }
            _model.offsetStart = _model.offsetMiddle - pointCounts/2;
            if (_model.offsetStart<=0) {
                _model.offsetStart = 0;
            }
            if (_model.offsetStart!=_model.offsetLastStart || _model.offsetStart==0) {
                _model.offsetLastStart = _model.offsetStart;
                // 更新局部数据
                self.zoomingBlock(_model,_lastScale);
            }
            
        }
        
    }
    if (pinch.numberOfTouches<2) {
        _model.isZooming = NO;
    }
}
//父视图是否可以将消息传递给子视图，yes是将事件传递给子视图，则不滚动，no是不传递则继续滚动
- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    NSSet *allTouches=[event allTouches];
    if (allTouches.count==2) {
         _model.isZooming = NO;
        return NO;
    }
    _model.isZooming = NO;
    return YES;
}

-(void)updateWithModel:(FMKLineModel *)model{
    _model = model;
    [self updateView];
}

#pragma mark 更新画布
-(void)updateView{
    CGFloat w = 0;
    CGFloat h = self.frame.size.height;

    // 计算背景宽高
    if (_model.prices.count<=0) {
        return;
    }
    w = (_model.klineWidth*_model.prices.count + _model.klinePadding*(_model.prices.count-1));
    self.contentSize = CGSizeMake(w, h);
    // 首次偏移
    [self firstOffset];
    // 放大缩小时更新偏移
    [self zoomingOffset];
    
}


#pragma mark 第一次偏移
-(void)firstOffset{
    if (_model.isReset) {
        _isfirst = YES;
    }
    //_isfirst = YES;
    if ((_isfirst && _model.prices.count>0)) {
        _isfirst = NO;
        CGFloat w = (_model.klineWidth*_model.prices.count + _model.klinePadding*(_model.prices.count-1));
        // 计算偏移距离
        CGFloat offsetStart = _model.offsetStart;
        CGFloat count = _model.prices.count;
        CGFloat start = offsetStart / count * 1.00;
        //NSLog(@"startIndex:%d",startIndex);
        CGFloat offsetWith = w * start;
        offsetWith = offsetWith<=0?0:offsetWith;
        self.contentOffset = CGPointMake(offsetWith, 0);
        // 更新偏移标识
        _model.scrollOffset = self.contentOffset;
    }
}
#pragma mark 放大缩小过程偏移
-(void)zoomingOffset{
    if (_model.isZooming) {
        if ([[NSString stringWithFormat:@"%f",_model.klineWidth] isEqualToString:@"nan"]) return;
        // 计算偏移距离
        _model.offsetStart = _model.offsetMiddle - (_model.offsetEnd-_model.offsetStart+1)/2;
        if (_model.offsetStart<=0) {
            _model.offsetStart = 0;
        }
        // 中间点离左边边界距离
        CGFloat left =  (_model.offsetMiddle) * (_model.klinePadding+_model.klineWidth);
        left = left - _model.width/2;
        if (left<=0) {
            left = 0;
        }
        if (_model.offsetEnd==_model.prices.count-1) {
            left = (_model.offsetEnd) * (_model.klinePadding+_model.klineWidth) - _model.width;
        }
        //NSLog(@"left:%f",left);
        self.contentOffset = CGPointMake(left, 0);
        // 更新偏移标识
        _model.scrollOffset = self.contentOffset;
    }
}

@end
