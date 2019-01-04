//
//  UINavigationController+LT.h
//  Canary
//
//  Created by litong on 2017/5/11.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (LT)


+ (UINavigationController *)navChangeStyleWithRootCtrl:(UIViewController *)ctrl;

#pragma mark - UINavigationController
//[self pushViewController:ctrl animated:NO];
- (void)pushVCNoAnimate:(UIViewController *)ctrl;
//[self popViewControllerAnimated:NO];
- (void)popVCNoAnimate;

//[self pushViewController:ctrl animated:YES];
- (void)pushVC:(UIViewController *)ctrl;
- (void)pushVCWithClass:(Class)clas;

//[self popViewControllerAnimated:YES];
- (void)popVC;

//[self popToViewController:ctrl animated:YES]
- (void)popToVC:(UIViewController *)ctrl;

//[self popToRootViewControllerAnimated:YES]
- (void)popToRootVC;

- (void)popVCDelayOneSecond;
- (void)popVCDelay:(NSTimeInterval)delay;

- (BOOL)isRootCtrl;


#pragma mark - 修改

/*!
 *  ***  新项目修改次方里面的参数  ***
 *  该方法可修改NavigationBar 文字颜色和大小、背景颜色、左右按钮颜色、是否透明
 */
- (void)changeNavigationBar;


/*!
 *  @brief  设置背景图片 （同时设置阴影颜色，无黑色分割线）
 */
- (void)changeNavBgImage:(UIImage *)img;
/*!
 *  @brief  设置背景颜色（同时设置阴影颜色，无黑色分割线）
 */
- (void)changeNavBgColor:(UIColor *)color;


/*!
 *  @brief  设置文字颜色和大小
 *
 *  @param color 颜色  如果为nil 不设置
 *  @param font  字体  如果为nil 不设置
 */
- (void)changeTitleColor:(UIColor *)color font:(UIFont *)font;
- (void)changeTitleColor:(UIColor *)color;
- (void)changeTitleFont:(UIFont *)font;



@end
