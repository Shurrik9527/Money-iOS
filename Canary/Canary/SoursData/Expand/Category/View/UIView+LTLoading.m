//
//  UIView+LTLoading.m
//  ixit
//
//  Created by litong on 2016/12/5.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "UIView+LTLoading.h"

#define LTLoadingViewTag        8956
#define LTRotateIVTag               8957
#define LTMsgLabTag               8958


@implementation UIView (LTLoading)

#pragma mark 网络加载动画

- (void)showLoadingWithMsg:(NSString *)msg {
    [self hideLoadingView];
    
    [self LT_createLoadingView:msg];
    
    UIView *loadingView = [self LT_loadingView];
    [self bringSubviewToFront:loadingView];
    
    UIImageView *rotateIV = [loadingView viewWithTag:LTRotateIVTag];
    [UIView LT_startRotationAnimation:rotateIV];
}

- (void)showLoadingView {
    [self showLoadingWithMsg:@"加载中..."];
}

- (void)hideLoadingView {
    UIImageView *rotateIV = [self LT_rotateIV];
    [UIView LT_endAnimation:rotateIV];
    [self LT_loadingViewRemoveFromSuperview];
}



#pragma mark - utils

- (void)LT_createLoadingView:(NSString *)msg {
    
    BOOL emptyMsg = !(msg);
    CGFloat viewWH = 0.3*ScreenW_Lit;
    CGFloat labelH = 36;
    CGFloat rotateIVMarY = emptyMsg ? 0 : 8;
    
    //背景图
    UIView *loadingView = [[UIView alloc] init];
    loadingView.frame = CGRectMake(0, 0, viewWH, viewWH);
    loadingView.center = self.center;
    loadingView.backgroundColor = LTTitleColor;
    loadingView.layer.cornerRadius = 5;
    loadingView.alpha = 0.8;
    loadingView.tag = LTLoadingViewTag;
    [self addSubview:loadingView];
    
    //旋转图
    UIImage *img = [UIImage imageNamed:@"Loading"];
    CGFloat imgW = img.size.width;
    CGFloat imgH = img.size.height;
    UIImageView *rotateIV = [[UIImageView alloc] init];
    rotateIV.frame = CGRectMake((viewWH - imgW)/2, (viewWH - imgH)/2 - rotateIVMarY, imgW, imgH);
    rotateIV.image = img;
    rotateIV.tag = LTRotateIVTag;
    [loadingView addSubview:rotateIV];
    
    //文字提示
    CGFloat lableX = 6;
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(lableX, rotateIV.frame.origin.y + imgH, viewWH - 2*lableX, labelH);
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = LTColorHex(0xB4B9CB);
    label.tag = LTMsgLabTag;
    label.numberOfLines = 0;
    label.text = msg;
    [loadingView addSubview:label];
    
}

-  (UIView *)LT_loadingView {
    UIView *loadingView = [self viewWithTag:LTLoadingViewTag];
    return loadingView;
}

- (UIImageView *)LT_rotateIV {
    UIView *loadingView = [self LT_loadingView];
    UIImageView *iv = [loadingView viewWithTag:LTRotateIVTag];
    return iv;
}

- (UILabel *)LT_loadingMsgLab {
    UIView *loadingView = [self LT_loadingView];
    UILabel *lab = [loadingView viewWithTag:LTMsgLabTag];
    return lab;
}

- (void)LT_loadingViewRemoveFromSuperview {
    UIView *loadingView = [self LT_loadingView];
    loadingView.hidden = YES;
    [loadingView removeFromSuperview];
}


+ (void)LT_startRotationAnimation:(UIView *)rotationView {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @(M_PI_2);
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 *20];
    rotationAnimation.duration = 10;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [rotationView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

+ (void)LT_endAnimation:(UIView *)rotationView {
    [rotationView.layer removeAllAnimations];
}



@end

#pragma mark - UIViewController


@implementation UIViewController (LTLoading)

#pragma mark  网络加载动画

- (void)showLoadingWithMsg:(NSString *)msg {
    [self.view showLoadingWithMsg:msg];
}

- (void)showLoadingView {
    [self.view showLoadingView];
}

- (void)hideLoadingView {
    [self.view hideLoadingView];
}

@end


