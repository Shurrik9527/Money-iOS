//
//  MeHeaderView.m
//  ixit
//
//  Created by litong on 2017/2/14.
//  Copyright © 2017年 litong. All rights reserved.
//

#define INFOSTEP @"infoFillStep"
#import "MeHeaderView.h"
#import "LTArcProgressView.h"
#import "MeVipView.h"
#import "LTWebCache.h"
#import "UIView+LTAnimation.h"
#import "UIImage+LT.h"
#import "WebView.h"

@interface MeHeaderView ()
{
    BOOL newTheme;
}
//未登录
@property (nonatomic,strong) UIView *baseViewNor;
@property (nonatomic,strong) UIImageView *headIVNor;//没登录，头像
@property (nonatomic,strong) UILabel *nickNameLabNor;//没登录，昵称

//登录
@property (nonatomic,strong) UIImageView *bgIV;//背景图片
@property (nonatomic,strong) UIView *baseView;//背景图片蒙版

@property (nonatomic,strong) UIView *userView;
//@property (nonatomic,strong) LTArcProgressView *progressView;//圆形进度条
@property (nonatomic,strong) UIView *progressView;
@property (nonatomic,strong) UIImageView *headIV;//头像
@property (nonatomic,strong) UILabel *nickNameLab;//昵称
@property (nonatomic,strong) UIImageView *authStateIV;//图标
@property (nonatomic,strong) UILabel *authStateLab;//认证状态
@property (nonatomic,strong) UIButton * infoBt;//完善信息

@end

@implementation MeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        newTheme = useNewYearTheme;
        self.backgroundColor = NavBarBgCoror;
        [self createView];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NFC_ChangeNickNameSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NFC_ChangeHeadImgSuccess object:nil];
}

- (void)createView {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNickName) name:NFC_ChangeNickNameSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHeadImg) name:NFC_ChangeHeadImgSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:NFC_LocLogin object:nil];

    
    //未登录
    self.baseViewNor = [[UIView alloc] init];
    _baseViewNor.frame = CGRectMake(0, 0, self.w_, LTAutoW(kMeHeaderViewH1));
    _baseViewNor.backgroundColor = NavBarBgCoror;
    [self addSubview:_baseViewNor];
    [_baseViewNor addSingeTap:@selector(loginAction) target:self];
    
    CGFloat headh = LTAutoW(60);
    self.headIVNor = [[UIImageView alloc] init];
    _headIVNor.frame = CGRectMake((self.w_ - headh)/2, LTAutoW(58), headh, headh);
    _headIVNor.image = [UIImage imageNamed:@"Head80"];
    [_headIVNor circleViwe];
    [_baseViewNor addSubview:_headIVNor];

    
    self.nickNameLabNor = [self lab:CGRectMake(0, _headIVNor.yh_ + LTAutoW(20), self.w_, LTAutoW(28))  textColor:LTWhiteColor];
    _nickNameLabNor.font = autoBoldFontSiz(20);
    _nickNameLabNor.textAlignment = NSTextAlignmentCenter;
    [_baseViewNor addSubview:_nickNameLabNor];
    NSString *aTip = @"登录 / 注册";
    NSRange range = NSMakeRange(2, 2);
    NSAttributedString *aTipABStr = [aTip ABStrColor:LTSubTitleColor range:range];
    _nickNameLabNor.attributedText = aTipABStr;
    

    //登录
    self.bgIV = [[UIImageView alloc] init];
    _bgIV.frame = CGRectMake(0, 0, self.w_, LTAutoW(kMeHeaderViewH));
