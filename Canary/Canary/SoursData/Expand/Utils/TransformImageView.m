//
//  TransformImageView.m
//  FMStock
//
//  Created by dangfm on 15/5/5.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

#import "TransformImageView.h"

#define degreesToRadians(x) (M_PI*(x))
#define KRotateSpeed 0.2

enum {
    enSvCropClip,               // the image size will be equal to orignal image, some part of image may be cliped
    enSvCropExpand,             // the image size will expand to contain the whole image, remain area will be transparent
};
typedef NSInteger SvCropMode;


@interface TransformImageView()<CAAnimationDelegate>
{
    UITapGestureRecognizer *tap;
    int count;
    BOOL isRuning;
}

@end

@implementation TransformImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        angle = 0;
        isStop = YES;
        UIImage *image =  [UIImage imageNamed:@"shuaxin"];
        self.frame = frame;
        self.backgroundColor = LTClearColor;
        [self setImage:image forState:UIControlStateNormal];
        [self addTarget:self  action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
        image = nil;
    }
    return self;
}

-(void)dealloc{
    
}

#pragma mark ---------------------------自定义方法--------------------------
#pragma mark 开始旋转
-(void)start{
    // 旋转停止后才开始
    if (isStop) {
        isStop = NO;
        count = 10; // 防止死循环转个不停
        
        [self transformAction];
    }
}
#pragma mark 图片旋转
-(void)transformAction {
    [self.layer removeAllAnimations];
    //旋转动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"transform" ];
    animation.delegate = self;
    CATransform3D tans3D = self.layer.transform;
    tans3D = CATransform3DMakeRotation(M_PI/2, 0, 0, 1);//180度
    animation.toValue = [NSValue valueWithCATransform3D:tans3D];
    animation.duration = KRotateSpeed;
    animation.cumulative = YES;
    animation.repeatCount = 4;
    [self.layer addAnimation:animation forKey:@"animation"];
}
#pragma mark 旋转停止
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    count -= 1;
    if (!isStop && count>0) {
        [self transformAction];
    }else{
        [self.layer removeAllAnimations];
    }
}
#pragma mark 停止旋转
-(void)stop{
    isStop = YES;
}
#pragma mark 点击旋转图片
-(void)clickAction{
    if (self.clickActionBlock) {
        [self start];
        self.clickActionBlock(self);
    }
}


@end
