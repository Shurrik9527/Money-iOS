//
//  CodeFieldView.h
//  Canary
//
//  Created by litong on 2017/5/25.
//  Copyright © 2017年 litong. All rights reserved.
//
//  验证码输入 倒计时

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CodeFieldType) {
    CodeFieldType_Reg = 1,//注册验证码
    CodeFieldType_ForgetPwd,//忘记密码验证码
    CodeFieldType_RegEX ,//交易所注册验证码
    CodeFieldType_ForgetPwdEX,//交易所忘记密码验证码
};

@protocol CodeFieldViewDelegate <NSObject>

- (void)sendCodeMsg;

@end


@interface CodeFieldView : UIView

@property (nonatomic,assign) id <CodeFieldViewDelegate> delegate;
@property (nonatomic,assign) CodeFieldType codeFieldType;
@property (nonatomic,strong) UITextField *codeField;

- (void)sendCodeSuccess;
- (void)addToolsBar;

@end




