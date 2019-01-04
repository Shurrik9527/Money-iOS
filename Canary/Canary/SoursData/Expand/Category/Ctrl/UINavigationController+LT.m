//
//  UINavigationController+LT.m
//  Canary
//
//  Created by litong on 2017/5/11.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "UINavigationController+LT.h"

@implementation UINavigationController (LT)


+ (UINavigationController *)navChangeStyleWithRootCtrl:(UIViewController *)ctrl {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
    [nav changeNavigationBar];
    return nav;
}


#pragma mark - UINavigationController

- (void)pushVCNoAnimate:(UIViewController *)ctrl {
    [self.navigationController pushViewController:ctrl animated:NO];
}

- (void)popVCNoAnimate {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)pushVC:(UIViewController *)ctrl {
    [self pushViewController:ctrl animated:YES];
}

- (void)pushVCWithClass:(Class)clas {
    if ([clas isSubclassOfClass:[UIViewController class]]) {
        UIViewController *ctrl = [[clas alloc] init];
        [self pushVC:ctrl];
    }
}

- (void)popVC {
    [self popViewControllerAnimated:YES];
}

- (void)popToVC:(UIViewController *)ctrl {
    [self popToViewController:ctrl animated:YES];
}

- (void)popToRootVC {
    [self popToRootViewControllerAnimated:YES];
    
}

- (void)popVCDelayOneSecond {
    [self popVCDelay:1];
}

- (void)popVCDelay:(NSTimeInterval)delay {
    [self performSelector:@selector(popVC) withObject:nil afterDelay:delay];
}

- (BOOL)isRootCtrl {
    return self.viewControllers.count > 1;
}


#pragma mark - 修改


/**
 *  @brief  设置背景图片
 *
 *  @param img 图片
 */
- (void)changeNavBgImage:(UIImage *)img {
    [self.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:img];//阴影颜色  （无黑色分割线，需要黑色分割线，注释此行）
}

/**
 *  @brief  设置背景颜色（同时设置阴影颜色，无黑色分割线）
 *
 *  @param color 背景颜色
 */
- (void)changeNavBgColor:(UIColor *)color {
    UIImage *img = [color imageFromUIColor];
    [self changeNavBgImage:img];
}


/**
 *  @brief  设置文字颜色和大小
 *
 *  @param color 颜色  如果为nil 不设置
 *  @param font  字体  如果为nil 不设置
 */
- (void)changeTitleColor:(UIColor *)color font:(UIFont *)font {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (color) {
        [dic setObject:color forKey:NSForegroundColorAttributeName];
    }
    if (font) {
        [dic setObject:font forKey:NSFontAttributeName];
    }
    
    NSDictionary * dict = [NSDictionary dictionaryWithDictionary:dic];
    self.navigationBar.titleTextAttributes = dict;
}
- (void)changeTitleColor:(UIColor *)color {
    [self changeTitleColor:color font:nil];
}
- (void)changeTitleFont:(UIFont *)font {
    [self changeTitleColor:nil font:font];
}

/**
 *  @brief  修改NavigationBar 文字颜色和大小、背景颜色、左右按钮颜色、是否透明
 */
- (void)changeNavigationBar {
    //设置文字颜色和大小
    [self changeTitleColor:[UIColor whiteColor] font:[UIFont boldFontOfSize:19.f]];
    
    //设置背景颜色
    [self changeNavBgColor:[UIColor purpleColor]];
    
    //导航条是否透明
    [self.navigationBar setTranslucent:NO];
    
    //左右按钮颜色
    self.navigationBar.tintColor = [UIColor whiteColor];
}


@end
