//
//  UIView+LTLoading.h
//  ixit
//
//  Created by litong on 2016/12/5.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LTLoading)

#pragma mark - 网络加载动画

/** 不需要文字 传 nil */
- (void)showLoadingWithMsg:(NSString *)msg;
/** 默认显示@"加载中..." */
- (void)showLoadingView;
/** 隐藏View */
- (void)hideLoadingView;

@end


@interface UIViewController (LTLoading)

#pragma mark - 网络加载动画

/** 不需要文字 传 nil */
- (void)showLoadingWithMsg:(NSString *)msg;
/** 默认显示@"加载中..." */
- (void)showLoadingView;
/** 隐藏View */
- (void)hideLoadingView;

@end


