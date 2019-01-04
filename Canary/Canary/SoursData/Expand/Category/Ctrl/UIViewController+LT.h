//
//  UIViewController+LT.h
//  Canary
//
//  Created by litong on 2017/5/11.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LT)


@property(nonatomic,readonly)CGFloat x_;
@property(nonatomic,readonly)CGFloat y_;
@property(nonatomic,readonly)CGFloat w_;
@property(nonatomic,readonly)CGFloat h_;

@property(nonatomic,readonly)CGFloat xw_;        //x+width
@property(nonatomic,readonly)CGFloat yh_;         //y+heiht


#pragma mark - UIViewController

- (void)presentVC:(UIViewController *)ctrl;
- (void)dismissVC;

#pragma mark - UINavigationController

- (void)pushVCNoAnimate:(UIViewController *)ctrl;
- (void)popVCNoAnimate;
- (void)pushVC:(UIViewController *)ctrl;
- (void)pushVCWithClass:(Class)clas;
- (void)popVC;
- (void)popToVC:(UIViewController *)ctrl;
- (void)popToRootVC;
- (void)popVCDelayOneSecond;
- (void)popVCDelay:(NSTimeInterval)delay;



#pragma mark - 登录八元登录

///** push到本地登录 */
//- (void)pushLocLogin;
///** push到本地登录 loginSucces：登录成功block */
//- (void)pushLocLogin:(LoginSuccess)loginSucces;
//- (BOOL)checkLocHasLogin:(NSString *)message;
//- (BOOL)checkLocHasLogin;
//
//- (void)alertLocLogin:(NSString *)title sureAction:(LTAlertAction)sureAction cancelAction:(LTAlertAction)cancelAction;


@end
