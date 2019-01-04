//
//  UIViewController+LT.m
//  Canary
//
//  Created by litong on 2017/5/11.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "UIViewController+LT.h"

@implementation UIViewController (LT)




- (CGFloat)x_ {
    return self.view.frame.origin.x;
}

- (CGFloat)y_ {
    return self.view.frame.origin.y;
}

- (CGFloat)w_ {
    return self.view.frame.size.width;
}

- (CGFloat)h_ {
    return self.view.frame.size.height;
}

- (CGFloat)xw_ {
    return self.x_ + self.w_;
}

- (CGFloat)yh_ {
    return self.y_ + self.h_;
}


#pragma mark - UIViewController

- (void)presentVC:(UIViewController *)ctrl {
    [self presentViewController:ctrl animated:YES completion:nil];
}

- (void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - NavBar

- (void)navBarIsShow:(BOOL)bl {
    __block BOOL flag = bl;
    
    UINavigationBar *navbar = [[self navigationController] navigationBar];
    
    [UIView animateWithDuration:0.3 animations:^(void) {
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(setStatusBarHidden:withAnimation:)]) {
            [[UIApplication sharedApplication] setStatusBarHidden:flag withAnimation:NO];
            //             [self prefersStatusBarHidden];
        }
        
        CGFloat yy = flag ? 20 : -44;
        navbar.frame = CGRectMake(0, yy, self.view.frame.size.width, 44);
    }];
}


#pragma mark - UINavigationController

- (void)pushVCNoAnimate:(UIViewController *)ctrl {
    if (self.navigationController) {
        [self.navigationController pushViewController:ctrl animated:NO];
    }
}

- (void)popVCNoAnimate {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)pushVC:(UIViewController *)ctrl {
    if (self.navigationController) {
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}
- (void)pushVCWithClass:(Class)clas {
    if (self.navigationController) {
        if ([clas isSubclassOfClass:[UIViewController class]]) {
            //            UIViewController *ctrl = [[clas alloc] init];
            [self.navigationController pushViewController:[[clas alloc] init] animated:YES];
        }
    }
}


- (void)popVC {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)popToVC:(UIViewController *)ctrl {
    if (self.navigationController) {
        [self.navigationController popToViewController:ctrl animated:YES];
    }
}

- (void)popToRootVC {
    if (self.navigationController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)popVCDelayOneSecond {
    [self popVCDelay:1];
}

- (void)popVCDelay:(NSTimeInterval)delay {
    [self performSelector:@selector(popVC) withObject:nil afterDelay:delay];
}




//#pragma mark - 登录八元登录
///** push到本地登录 */
//- (void)pushLocLogin {
//    WQLoginOrRegirstVC *ctrl = [[WQLoginOrRegirstVC alloc] init];
//    [self pushVC:ctrl];
//}
///** push到本地登录 loginSucces：登录成功block */
//- (void)pushLocLogin:(LoginSuccess)loginSucces {
//    WQLoginOrRegirstVC *ctrl = [[WQLoginOrRegirstVC alloc] init];
//    ctrl.loginSuccess = loginSucces;
//    [self pushVC:ctrl];
//}
//
//- (BOOL)checkLocHasLogin:(NSString *)message {
//    if ([LTUser hasLogin]) {
//        return YES;
//    }
//    
//    if (notemptyStr(message)) {
//        WS(ws);
//        [self alertLocLogin:message sureAction:^{
//            [ws pushLocLogin];
//        } cancelAction:nil];
//    } else {
//        [self pushLocLogin];
//    }
//    return NO;
//}
//
//- (BOOL)checkLocHasLogin {
//    if ([LTUser hasLogin]) {
//        return YES;
//    }
//    [self pushLocLogin];
//    return NO;
//}
//
//- (void)alertLocLogin:(NSString *)title sureAction:(LTAlertAction)sureAction cancelAction:(LTAlertAction)cancelAction {
//    [LTAlertView alertTitle:title message:nil sureTitle:@"去登录" sureAction:^{
//        sureAction ? sureAction() : nil;
//    } cancelTitle:@"取消" cancelAction:^{
//        cancelAction ? cancelAction() : nil;
//    }];
//}


@end
