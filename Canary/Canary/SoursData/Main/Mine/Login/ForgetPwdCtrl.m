//
//  ForgetPwdCtrl.m
//  Canary
//
//  Created by litong on 2017/5/26.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "ForgetPwdCtrl.h"
#import "FieldView.h"
#import "CodeFieldView.h"
#import "NetworkRequests.h"
#import "DataHundel.h"
#import "GTMBase64.h"

#define kCellTemp 12
#define kCellH 45
#define kCellW (kMidW)

#define kLineBlueColor   LTRGB(72, 119, 230)


@interface ForgetPwdCtrl ()<CodeFieldViewDelegate>

@property (nonatomic,strong) FieldView *phoneView;//手机号码
@property (nonatomic,strong) UIButton *finishBtn;//完成按钮
@property (nonatomic,strong) CodeFieldView *codeView;//验证码
@property (nonatomic,strong) FieldView *pwdView;//密码
@property (nonatomic,strong) UIButton *regBtn;//注册按钮
@property (nonatomic,assign) NSInteger codeId;

@end

@implementation ForgetPwdCtrl

- (instancetype)init {
    self = [super init];
    if (self) {
        [self navPopBackTitle:@"忘记密码"];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = LTBgColor;
    [self createView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createView {
    NSString *phone = [LTUtils phoneNumMid4Star];
    if (!phone) {
        phone = @"请输入手机号码";
    }
    self.phoneView = [[FieldView alloc] initWithFrame:CGRectMake(kLeftMar, NavBarTop_Lit + kCellTemp, kCellW, kCellH)];
    [_phoneView showEyeImge:NO];
    [_phoneView configPlaceholder:phone];
    [self.view addSubview:_phoneView];
    
    
    self.codeView = [[CodeFieldView alloc] initWithFrame:CGRectMake(kLeftMar, _phoneView.yh_ + kCellTemp, kCellW, kCellH)];
    _codeView.delegate = self;
    _codeView.codeFieldType = CodeFieldType_Reg;
    _codeView.codeField.keyboardType = UIKeyboardTypeNumberPad;
    [_codeView addToolsBar];
    [self.view addSubview:_codeView];
    
    
    self.pwdView = [[FieldView alloc] initWithFrame:CGRectMake(kLeftMar, _codeView.yh_+ kCellTemp, kCellW, kCellH)];
    [_pwdView configPlaceholder:@"设置6-12位数字、字母"];
    [self.view addSubview:_pwdView];
    
    self.regBtn = [self blueBtn:@"完成" y:_pwdView.yh_ + kCellTemp action:@selector(finishAction)];
    [self.view addSubview:_regBtn];
    
//    self.finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.finishBtn.frame = CGRectMake(kLeftMar, _phoneView.yh_ + kCellTemp , kCellW, kCellH);
//    self.finishBtn.titleLabel.font = fontSiz(15);
//    [self.finishBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
//    [self.finishBtn layerRadius:3 bgColor:LTColorHex(0x3A69E3)];
//    [self.finishBtn addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_finishBtn];
    
//    UILabel * textLabel =[[UILabel alloc]initWithFrame:CGRectMake(kLeftMar, self.finishBtn.yh_ + 5, self.finishBtn.w_, 50)];
//    textLabel.numberOfLines = 0;
//    textLabel.font =[UIFont systemFontOfSize:11];
//    textLabel.textColor = LTSubTitleColor;
//    textLabel.text = @"请确保准确填写您的注册手机，重置后的新密码会通过短信形式发送至您的手机！";
//    [self.view addSubview:textLabel];
}

- (UIButton *)blueBtn:(NSString *)title y:(CGFloat)y action:(SEL)acion {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(kLeftMar, y , kCellW, kCellH);
    btn.titleLabel.font = fontSiz(15);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn layerRadius:3 bgColor:LTColorHex(0x3A69E3)];
    [btn addTarget:self action:acion forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark CodeFieldViewDelegate

//发送验证码
- (void)sendCodeMsg {
    NSString *phoneStr = _phoneView.field.text;
    if (emptyStr(phoneStr)) {
        [self.view showTip:@"请输入手机号码"];
        return;
    }
    
    WS(ws);
    
    [self showLoadingView];
    [RequestCenter reqRegisterSMS:phoneStr finsh:^(LTResponse *res) {
        [ws hideLoadingView];
        DLog(@"data == %@",res.data);
        if ([res.rawDict objectForKey:@"msgCode"]) {
            [ws.codeView sendCodeSuccess];
            self.codeId = [res.data integerValue];
        }else
        {
            
        }
        
    }];
}

//发送验证码
- (void)finishAction {
    if ([self canNext]) {
        NSString *phoneStr = _phoneView.field.text;
        NSString *pwdStr = _pwdView.field.text;
        NSString *codeStr = _codeView.codeField.text;
        NSString * stringUrl = [NSString stringWithFormat:@"%@%@",BaseUrl,@"/login/forgetPassword"];
        
        pwdStr = [GTMBase64 stringByEncodingData:[[NSString stringWithFormat:@"zst%@013",pwdStr] dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSDictionary * dic = @{@"id":@(self.codeId),@"loginName":phoneStr,@"verificationCode":codeStr,@"password":pwdStr};
        NSLog(@"dic ==== %@",dic);
        WS(ws);
        [self showLoadingView];
        [[NetworkRequests sharedInstance] RegisterPOST:stringUrl dict:dic succeed:^(id data) {
            NSLog(@"data == %@",data);
            [ws hideLoadingView];
            if ([[data objectForKey:@"msgCode"]integerValue] == 0) {
                [ws popVC];
            }else
            {
                [LTAlertView alertMessage:[DataHundel messageObjetCode:[[data objectForKey:@"msgCode"]integerValue]]];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

-(void)showMyMessage:(NSString*)aInfo {
    if (aInfo.length > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:aInfo delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self popVC];
}

- (BOOL)canNext {
        NSString *phoneStr = _phoneView.field.text;
        NSString *pwdStr = _pwdView.field.text;
        NSString *codeStr = _codeView.codeField.text;
        if (emptyStr(phoneStr)) {
            [self.view showTip:@"请输入手机号码"];
            return NO;
        }
        if (![pwdStr is_password]) {
            [self.view showTip:@"请输入6-12位数字、字母"];
            return NO;
        }
        if (emptyStr(codeStr)) {
            [self.view showTip:@"请输入验证码"];
            return NO;
        }
        return YES;
    
}



@end
