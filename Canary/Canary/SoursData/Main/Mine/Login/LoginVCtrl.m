//
//  LoginVCtrl.m
//  Canary
//
//  Created by litong on 2017/5/15.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "LoginVCtrl.h"
#import "FieldView.h"
#import "CodeFieldView.h"
#import "ForgetPwdCtrl.h"
#import "DataHundel.h"
#import "ChoicePopView.h"
#import "UserModel.h"
#import "NetworkRequests.h"
#import "NameField.h"
#import "AttachmentsModel.h"
#import "GTMBase64.h"
#import "JWTHundel.h"

#define kHeaderH 228
#define kTabH 48
#define kCellTemp 12
#define kCellH 45
#define kCellW (kMidW)

#define kTabBGColor    LTRGB(43, 46, 65)
#define kLineBlueColor   LTRGB(72, 119, 230)
#define SubmitBlueColor  LTRGB(58, 105, 227)

#define kTabBtnTag 10000

@interface LoginVCtrl ()<CodeFieldViewDelegate>

//头部
@property (nonatomic,strong) UIImageView *headerView;
@property (nonatomic,strong) UIButton *tabBtnLogin;
@property (nonatomic,strong) UIButton *tabBtnRegister;
@property (nonatomic,strong) UIView *blueLineView;

//n内容
@property (nonatomic,strong) UIView *contentView;

//登录
@property (nonatomic,strong) UIView *loginView;//登录view
@property (nonatomic,strong) FieldView *phoneViewLogin;//手机号码
@property (nonatomic,strong) FieldView *pwdViewLogin;//密码
@property (nonatomic,strong) UIButton *loginBtn;//登录按钮
@property (nonatomic,strong) UIButton *forgetPwdBtn;//忘记密码按钮

//注册
@property (nonatomic,strong) UIView *registerView;//注册view
@property (nonatomic,strong) FieldView *phoneView;//手机号码
@property (nonatomic,strong) CodeFieldView *codeView;//验证码
@property (nonatomic,strong) FieldView *pwdView;//密码
@property (nonatomic,strong) NameField * nameView;//真实姓名
@property (nonatomic,strong) UIButton *regBtn;//注册按钮
@property (nonatomic,strong) UIButton *protocolBtn;//用户协议按钮
@property (nonatomic,strong)  ChoicePopView * popView;

@property (nonatomic,assign) NSInteger codeId;

@end

@implementation LoginVCtrl

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = LTRGB(34, 37, 55);
    
    [self createHeaderView];
    [self createContentView];
    
    [self.view addSingeTap:@selector(shutKeyboard) target:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - 头部

//头部背景
- (void)createHeaderView {
    self.headerView = [[UIImageView alloc] init];
    _headerView.frame = CGRectMake(0, 0, self.w_, kHeaderH);
    _headerView.image = [UIImage imageNamed:@"Login_BG"];
    _headerView.userInteractionEnabled = YES;
    [self.view addSubview:_headerView];
    
    [self createBackBtn];
    [self createTabBar];
    [self createLogoIV];
}
//图片logo
- (void)createLogoIV {
    UIImage *iconImg=[UIImage imageNamed:@"login_logo"];
    UIImageView *logoIV = [[UIImageView alloc]init];
    logoIV.frame = CGRectMake(0, 0, iconImg.size.width, iconImg.size.height);
    logoIV.image = iconImg;
    CGPoint centerPoint=_headerView.center;
    centerPoint.y -= 10;
    logoIV.center = centerPoint;
    [_headerView addSubview:logoIV];
}
//返回按钮
- (void)createBackBtn {
    UIImage *back_imge = [UIImage imageNamed:@"back"];
    if (kChangeImageColor) {
        back_imge = [back_imge changeColor:NavBarSubCoror];
    }
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, NavBarH_Lit, NavBarH_Lit)];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:back_imge forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:backBtn];
}

//点击返回按钮
- (void)backAction {
    [self popVC];
}

