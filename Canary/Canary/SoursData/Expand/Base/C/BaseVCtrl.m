//
//  BaseVCtrl.m
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BaseVCtrl.h"
#import "Reachability.h"
#import "InputPwdVCtrl.h"

NSString * const ThemeDidChangeNotification = @"bk.Theme.change";

@interface BaseVCtrl ()

@property (nonatomic,strong) UIView *empteView;
/** NavBar上 右边按钮 */
@property (nonatomic,strong) UIButton *navRightBtn;

@end

@implementation BaseVCtrl
-(instancetype)init{
    self=[super init];
    if (self) {
        [self initAction];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = LTBgColor;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.view.backgroundColor = LTBgRGB;
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];//防黑屏
    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hideLoadingView];
    
    [MobClick endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}

#pragma mark - 注册消息中心事件

- (void)regitserAsObserver {
    //根据主题选择颜色色调
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(themeChanged) name:ThemeDidChangeNotification object:nil];
    
    // 联网通知
    [center addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
}

- (void)unregisterAsObserver {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

- (void)themeChanged {
    [_header changeViewBackgroundColor];
    _stateView.backgroundColor = NavBarBgCoror;
    _header.backgroundColor = NavBarBgCoror;
}

- (void)reachabilityChanged:(NSNotification *)notification {
    //    NSLog(@"网络连接状态通知");
}

#pragma mark 初始化导航

- (void)navTitle:(NSString *)title {
    [self navTitle:title backType:BackType_Non];
}

- (void)navPopBackTitle:(NSString *)title {
    [self navTitle:title backType:BackType_PopVC];
}

- (void)navTitle:(NSString *)title backType:(BackType)backType {
    
    self.backType = backType;
    BOOL back = (backType > 0);
    
    // 状态栏
    self.stateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW_Lit, StatusBarH_Lit)];
    [self.view addSubview:self.stateView];
    self.stateView.backgroundColor = NavBarBgCoror;
    
    self.header = [[NavBarView alloc] initWithFrame:CGRectMake(0, self.stateView.h_, ScreenW_Lit, NavBarH_Lit) title:title isBack:back target:self];
    [self.view addSubview:self.header];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    
    // 配置
    [self themeChanged];
}

//backType返回按钮 & 中间文字 & 右按钮文字
- (void)navTitle:(NSString *)title backType:(BackType)backType rightTitle:(NSString *)rightTitle {
    [self navTitle:title backType:backType];
    
    if (rightTitle) {
        if (!self.navRightBtn) {
            CGFloat sizeFont = 15.f;
            UIFont *font = [UIFont systemFontOfSize:sizeFont];
            UIButton *rightBt = [UIButton buttonWithType:UIButtonTypeCustom];
            [rightBt setTitle:rightTitle forState:UIControlStateNormal];
            rightBt.titleLabel.font = font;
            [rightBt setTitleColor:NavBarSubCoror forState:UIControlStateNormal];
            [rightBt addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
            
            CGSize size = [rightTitle boundingW:sizeFont font:font];
            
            self.navRightBtn = rightBt;
            [self.header addSubview:self.navRightBtn];
            
            [self.navRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@(-10));
                make.width.equalTo(@(size.width +10));
                make.height.equalTo(@25);
                make.centerY.equalTo(@0);
            }];
        }
    }
}

//backType返回按钮 & 中间文字 & 右按钮图片
- (void)navTitle:(NSString *)title backType:(BackType)backType rightImgName:(NSString *)rightImgName {
    [self navTitle:title backType:backType rightImgName:rightImgName rightSelImgName:nil];
}

//backType返回按钮 & 中间文字 & 右按钮图片
- (void)navTitle:(NSString *)title backType:(BackType)backType rightImgName:(NSString *)rightImgName  rightSelImgName:(NSString *)rightSelImgName {
    
     [self navTitle:title backType:backType];
    
    if (!self.navRightBtn) {
        UIButton *rightBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.header addSubview:rightBt];
        
        
        UIImage *img = [UIImage imageNamed:rightImgName];
        if (kChangeImageColor) {
            img = [img changeColor:NavBarSubCoror];
        }
        [rightBt setImage:img forState:UIControlStateNormal];
        
        if (rightSelImgName) {
            UIImage *img = [UIImage imageNamed:rightSelImgName];
            if (kChangeImageColor) {
                img = [img changeColor:NavBarSubCoror];
            }
            [rightBt setImage:img forState:UIControlStateSelected];
        }
        
        rightBt.frame = CGRectMake(self.view.w_ - 44, 0, 44, 44);
        [rightBt addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        self.navRightBtn = rightBt;
        [self.header addSubview:self.navRightBtn];
    }
}

- (void)showRightBtn:(BOOL)bl {
    self.navRightBtn.hidden = !bl;
}
- (void)rightItemSelect:(BOOL)sel {
    self.navRightBtn.selected = sel;
}
- (void)rightItemFrame:(CGRect)frame {
    self.navRightBtn.frame = frame;
}

