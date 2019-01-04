//
//  LTArcProgressView.m
//  LTDevDemo
//
//  Created by litong on 2017/2/14.
//  Copyright © 2017年 litong. All rights reserved.
//



#import "LTArcProgressView.h"


NSString * const LTProgressViewProgressAnimationKey = @"LTProgressViewProgressAnimationKey";
const NSTimeInterval kAnimationDuration = 0.3;

@interface LTArcProgressView ()
@property (nonatomic,assign) ArcProgressType type;//type
@property (nonatomic,assign) CGFloat lineWidth;//线条宽度
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic,strong) UIBezierPath *trackPath;
@property (nonatomic,strong) UIBezierPath *progressPath;

@property (nonatomic,strong) CAShapeLayer *trackLayer;
@property (nonatomic,strong) CAShapeLayer *progressLayer;

@end


@implementation LTArcProgressView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.type=ArcProgressType_Normal;
        self.backgroundColor = LTClearColor;
        [self createBezierPath];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame type:(ArcProgressType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = LTClearColor;
        if(type==ArcProgressType_Notice){
            self.lineWidth=1;
            _type=ArcProgressType_Notice;
        }
        [self createBezierPath];
    }
    return self;
}
//画两个圆形
- (void)createBezierPath {
    
    const double TWO_M_PI = 2.0 * M_PI;
    CGFloat startAngle = M_PI_2;
    if(_type==ArcProgressType_Notice){
        startAngle = -M_PI_2;
        self.arcUnfinishColor=[UIColor clearColor];
    }
    CGFloat endAngle = startAngle + TWO_M_PI;
    CGFloat w = self.frame.size.width;
    CGFloat radius = (w)/ 2;
    CGPoint arcCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    //外圆
    _trackPath = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:radius startAngle:0 endAngle:TWO_M_PI clockwise:YES];
    _trackLayer = [CAShapeLayer new];
    [self.layer addSublayer:_trackLayer];
    _trackLayer.fillColor = nil;
    _trackLayer.strokeColor = self.arcUnfinishColor.CGColor;
    _trackLayer.path = _trackPath.CGPath;
    _trackLayer.lineWidth = self.lineWidth;
    _trackLayer.frame = self.bounds;
    
    //内圆

    _progressPath = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    _progressLayer = [CAShapeLayer new];
    [self.layer addSublayer:_progressLayer];
    _progressLayer.fillColor = nil;
    _progressLayer.strokeColor = self.arcFinishColor.CGColor;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.path = _progressPath.CGPath;
    _progressLayer.lineWidth = self.lineWidth;
    _progressLayer.frame = self.bounds;
    [self updateProgress:0];
    
}

#pragma mark - utils

- (void)updateProgress:(CGFloat)progress {
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.progressLayer.strokeEnd = progress;
    [CATransaction commit];
}

- (void)animateToProgress:(CGFloat)progress {
    [self stopAnimation];

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = kAnimationDuration;
    animation.fromValue = @(self.progress);
    animation.toValue = @(progress);
    [self.progressLayer addAnimation:animation forKey:LTProgressViewProgressAnimationKey];
    _progress = progress;
}
//倒计时
- (void)animateWithTime:(CGFloat)time fromValue:(CGFloat)fvalue toValue:(CGFloat)tvalue{
    [self stopAnimation];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = time;
    animation.fromValue = @(fvalue);
    animation.toValue = @(tvalue);
    [self.progressLayer addAnimation:animation forKey:LTProgressViewProgressAnimationKey];
}
- (void)stopAnimation {
    [self.progressLayer removeAnimationForKey:LTProgressViewProgressAnimationKey];
}


#pragma mark - 属性


- (UIColor *)arcFinishColor {
    return _arcFinishColor ? _arcFinishColor : LTColorHex(0xFF7901);
}

//- (void)setArcFinishColor:(UIColor *)arcFinishColor {
//    [self willChangeValueForKey: @"tintColor"];
////    _arcFinishColor = arcFinishColor;
//    [self didChangeValueForKey: @"tintColor"];
//    [self tintColorDidChange];
//}

- (UIColor *)arcUnfinishColor {
    
    return _arcUnfinishColor ? _arcUnfinishColor : LTColorHexA(0x848999, 0.3);
}

- (CGFloat)lineWidth {
    return _lineWidth>0 ? _lineWidth : 4;
}


#pragma mark - 外部
- (void)changeColor:(UIColor *)color {
    [self willChangeValueForKey: @"tintColor"];
    _arcFinishColor = color;
    [self didChangeValueForKey: @"tintColor"];
    self.progressLayer.strokeColor = color.CGColor;
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    if (progress == 0) {
//        [self changeColor:self.arcUnfinishColor];
//        [self updateProgress:0];
        [self stopAnimation];
        _progress = 0;
        [self updateProgress:0];
        return;
    }
    progress = MAX( MIN(progress, 1.0), 0.0); // keep it between 0 and 1
    if (_progress == progress) {
        [self stopAnimation];
        _progress = 0;
        [self updateProgress:0];
    }
    
    if (animated) {
        [self animateToProgress:progress];
    } else {
        [self stopAnimation];
        _progress = progress;
        [self updateProgress:_progress];
    }
}

@end