//登录 & 注册  按钮
- (void)createTabBar {
    
    UIView *tabView = [[UIView alloc] init];
    tabView.frame = CGRectMake(0, _headerView.h_ - kTabH, self.w_, kTabH);
    tabView.backgroundColor = kTabBGColor;
    [_headerView addSubview:tabView];
    
    self.tabBtnLogin = [self tabBtn:@"登录" idx:0];;
    [tabView addSubview:_tabBtnLogin];
    
    self.tabBtnRegister = [self tabBtn:@"注册" idx:1];
    [tabView addSubview:_tabBtnRegister];

    
    CGFloat lineH = 3;
    self.blueLineView = [[UIView alloc]init];
    _blueLineView.frame = CGRectMake(0, _headerView.h_ - lineH, self.w_*0.5,3);
    _blueLineView.backgroundColor = kLineBlueColor;
    [_headerView addSubview:_blueLineView];
    
    NSInteger idx = _isReg ? 1 : 0;
    [self selTabIdx:idx];
}

- (void)selTabBtn:(UIButton *)sender {
    NSInteger idx = sender.tag - kTabBtnTag;
    [self selTabIdx:idx];
}

- (void)selTabIdx:(NSInteger)idx {
    BOOL selLogin = (idx == 0);
    _isReg = (idx == 1);
    if (_isReg) {
        [self configRegPhone];
    } else {
        [self configLoginPhone];
    }
    [self configContentView];
    
    _tabBtnLogin.selected = selLogin;
    _tabBtnRegister.selected = !selLogin;
    
    WS(ws);
    [UIView animateWithDuration:0.3 animations:^{
        [ws.blueLineView setOX:(ScreenW_Lit*0.5*idx)];
    }];
}

#pragma mark - 内容

- (void)createContentView {
    self.contentView = [[UIView alloc] init];
    _contentView.frame = CGRectMake(0, _headerView.yh_, self.w_, self.h_ - _headerView.yh_);
    _contentView.backgroundColor = LTBgColor;
    [self.view addSubview:_contentView];
    
    [self createLoginView];
    [self createRegView];
    
    [self configContentView];
}

- (void)configContentView {
    self.registerView.hidden = !_isReg;
    self.loginView.hidden = _isReg;
}

#pragma mark 登录