- (void)addLeftImageBtn:(NSString *)imageName {
    UIImage *back_imge = [UIImage imageNamed:imageName];
    if (kChangeImageColor) {
        back_imge = [back_imge changeColor:NavBarSubCoror];
    }
    CGFloat h = self.header.h_;
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, h, h)];
    leftBtn.backgroundColor=[UIColor clearColor];
    [leftBtn setImage:back_imge forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [self.header addSubview:leftBtn];
    [leftBtn setTag:100];
}



#pragma mark - action
-(void)initAction{
    
}
- (void)leftAction {
    switch (self.backType) {
        case BackType_PopVC:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case BackType_Dismiss:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case BackType_PopToRoot:
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        default:
            [self.navigationController popViewControllerAnimated:YES];
            break;
    }
}

- (void)rightAction {}



#pragma mark - 显示空数据数据view

- (void)showEmptySubView:(UIView *)view {
    [self showEmptySubView:view title:nil imageName:nil];
}
- (void)showEmptySubView:(UIView *)view title:(NSString *)title {
    [self showEmptySubView:view title:title imageName:nil];
}


- (void)hideEmptyView {
    _empteView.hidden=YES;
    [_empteView removeAllSubView];
    [_empteView removeFromSuperview];
}
- (void)showEmptyView {
    [self showEmptySubView:nil title:nil imageName:nil];
}
- (void)showEmptyView:(NSString *)title {
    [self showEmptySubView:nil title:title imageName:nil];
}


- (void)showEmptySubView:(UIView *)view title:(NSString *)title imageName:(NSString *)imageName {
    if (!title) {
        title = @"暂无数据";
    }
    if (!imageName) {
        imageName = @"emptyIcon";
    }
    
    [self createEmptySubView:view title:title imageName:imageName];
    
    [self.view bringSubviewToFront:_empteView];
    
    
}

static CGFloat ivTopMar = -60;
- (void)createEmptySubView:(UIView *)view title:(NSString *)title imageName:(NSString *)imageName {
    if (_empteView) {
        [self hideEmptyView];
    }
    
    CGRect rect = CGRectZero;
    if (!view) {
        rect = CGRectMake(0, NavBarTop_Lit, self.w_, self.h_-NavAndTabBarH_Lit);
    } else {
        rect = CGRectMake(0, view.y_, view.w_, view.h_);
    }
    
    self.empteView = [[UIView alloc] init];
    _empteView.frame = rect;
    _empteView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:_empteView];
    
    UIImage *img = [UIImage imageNamed:imageName];
    CGFloat iwh = _empteView.w_/3.0;
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = CGRectMake((_empteView.w_ - iwh)/2.0, (_empteView.h_ - iwh)/2.0+ivTopMar, iwh, iwh);
    imgView.image = img;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.userInteractionEnabled = YES;
    [imgView addSingeTap:@selector(loadData) target:self];
    [_empteView addSubview:imgView];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(_empteView.w_/6, imgView.yh_, _empteView.w_*4/6, 50);
    lab.font = [UIFont fontOfSize:15.f];
    lab.textColor = LTSubTitleColor;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = title;
    [_empteView addSubview:lab];
    
}



#pragma mark - 验证用户是否实名认证
/** YES:已实名认证  */
- (BOOL)checkRealNameCert {
    BaseVCtrl *vc = [self findBaseVC];
    
    //是否登录八元
//    BOOL locHasLogin = [self checkLocHasLogin:@"需要登录后才能使用!"];
//    if (!locHasLogin) {
//        return NO;
//    }
//    
    //IDCard dist status 1：认证失败，2：资料未认证，3：认证中，4：认证成功
    NSInteger state = UD_CardDistStatus;
    
    if (state == 0) {
        WS(ws);
        [self showLoadingView];
        [RequestCenter reqEXAuthStatus:^(LTResponse *res) {
            [ws hideLoadingView];
            if (res.success) {
                NSInteger state = [res.resDict integerFoKey:@"status"];
                if (state != 0) {
                    UD_SetCardDistStatus(state);
                }
                [ws checkRealNameCert];
            } else {
                [ws.view showTip:res.message];
            }
        }];
        return NO;
    }
    else if (state == 1) {
        [LTAlertView alertTitle:@"认证失败" message:@"" sureTitle:@"查看详情" sureAction:^{
            [vc pushCertResultVC];
        }  cancelTitle:@"取消"];
        return NO;
    }
    else if (state == 2) {
        [LTAlertView alertTitle:@"实名认证后才能交易" message:@"" sureTitle:@"去认证" sureAction:^{
            [vc pushCertVC];
        }  cancelTitle:@"取消"];
        return NO;
    }
    else if (state == 3) {
        [LTAlertView alertTitle:@"认证中" message:@"" sureTitle:@"查看详情" sureAction:^{
            [vc pushCertResultVC];
        }  cancelTitle:@"取消"];
        return NO;
    }
    else if (state == 4) {
        return YES;
    } else {
        return NO;
    }
    
}

