//
//  InputPwdVCtrl.m
//  Canary
//
//  Created by litong on 2017/6/5.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "InputPwdVCtrl.h"
#import "FieldView.h"
#import "ForgetPwdCtrl.h"

#define kCellTemp 12
#define kCellH 45
#define kCellW (kMidW)

@interface InputPwdVCtrl ()

@property (nonatomic,strong) FieldView *pwdView;//密码

@end

@implementation InputPwdVCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navPopBackTitle:@"请输入密码"];
    [self createView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createView {
    self.pwdView = [[FieldView alloc] initWithFrame:CGRectMake(kLeftMar, NavBarTop_Lit + 12, kMidW, 45)];
    [_pwdView configPlaceholder:@"请输入密码"];
    [self.view addSubview:_pwdView];
    
    UIButton *commitBtn = [UIButton commitBlueBtn:self action:@selector(commitAction) y:_pwdView.yh_ + kCellTemp text:@"完成"];
    [self.view addSubview:commitBtn];
    
    UIButton *forgetPwdBtn = [UIButton btnWithTarget:self action:@selector(forgetPwdAction) frame:CGRectMake(kLeftMar, commitBtn.yh_+5, kMidW, 40)];
    [forgetPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetPwdBtn setTitleColor:LTSureFontBlue forState:UIControlStateNormal];
    [self.view addSubview:forgetPwdBtn];
}

- (void)commitAction {
    NSString *pwdStr = _pwdView.field.text;
    WS(ws);
    [self showLoadingView];
    NSString *lastPhone=UD_ObjForKey(kLastMobile);
    [RequestCenter reqLoginWithMobileNum:lastPhone password:pwdStr finsh:^(LTResponse *res) {
        [ws hideLoadingView];
        if (res.success) {
            [LTUser saveUser:res.resDict];
            NFC_PostName(NFC_LocLogin);
            ws.successBlock ?  ws.successBlock () : nil;
            [ws popVC];
        } else {
            ws.failBlock ?  ws.failBlock () : nil;
            [ws.view showTip:res.message];
        }
    }];
}

- (void)forgetPwdAction {
    ForgetPwdCtrl *ctrl = [[ForgetPwdCtrl alloc] init];
    [self pushVC:ctrl];
}

@end
