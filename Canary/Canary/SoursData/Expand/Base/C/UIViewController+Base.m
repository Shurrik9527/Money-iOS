//
//  UIViewController+Base.m
//  Canary
//
//  Created by litong on 2017/5/15.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "UIViewController+Base.h"
#import "ChatVC.h"
//#import "NIMSDK.h"
#import "CertificationVCtrl.h"
#import "CertificationResultVC.h"

@implementation UIViewController (Base)

#pragma mark - 认证
//跳转认证页
- (void)pushCertVC {
    CertificationVCtrl *ctrl = [[CertificationVCtrl alloc]init];
    [self pushVC:ctrl];
}

//跳转认证结果页
- (void)pushCertResultVC {
    CertificationResultVC *ctrl = [[CertificationResultVC alloc]init];
    [self pushVC:ctrl];
}


#pragma mark - 登录八元登录
/** push到本地登录 */
- (void)pushLocLogin {
    LoginVCtrl *ctrl = [[LoginVCtrl alloc] init];
    [self pushVC:ctrl];
}
/** push到本地登录 loginSucces：登录成功block */
- (void)pushLocLogin:(LoginSuccess)loginSucces {
    LoginVCtrl *ctrl = [[LoginVCtrl alloc] init];
    ctrl.loginSuccess = loginSucces;
    [self pushVC:ctrl];
}

- (BOOL)checkLocHasLogin:(NSString *)message {
    if ([LTUser hasLogin]) {
        return YES;
    }
    
    if (notemptyStr(message)) {
        WS(ws);
        [self alertLocLogin:message sureAction:^{
            [ws pushLocLogin];
        } cancelAction:nil];
    } else {
        [self pushLocLogin];
    }
    return NO;
}

- (BOOL)checkLocHasLogin {
    if ([LTUser hasLogin]) {
        return YES;
    }
    [self pushLocLogin];
    return NO;
}

- (void)alertLocLogin:(NSString *)title sureAction:(LTAlertAction)sureAction cancelAction:(LTAlertAction)cancelAction {
    [LTAlertView alertTitle:title message:nil sureTitle:@"去登录" sureAction:^{
        sureAction ? sureAction() : nil;
    } cancelTitle:@"取消" cancelAction:^{
        cancelAction ? cancelAction() : nil;
    }];
}



/** push到网页 */
- (void)pushWeb:(NSString *)url title:(NSString *)title {
    if (url) {
        WebVCtrl *ctrl = [[WebVCtrl alloc] initWithTitle:title url:[url toURL]];
        ctrl.useGoBack = YES;
        ctrl.backType = BackType_PopVC;
        [self pushVC:ctrl];
    }
}


/** present到网页 */
- (void)presentWeb:(NSString *)url title:(NSString *)title {
    if (url) {
        WebVCtrl *ctrl = [[WebVCtrl alloc] initWithTitle:title url:[url toURL]];
        [ctrl configBackType:BackType_Dismiss];
        [self presentVC:ctrl];
    }
}




//push到客服
- (void)pushToServer {
    NSString *customerAccid0 = UD_ObjForKey(kCustomerAccid);
    NSString *token0 = UD_ObjForKey(kCustomerToken);
    NSString *title = UD_ObjForKey(kStaffName);
    NSString *customerAccid = [customerAccid0 AES128Decrypt];
    NSString *token = [token0 AES128Decrypt];
    NSString *staffAccid = [UD_ObjForKey(kStaffAccid) AES128Decrypt];

    WS(ws);

//    if ([[NIMSDK sharedSDK].loginManager isLogined]) {
//        [[NIMSDK sharedSDK].loginManager logout:^(NSError * _Nullable error) {
//            
//        }];
//    }
//    
//    if (!removeTestData) {
//        customerAccid=@"18600004444";
//        token=@"888888";
//    }
//    
//    [[NIMSDK sharedSDK].loginManager login:customerAccid token:token completion:^(NSError * _Nullable error) {
//        if (!error) {
//            ChatVC *chat=[[ChatVC alloc]init];
//            chat.titleName=title;
//            chat.sessionId=staffAccid;
//            [ws.navigationController pushViewController:chat animated:YES];
//        }
//        
//        else {
//            [LTAlertView alertMessage:@"登录客服聊天失败"];
//        }
//    }];
}


@end