//    _bgIV.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_bgIV];

    self.baseView = [[UIView alloc] init];
    _baseView.frame = CGRectMake(0, 0, self.w_, LTAutoW(kMeHeaderViewH));
    _baseView.backgroundColor = kLTArcProgressBgColor;
    [self addSubview:_baseView];
    
    
    //用户头像昵称
    self.userView = [[UIView alloc] init];
    _userView.frame = CGRectMake(0, LTAutoW(43), self.w_, LTAutoW(90));
    [_baseView addSubview:_userView];
    
    CGFloat pvh = LTAutoW(80);
    self.progressView = [[UIView alloc] initWithFrame:CGRectMake(LTAutoW(kLeftMar), LTAutoW(5), pvh, pvh)];
    [_userView addSubview:_progressView];
    [_progressView addSingeTap:@selector(accountManager) target:self];
    
    
    CGFloat headH = LTAutoW(60);
    CGFloat headX = LTAutoW(10);
    self.headIV = [[UIImageView alloc] init];
    _headIV.frame = CGRectMake(headX, headX, headH, headH);
    _headIV.image = [UIImage imageNamed:@"Head80"];
    [_headIV circleViwe];
    [_progressView addSubview:_headIV];
    

    
    CGFloat nickX = _progressView.xw_ + LTAutoW(kLeftMar);
    self.nickNameLab = [self lab:CGRectMake(nickX, LTAutoW(kLeftMar), self.w_ - nickX - LTAutoW(kLeftMar), LTAutoW(28))  textColor:LTWhiteColor];
    _nickNameLab.font = autoBoldFontSiz(20);
    [_userView addSubview:_nickNameLab];
    
    if (![[NSUserDefaults objFoKey:INFOSTEP] isEqualToString:@"3"]) {
        self.infoBt = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.infoBt.frame = CGRectMake(_progressView.xw_ + LTAutoW(kLeftMar),self.nickNameLab.yh_ +5, 100, 30);
        [self.infoBt setTitle:@"请您完善信息" forState:(UIControlStateNormal)];
        self.infoBt.titleLabel.font =[UIFont boldSystemFontOfSize:12];
        self.infoBt.layer.cornerRadius = 15;
        
        [self.infoBt setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        self.infoBt.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
        [_userView addSubview:self.infoBt];
    }
    [self refViewWithLogin];
}
-(void)userLogin
{
    _nickNameLab.text = [NSUserDefaults objFoKey:kNickName];

}
#pragma mark - utils

- (UILabel *)lab:(CGRect)r textColor:(UIColor *)textColor {
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = r;
    lab.textColor = textColor;
    return lab;
}

#pragma mark - action

- (void)loginAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:NFC_PushLoginVC object:nil];
}

- (void)accountManager {
    [[NSNotificationCenter defaultCenter] postNotificationName:NFC_PushAccountManager object:nil];
}

- (void)vipViewAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:NFC_PushIntegralVC object:nil];
}


#pragma mark - 外部

#define animationTime 0.3
- (void)animationBegin {
    [_headIV animationRotate:M_PI_2 duration:animationTime fromRight:YES repeatCount:YES autoreverse:YES];
    
}

- (void)refViewWithLogin {
    BOOL hasLogin = [LTUser hasLogin];
    
    if (hasLogin) {
        [self setSH:LTAutoW(kMeHeaderViewH)];
        [self updateNickName];
        [self updateHeadImg];
        [self updateState];
    } else {
        [self setSH:LTAutoW(kMeHeaderViewH1)];
        self.bgIV.image = nil;
    }
    
    self.baseViewNor.hidden = hasLogin;
    
    self.bgIV.hidden = !hasLogin;
    self.baseView.hidden = !hasLogin;
    
}





- (void)updateNickName {
    _nickNameLab.text = UD_NickName;
}

- (void)updateHeadImg {
    WS(ws);
    [_headIV sd_setImageWithURL:[UD_Avatar toURL] placeholderImage:[UIImage imageNamed:@"Head80"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            UIImage *img = [image cutedCenterSquare];
            ws.headIV.image = img;
            
            UIImage *tmp = [img copy];
            UIImage *littleImg = [tmp toJPEGImage:0.3];
            UIImage *bgimg = [littleImg blurWithRadius:5];
            ws.bgIV.image = bgimg;
        } else {
            self.bgIV.image = nil;
        }
    }];
}
-(void)infoAction
{
    WebView * webView =[[WebView alloc]init];
    webView.state = 2;
    [[self viewController] presentVC:webView];
}
- (void)updateState {
    NSInteger state = UD_CardDistStatus;
    NSString *authStr = @"";
    NSString *authImgName = @"state_notAuth";
    if (state == 1) {
        authStr = @"认证失败";
    }
    else if (state == 2) {
        authStr = @"资料未认证";
    }
    else if (state == 3) {
        authStr = @"认证中";
    }
    else if (state == 4) {
        authStr = @"已实名认证";
        authImgName = @"state_authed";
    }
    _authStateIV.image = [UIImage imageNamed:authImgName];
    _authStateLab.text = authStr;

}
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
@end
