//
//  UIViewController+Base.h
//  Canary
//
//  Created by litong on 2017/5/15.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginVCtrl.h"

@interface UIViewController (Base)


#pragma mark - 认证
//跳转认证页
- (void)pushCertVC;
//跳转认证结果页
- (void)pushCertResultVC;

#pragma mark - 登录八元登录

/** push到本地登录 */
- (void)pushLocLogin;
/** push到本地登录 loginSucces：登录成功block */
- (void)pushLocLogin:(LoginSuccess)loginSucces;
- (BOOL)checkLocHasLogin:(NSString *)message;
- (BOOL)checkLocHasLogin;

- (void)alertLocLogin:(NSString *)title sureAction:(LTAlertAction)sureAction cancelAction:(LTAlertAction)cancelAction;



/** push到 IXITWebViewVC 网页 */
- (void)pushWeb:(NSString *)url title:(NSString *)title;
/** present到 WebViewController 网页 */
- (void)presentWeb:(NSString *)url title:(NSString *)title;

//push到客服
- (void)pushToServer;


@end