#pragma mark - token验证
/** YES：token过期   */
- (BOOL)checkTimeOut {
    return [self checkTimeOut:nil failure:nil];
}

- (BOOL)checkTimeOut:(void (^)())success failure:(void (^)())failure {
    BaseVCtrl *vc = [self findBaseVC];
    BOOL timeout = [self checkTimeOut:^{
        InputPwdVCtrl *ctrl = [[InputPwdVCtrl alloc] init];
        [vc pushVC:ctrl];
    } alertCancel:nil success:success failure:failure];
    return timeout;
}

- (BOOL)checkTimeOut:(void (^)())alertSure alertCancel:(void (^)())alertCancel success:(void (^)())success failure:(void (^)())failure {
    BOOL state = [self checkRealNameCert];
    if (!state) {
        return YES;
    }
    
    BOOL tokenTimeout = [LTUser tokenTimeOut];
    if (tokenTimeout) {
        [self alertInputPWD:alertSure alertCancel:alertCancel success:success failure:failure];
        return YES;
    } else {
        return NO;
    }
}


#pragma mark - 处理token_timeout

- (void)handleTokenTimeout:(LTResponse *)res {
    [self handleTokenTimeout:res success:nil failure:nil];
}

- (void)handleTokenTimeout:(LTResponse *)res success:(void (^)())success failure:(void (^)())failure {
    BaseVCtrl *vc = [self findBaseVC];
    [self handleTokenTimeout:res alertSure:^{
        InputPwdVCtrl *ctrl = [[InputPwdVCtrl alloc] init];
        [vc pushVC:ctrl];
    } alertCancel:failure success:success failure:failure];
}

- (void)handleTokenTimeout:(LTResponse *)res alertSure:(void (^)())alertSure alertCancel:(void (^)())alertCancel success:(void (^)())success failure:(void (^)())failure {
    NSString *code = res.code;
    NSString *msg = res.message;
    if ([code isEqualToString:kErrorCode_00007] ||
        [code isEqualToString:kErrorCode_30005]) {
        [self alertInputPWD:alertSure alertCancel:alertCancel success:success failure:failure];
        return;
    } else {
        if ([code isEqualToString:kErrorCode_00013]) {
            [self alertOtherInputPWD:alertSure alertCancel:alertCancel success:success failure:failure];
        }else{
            [self.view showTip:msg];
        }
    }
}

#pragma mark - 输入密码弹框
//重新输入密码
- (void)alertInputPWD {
    [self alertInputPWD:nil failure:nil];
}
//重新输入密码
- (void)alertInputPWD:(void (^)())success failure:(void (^)())failure {
    BaseVCtrl *vc = [self findBaseVC];
    [self alertInputPWD:^{
        InputPwdVCtrl *ctrl = [[InputPwdVCtrl alloc] init];
        [vc pushVC:ctrl];
    } alertCancel:nil success:success failure:failure];
}

//重新输入密码
- (void)alertInputPWD:(void (^)())alertSure alertCancel:(void (^)())alertCancel success:(void (^)())success failure:(void (^)())failure {
    NSString *title = kStr_ReLoginTitle;
    NSString *message = kStr_AutoLogout;
    NSString *sureTitle = kStr_ReLoginSureTitle;
    NSString *cancelTitle = @"取消";
    [LTAlertView alertTitle:title message:message sureTitle:sureTitle sureAction:^{
        alertSure ? alertSure() : nil;
    } cancelTitle:cancelTitle cancelAction:^{
        alertCancel ? alertCancel() : nil;
    }];
}
//多端登录
- (void)alertOtherInputPWD:(void (^)())alertSure alertCancel:(void (^)())alertCancel success:(void (^)())success failure:(void (^)())failure {
    NSString *title = kStr_OtherLoginTitle;
    NSString *message = kStr_OtherAutoLogout;
    NSString *sureTitle = kStr_OtherLoginSureTitle;
    NSString *cancelTitle = @"取消";
    [LTAlertView alertTitle:title message:message sureTitle:sureTitle sureAction:^{
        alertSure ? alertSure() : nil;
    } cancelTitle:cancelTitle cancelAction:^{
        alertCancel ? alertCancel() : nil;
    }];
}
#pragma mark - findNav
- (BaseVCtrl *)findBaseVC {
    if (!self.navigationController) {
        BaseVCtrl *ctrl = (BaseVCtrl *)[self.view findViewController];
        return ctrl;
    } else {
        return self;
    }
}


#pragma mark - 关闭键盘
- (void)shutKeyboard {
    ShutAllKeyboard;
}

@end
