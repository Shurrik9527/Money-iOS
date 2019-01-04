//
//  InputPwdVCtrl.h
//  Canary
//
//  Created by litong on 2017/6/5.
//  Copyright © 2017年 litong. All rights reserved.
//
//  重新输入密码

#import "BaseVCtrl.h"

/* 重新登录成功 */
typedef void(^InputPwdSuccess)(void);
/* 重新登录失败 */
typedef void(^InputPwdFail)(void);

@interface InputPwdVCtrl : BaseVCtrl

@property (nonatomic,copy) InputPwdSuccess successBlock;
@property (nonatomic,copy) InputPwdFail failBlock;

@end
