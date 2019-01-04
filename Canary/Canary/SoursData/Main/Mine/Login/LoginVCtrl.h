//
//  LoginVCtrl.h
//  Canary
//
//  Created by litong on 2017/5/15.
//  Copyright © 2017年 litong. All rights reserved.
//
//  登录or注册

#import "BaseVCtrl.h"

typedef void(^LoginSuccess)();

@interface LoginVCtrl : BaseVCtrl

//YES：注册  ； NO：登录
@property (nonatomic,assign) BOOL isReg;
//登录成功回调
@property (nonatomic, copy) LoginSuccess loginSuccess;


@end