- (void)createLoginView {
    self.loginView = [[UIView alloc] init];
    _loginView.frame = CGRectMake(0, 0, self.w_, _contentView.h_);
    _loginView.backgroundColor = LTBgColor;
    [_contentView addSubview:_loginView];
    
    NSString *phone = [LTUtils phoneNumMid4Star];
    if (!phone) {
        phone = @"请输入手机号码";
    }
    
    self.phoneViewLogin = [[FieldView alloc] initWithFrame:CGRectMake(kLeftMar, kCellTemp, kCellW, kCellH)];
    _phoneViewLogin.field.keyboardType = UIKeyboardTypeNumberPad;
    [_phoneViewLogin addToolsBar];
    [_phoneViewLogin showEyeImge:NO];
    [_phoneViewLogin configPlaceholder:phone];
    [_loginView addSubview:_phoneViewLogin];
    
    [self configLoginPhone];
    
    self.pwdViewLogin = [[FieldView alloc] initWithFrame:CGRectMake(kLeftMar, _phoneViewLogin.yh_+ kCellTemp, kCellW, kCellH)];
    [_pwdViewLogin configPlaceholder:@"请输入密码"];
    _pwdViewLogin.field.keyboardType = UIKeyboardTypeDefault;
    [_loginView addSubview:_pwdViewLogin];
    
    self.loginBtn = [self blueBtn:@"登录" y:_pwdViewLogin.yh_ + kCellTemp action:@selector(loginAction)];
    [_loginView addSubview:_loginBtn];
    
    self.forgetPwdBtn = [UIButton btnWithTarget:self action:@selector(forgetPwdAction) frame:CGRectMake(kLeftMar, _loginBtn.yh_ + kCellTemp, kCellW, 20)];
    [_forgetPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    _forgetPwdBtn.titleLabel.font = fontSiz(13);
    [_forgetPwdBtn setTitleColor:kLineBlueColor forState:UIControlStateNormal];
    [_loginView addSubview:_forgetPwdBtn];
}

- (void)configLoginPhone {
    _phoneViewLogin.saveFieldKey = kLastMobile;
    NSString *str = [UserDefaults objectForKey:kLastMobile];
    if (str) {
        _phoneViewLogin.field.text = str;
    }
}

#pragma mark - 登陆接口
- (void)loginAction {
    self.loginBtn.enabled = NO;
    [self performSelector:@selector(changeButtonStatus) withObject:nil afterDelay:1.0f];

    if ([self canNext]) {
        NSString *phoneStr =[NSString stringWithFormat:@"%@%@",@"", _phoneViewLogin.field.text];
        NSString *pwdStr = _pwdViewLogin.field.text;
        
        pwdStr = [GTMBase64 stringByEncodingData:[[NSString stringWithFormat:@"zst%@013",pwdStr] dataUsingEncoding:NSUTF8StringEncoding]];

        
        NSString * urlString = [NSString stringWithFormat:@"%@%@",BaseUrl,@"/login/passwordLogin"];
        NSDictionary * dic = @{@"loginName":phoneStr,@"password":pwdStr};
        NSLog(@"dic === %@",dic);
        [self showLoadingView];
        [[NetworkRequests sharedInstance] LoginPOST:urlString dict:dic succeed:^(id data) {
            NSLog(@"data === %@",data);
            if ([[data objectForKey:@"msgCode"] integerValue] == 0 ) {
                [NSUserDefaults setObj:phoneStr foKey:@"loginName"];
                [NSUserDefaults setObj:pwdStr foKey:@"password"];
                [[JWTHundel shareHundle] createTimer];
                [self getUserMessage];
                
            }else
            {
                [self hideLoadingView];

                [LTAlertView alertMessage:[DataHundel messageObjetCode:[[data objectForKey:@"msgCode"]integerValue]]];
            }
        } failure:^(NSError *error) {
            [self hideLoadingView];

        }];
    }
}
-(void)changeButtonStatus{
    self.loginBtn.enabled =YES;
    
}
#pragma mark - 获取用户信息
-(void)getUserMessage
{
    
    WS(ws);
    NSString *stringUrl = [NSString stringWithFormat:@"%@%@",BaseUrl,@"/user/getUser"];
    
    [[NetworkRequests sharedInstance] SWDPOST:stringUrl dict:nil succeed:^(id resonseObj, BOOL isSuccess, NSString *message) {
        NSLog(@"res === %@",resonseObj);
        if (isSuccess) {
            
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
            
            NSString * nickName = resonseObj[@"userName"];
            [NSUserDefaults setObj:nickName foKey:kNickName];
            [[NSNotificationCenter defaultCenter] postNotificationName:NFC_LocLogin  object:nil];
            [ws popVC];
            
//            NSArray * array = [resonseObj objectForKey:@"attachments"];
//            NSArray * photoIDArray = [AttachmentsModel mj_objectArrayWithKeyValuesArray:array];
//            for (AttachmentsModel * model in photoIDArray) {
//                if ([model.type isEqualToString:@"ATTA08"]) {
//                    [NSUserDefaults setObj:model.NewID foKey:PICID];
//                }
//            }
//            NSString * infoFillStep = [resonseObj objectForKey:@"infoFillStep"];

//            NSString * mobelNum = [resonseObj objectForKey:@"mobile"];
//            [NSUserDefaults setObj:infoFillStep foKey:INFOSTEP];
//            [NSUserDefaults setObj:mobelNum foKey:kMobile];
//            array = [resonseObj objectForKey:@"mt4Users"];
//            NSMutableArray * userArray  =[UserModel mj_objectArrayWithKeyValuesArray:array];
            
//            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
//
//            self.popView  =[[ChoicePopView alloc]init];
//            self.popView.a  = @"1";
//            self.popView.dataAray = [NSMutableArray arrayWithArray:userArray];
//            [self.popView setCallBackBlock:^(NSString *type, NSString *mt4id) {
//                [NSUserDefaults setObj:mt4id foKey:MT4ID];
//                [NSUserDefaults setObj:type foKey:TYPE];
//                [[NSNotificationCenter defaultCenter] postNotificationName:NFC_LocLogin  object:nil];
//                [ws popVC];
//            }];
//            [self.view addSubview:self.popView];
//            [self.popView showView:YES];
            
            [self hideLoadingView];

        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadingView];

    }];
    
//    [[NetworkRequests sharedInstance] POST:stringUrl dict:nil succeed:^(id data) {
//
//        NSMutableDictionary * bigDic =[NSMutableDictionary dictionary];
//        if ([[data objectForKey:@"code"]integerValue] == 0 ) {
//            bigDic =[data objectForKey:@"dataObject"];
//            NSArray * array = [bigDic objectForKey:@"attachments"];
//            NSArray * photoIDArray = [AttachmentsModel mj_objectArrayWithKeyValuesArray:array];
//            for (AttachmentsModel * model in photoIDArray) {
//                if ([model.type isEqualToString:@"ATTA08"]) {
//                    [NSUserDefaults setObj:model.NewID foKey:PICID];
//                }
//            }
//            NSString * infoFillStep = [bigDic objectForKey:@"infoFillStep"];
//            NSString * nickName = [bigDic objectForKey:@"fullname"];
//            NSString * mobelNum = [bigDic objectForKey:@"mobile"];
//            [NSUserDefaults setObj:infoFillStep foKey:INFOSTEP];
//            [NSUserDefaults setObj:nickName foKey:kNickName];
//            [NSUserDefaults setObj:mobelNum foKey:kMobile];
//            array = [bigDic objectForKey:@"mt4Users"];
//            NSMutableArray * userArray  =[UserModel mj_objectArrayWithKeyValuesArray:array];
//            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
//            self.popView  =[[ChoicePopView alloc]init];
//            self.popView.a  = @"1";
//            self.popView.dataAray = [NSMutableArray arrayWithArray:userArray];
//            [self.popView setCallBackBlock:^(NSString *type, NSString *mt4id) {
//                [NSUserDefaults setObj:mt4id foKey:MT4ID];
//                [NSUserDefaults setObj:type foKey:TYPE];
//                [[NSNotificationCenter defaultCenter] postNotificationName:NFC_LocLogin  object:nil];
//                [ws popVC];
//            }];
//            [self.view addSubview:self.popView];
//            [self.popView showView:YES];
//        }
//
//
//    } failure:^(NSError *error) {
//
//
//    }];

}
//忘记密码
- (void)forgetPwdAction {
    ForgetPwdCtrl *ctrl = [[ForgetPwdCtrl alloc] init];
    [self pushVC:ctrl];
}

#pragma mark 注册

- (void)createRegView {
    self.registerView = [[UIView alloc] init];
    _registerView.frame = CGRectMake(0, 0, self.w_, _contentView.h_);
    _registerView.backgroundColor = LTBgColor;
    [_contentView addSubview:_registerView];
    
    
    NSString *phone = [LTUtils phoneNumMid4Star];
    if (!phone) {
        phone = @"请输入手机号码";
    }
    self.phoneView = [[FieldView alloc] initWithFrame:CGRectMake(kLeftMar, kCellTemp, kCellW, kCellH)];
    [_phoneView showEyeImge:NO];
    _phoneView.field.keyboardType = UIKeyboardTypeNumberPad;
    [_phoneView addToolsBar];
    [_phoneView configPlaceholder:phone];
    [_registerView addSubview:_phoneView];

    
    self.codeView = [[CodeFieldView alloc] initWithFrame:CGRectMake(kLeftMar, _phoneView.yh_ + kCellTemp, kCellW, kCellH)];
    _codeView.delegate = self;
    _codeView.codeFieldType = CodeFieldType_Reg;
    _codeView.codeField.keyboardType = UIKeyboardTypeNumberPad;
    [_codeView addToolsBar];
    [_registerView addSubview:_codeView];
    
    self.nameView =[[NameField alloc]initWithFrame:CGRectMake(kLeftMar, _codeView.yh_ + kCellTemp, kCellW, kCellH)];
    [_nameView configPlaceholder:@"请输入真实姓名"];
    self.nameView.field.keyboardType = UIKeyboardTypeWebSearch;
    [_registerView addSubview:self.nameView];
    
    self.pwdView = [[FieldView alloc] initWithFrame:CGRectMake(kLeftMar, _nameView.yh_+ kCellTemp, kCellW, kCellH)];
    [_pwdView configPlaceholder:@"设置6-12位数字、字母"];
    [_registerView addSubview:_pwdView];
    
    self.regBtn = [self blueBtn:@"注册" y:_pwdView.yh_ + kCellTemp action:@selector(regAction)];
    [_registerView addSubview:_regBtn];
    
    NSString *protocolStr0 = @"点击注册表示您已阅读并同意";
    NSString *protocolStr1 = @"《用户协议》";
    NSString *protocolStr = [NSString stringWithFormat:@"%@%@",protocolStr0,protocolStr1];
    NSMutableAttributedString *ABStr = [[NSMutableAttributedString alloc] initWithString:protocolStr];
    [ABStr addAttribute:NSForegroundColorAttributeName value:LTSubTitleColor range:NSMakeRange(0, protocolStr0.length)];
    [ABStr addAttribute:NSForegroundColorAttributeName value:kLineBlueColor range:NSMakeRange(protocolStr0.length, protocolStr1.length)];
    
    self.protocolBtn = [UIButton btnWithTarget:self action:@selector(protocolAction) frame:CGRectMake(kLeftMar, _regBtn.yh_ + kCellTemp, kCellW, 20)];
    _protocolBtn.titleLabel.font = fontSiz(13);
    [_protocolBtn setAttributedTitle:ABStr forState:UIControlStateNormal];
    [_registerView addSubview:_protocolBtn];
}

- (void)configRegPhone {
    _phoneView.saveFieldKey = kLastMobile;
    NSString *str = [UserDefaults objectForKey:kLastMobile];
    if (str) {
        _phoneView.field.text = str;
    }
}

#pragma mark - 注册
- (void)regAction {
    if ([self canNext]) {
        NSString *phoneStr = _phoneView.field.text;
        NSString *pwdStr = _pwdView.field.text;
        NSString *codeStr = _codeView.codeField.text;
        NSString * stringUrl = [NSString stringWithFormat:@"%@%@",BaseUrl,@"/login/register"];

        pwdStr = [GTMBase64 stringByEncodingData:[[NSString stringWithFormat:@"zst%@013",pwdStr] dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSDictionary * dic = @{@"id":@(self.codeId),@"loginName":phoneStr,@"verificationCode":codeStr,@"password":pwdStr,@"userName":_nameView.field.text};
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

//查看用户协议
- (void)protocolAction {
    NSString *url = URL_UserAgreement;
    [self pushWeb:url title:@"用户协议"];
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
    DLog(@"data ==");

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

#pragma mark - utils

- (UIButton *)tabBtn:(NSString *)title idx:(NSInteger)idx {
    CGFloat btnW = self.w_*0.5;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(idx*btnW, 0, btnW, kTabH);
    btn.tag = kTabBtnTag + idx;
    btn.titleLabel.font = fontSiz(17);
    [btn setBackgroundColor:kTabBGColor];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:LTWhiteColor forState:UIControlStateSelected];
    [btn setTitleColor:LTWhiteColor forState:UIControlStateHighlighted];
    [btn setTitleColor:LTSubTitleColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(selTabBtn:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
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

- (BOOL)canNext {
    if (_isReg) {
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
    } else {
        NSString *phoneStr = _phoneViewLogin.field.text;
        NSString *pwdStr = _pwdViewLogin.field.text;
        if (emptyStr(phoneStr)) {
            [self.view showTip:@"请输入手机号码"];
            return NO;
        }
        if (![pwdStr is_password]) {
            [self.view showTip:@"请输入6-12位数字、字母"];
            return NO;
        }
        return YES;
    }
}

@end
