//
//  AddRemind.m
//  ixit
//
//  Created by litong on 2017/2/17.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "AddRemind.h"

static CGFloat kHeadH = 48;
static CGFloat kHeadBtnW = 62;

static CGFloat kMPViewH = 32;
static CGFloat kMPViewH1 = 60;

static CGFloat kWaveViewH = 82;
static CGFloat kWaveIconIVWH = 8;
static CGFloat kSelViewH = 60;
static CGFloat kFootLabH = 40;
static CGFloat kFootBtnH = 36;

static NSInteger btnTag = 2000;
static NSInteger selStateBtnTag = 3000;

@interface AddRemind ()<UITextFieldDelegate>
{
    CGFloat tempH;
    CGFloat contentViewH;
    NSArray *waves;
    NSInteger wavesCount;
    UIColor *borderColor;
    
    CGFloat btnx;
    CGFloat btnw;
    CGFloat btnh;
}


@property (nonatomic,strong) NSString *excode;
@property (nonatomic,strong) NSString *code;
@property (nonatomic,copy) NSString *pName;
@property (nonatomic,strong) PushRemindModel *mo;

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,assign) CGRect contentViewUpRect;
@property (nonatomic,assign) CGRect contentViewDownRect;

@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UILabel *titLab;
@property (nonatomic,strong) UIView *mpView;
@property (nonatomic,strong) UITextField *mpField;
@property (nonatomic,strong) UILabel *mpTipLab;
@property (nonatomic,assign) BOOL canShowMpError;

@property(strong,nonatomic)UIButton * buyBtn;//买价
@property(strong,nonatomic)UIButton * sellBtn;//买价
@property(copy,nonatomic)NSString * buyType;


@property (nonatomic,strong) UIView *waveView;
@property (nonatomic,strong) UIImageView *waveIconIV;
@property (nonatomic,strong) UILabel *waveTipLab;
@property (nonatomic,assign) NSInteger curIdx;

@property (nonatomic,strong) UIView *selView;
@property (nonatomic,strong) UIButton *todayBtn;
@property (nonatomic,strong) UIButton *weekBtn;

@property (nonatomic,assign) NSInteger cycleType;

@property (nonatomic,strong) UILabel *footLab;
@property (nonatomic,strong) UIButton *footBtn;


@end

@implementation AddRemind

- (instancetype)initWithTempH:(CGFloat)h excode:(NSString *)excode code:(NSString *)code pName:(NSString *)pName {
    self = [super initWithFrame:CGRectMake(0, 0, ScreenW_Lit, ScreenH_Lit)];
    if (self) {
        tempH = h;
        contentViewH = self.h_ - tempH;
        self.excode = excode;
        self.code = code;
        self.pName = pName;
        self.backgroundColor = LTClearColor;
        waves = [NSArray arrayWithObjects:@"5", @"10", @"15", @"20", nil];
        wavesCount = waves.count;
        borderColor = LTColorHexA(0x848999, 0.4);
        _canShowMpError = NO;
        [self createView];
    }
    return self;
}

- (void)changeEditing:(PushRemindModel *)mo {
    _mo = mo;
    
    if (_mo) {
        _titLab.text = @"编辑提醒";
        _mpField.text = _mo.customizedProfit;
        NSString *floatDownProfit = _mo.floatDownProfit;
        NSInteger i = 0;
        for (NSString *str in waves) {
            if ([str isEqualToString:floatDownProfit]) {
                self.curIdx = i;
                break;
            }
            i ++;
        }
        self.cycleType = _mo.cycleType;
        _footBtn.hidden = NO;
    } else {
        _titLab.text = @"添加提醒";
        _mpField.text = nil;
        self.curIdx = 0;
        self.cycleType = 1;
        _footBtn.hidden = YES;
    }
}

- (void)setRemindConfigModel:(PushRemindConfigModel *)remindConfigModel {
    _remindConfigModel = remindConfigModel;
    
    
    for (UIView *view in _waveView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    waves = [NSArray arrayWithArray:_remindConfigModel.pointList_fmt];
    
    NSInteger i = 0;
    for (NSString *str in waves) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnx + i*(btnw+LTAutoW(8)), 0, btnw, btnh);
        [btn layerRadius:3 borderColor:borderColor borderWidth:0.5];
        [btn setTitle:[NSString stringWithFormat:@"%@",str] forState:UIControlStateNormal];
        btn.titleLabel.font = autoFontSiz(15);
        [btn setTitleColor:LTTitleColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickWaveBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = btnTag + i;
        [_waveView addSubview:btn];
        
        i ++;
    }
}

#pragma mark - action

- (void)shutKeyBoard {
    [_mpField resignFirstResponder];
}

- (void)cancleAction {
    [_mpField resignFirstResponder];
    [self showView:NO];
    
    _addRemindShutBlock ? _addRemindShutBlock() : nil;
}

- (void)clickRightBtn {
    [_mpField resignFirstResponder];
    _canShowMpError = YES;
    [self changeWaveText];
    if (_mo) {
        [self editAciton];
    } else {
        [self addAciton];
    }
}

- (void)addAciton {
    NSString *mp = _mpField.text;
    if (emptyStr(mp)) {
        [self showMPError:YES];
        return;
    }
    
    CGFloat floatPoint = [waves[_curIdx] floatValue];
    CGFloat customizedProfit = [mp floatValue];
    
    //    customizedProfit	float		定制点位
    //    floatPoint	float		浮动点位
    //    cycleType	Int		过期类型（1，一天，2 一周）
    NSDictionary *dict = @{
                               @"excode":self.excode,
                               @"code":self.code,
                               @"customizedProfit":@(customizedProfit),
                               @"floatPoint":@(floatPoint),
                               @"cycleType":@(_cycleType),
                               @"buyType":_buyType,
                               @"userId":UD_UserId,
                           };
    
    WS(ws);
    [self showLoadingView];
    [RequestCenter reqReminderAddWithParameter:dict finsh:^(LTResponse *res) {
        [ws hideLoadingView];
        if (res.success) {
            UMengEvent(UM_MD_SetQuotationRemind);
            UMengEventWithParameter(UM_MD_SetQuotationRemind, @"设置行情提醒", self.pName);
            [ws changeSuccess];
        } else {
            
            [ws handerError:res];
        }
    }];
}

- (void)handerError:(LTResponse *)res {
    if ([res.code isEqualToString:@"260009"]) {
        _mpTipLab.text = res.message;
        [self showMPError:YES];
    } else {
        [self showTip:res.message];
    }
}



- (void)editAciton {
    
    NSString *mp = _mpField.text;
    if (emptyStr(mp)) {
        [self showMPError:YES];
        return;
    }
    
    CGFloat floatPoint = [waves[_curIdx] floatValue];
    CGFloat customizedProfit = [mp floatValue];
    
    /** 修改行情提醒
     userId	true	普通参数	Long		用户ID
     excode	true	普通参数	String		交易所编码
     code	true	普通参数	String		产品编码
     customizedProfit	true	普通参数	float		定制点位
     floatPoint	true	普通参数	float		浮动点位
     cycleType	true	普通参数	Int		过期类型（1，一天，2 一周）
     id	true	普通参数	Long		编号
     */
    NSDictionary *dict = @{
                               @"excode":self.excode,
                               @"code":self.code,
                               @"customizedProfit":@(customizedProfit),
                               @"floatPoint":@(floatPoint),
                               @"cycleType":@(_cycleType),
                               @"userId":UD_UserId,
                               @"buyType":_buyType,
                               @"pid":_mo.pid,
                           };
    
    WS(ws);
    [self showLoadingView];
    [RequestCenter reqReminderUpdateWithParameter:dict finsh:^(LTResponse *res) {
        [ws hideLoadingView];
        if (res.success) {
            [ws changeSuccess];
        } else {
            [ws handerError:res];
        }
    }];
}

- (void)delectRemind {
    [self showLoadingView];
    WS(ws);
    [RequestCenter reqReminderDeleteWithId:_mo.pid finsh:^(LTResponse *res) {
        [ws hideLoadingView];
        if (res.success) {
            [ws changeSuccess];
        } else {
            [ws showTip:res.message];
        }
    }];
}


- (void)changeSuccess {
    [self showView:NO];
    
    _reqRemindListBlock ? _reqRemindListBlock() : nil;
}

- (void)clickWaveBtn:(UIButton *)sender {
    self.curIdx = sender.tag - btnTag;
}

- (void)clickSelStateBtn:(UIButton *)sender {
    NSInteger num = sender.tag - selStateBtnTag;
    self.cycleType = num;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    [self changeWaveText];
//}

- (void)textFieldDidChange:(UITextField *)textField {
    
    NSString *str = textField.text;
    
    if ([str contains:@"."]) {
        NSArray *arr = [str splitWithStr:@"."];
        if (arr.count >= 2) {
            NSString *str0 = arr[0];
            NSString *str1 = arr[1];
            if (arr.count >= 3) {
                [textField animationShakeHorizontallyShort];
                NSString *res = [NSString stringWithFormat:@"%@.%@",str0,str1];
                textField.text = res;
            }
            
            if (str1.length > 5) {
                [textField animationShakeHorizontallyShort];
                str1 = [str1 substringToIndex:5];
                NSString *res = [NSString stringWithFormat:@"%@.%@",str0,str1];
                textField.text = res;
            }
        }
    }

}


#pragma mark - utils

- (UIButton *)btnX:(CGFloat)x sel:(SEL)sel {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(x, 0,  LTAutoW(kHeadBtnW), LTAutoW(kHeadH));
    btn.titleLabel.font = autoFontSiz(15);
    [btn setTitleColor:LTTitleColor forState:UIControlStateNormal];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UIButton *)selStateBtn:(CGFloat)x idx:(NSInteger)idx {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(x, LTAutoW(19),  LTAutoW(22), LTAutoW(22));
    [btn setTitleColor:LTTitleColor forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"unselIcon"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"selIcon"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(clickSelStateBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = selStateBtnTag + idx;
    return btn;
}

- (void)showMPError:(BOOL)error {

    if (error) {
        if (!_canShowMpError) {
            return;
        }
        
        _mpView.frame = CGRectMake(0, _buyBtn.yh_+LTAutoW(20), self.w_, LTAutoW(kMPViewH1));
        _mpField.layer.borderColor = LTKLineRed.CGColor;
        _mpTipLab.hidden = NO;
        
    } else {
        _mpView.frame = CGRectMake(0, _buyBtn.yh_+LTAutoW(20), self.w_, LTAutoW(kMPViewH));
        _mpField.layer.borderColor = LTSubTitleColor.CGColor;
        _mpTipLab.hidden = YES;
    }
    
    _waveView.frame = CGRectMake(0, _mpView.yh_ + LTAutoW(20), self.w_, LTAutoW(kWaveViewH));
    _selView.frame = CGRectMake(0, _waveView.yh_, self.w_, LTAutoW(kSelViewH));
    
    [self changeFoot:error];
}

- (void)setCurIdx:(NSInteger)curIdx {
    _curIdx = curIdx;
    
    CGFloat curBtnX = 0;
    for (NSInteger i = 0; i < wavesCount; i ++) {
        NSInteger tag = i + btnTag;
        UIButton *btn = (UIButton *)[_waveView viewWithTag:tag];
        if (i == _curIdx) {
            curBtnX = btn.xw_;
            btn.layer.borderColor = LTSureFontBlue.CGColor;
            btn.titleLabel.font = autoBoldFontSiz(15);
            [btn setTitleColor:LTSureFontBlue forState:UIControlStateNormal];
        } else {
            btn.layer.borderColor = borderColor.CGColor;
            btn.titleLabel.font = autoFontSiz(15);
            [btn setTitleColor:LTTitleColor forState:UIControlStateNormal];
        }
    }
    
    _waveIconIV.frame = CGRectMake(curBtnX - LTAutoW(kWaveIconIVWH), 0, LTAutoW(kWaveIconIVWH), LTAutoW(kWaveIconIVWH));
    
    [self changeWaveText];
}

- (void)setCycleType:(NSInteger)cycleType {
    _cycleType = cycleType;
    
    BOOL selToday = (_cycleType == 1);
    _todayBtn.selected = selToday;
    _weekBtn.selected = !selToday;
}

- (NSString *)getWaveText:(CGFloat)min max:(CGFloat)max {
    if (min > 0 && max > 0) {
        return [NSString stringWithFormat:@"当%@行情达到 %g ～ %g 范围内，将有报价提醒",_pName,min,max];
    } else {
        return [NSString stringWithFormat:@"当%@行情达到 - ～ - 范围内，将有报价提醒",_pName];
    }
}

- (void)changeWaveText {
    
    NSString *mp = _mpField.text;
    CGFloat min = 0;
    CGFloat max = 0;
    if (notemptyStr(mp)) {
        [self showMPError:NO];
        CGFloat f = [waves[_curIdx] floatValue];
        CGFloat m = [mp floatValue];
        max = m+f;
        min = m-f;
    } else {
        _mpTipLab.text = @"请输入您需要被提醒的点位";
        [self showMPError:YES];
    }
    
    NSString *txt = [self getWaveText:min max:max];
    NSAttributedString *ABStr = [txt ABSpacing:5 font:autoFontSiz(12)];
    _waveTipLab.attributedText = ABStr;
}

#pragma mark 显示关闭
static CGFloat animateDuration = 0.3;
- (void)showView:(BOOL)show {
    
    WS(ws);
    if (show) {
        NFCPost_FloatingPlayHide;
        UMengEventWithParameter(UM_MarketDetail_More, UM_MarketDetail_More, @"显示行情提醒小窗口");
        
        [self.superview bringSubviewToFront:self];
        self.alpha = 0.3;
        [self changeContentViewUp:NO];
        self.hidden = NO;
        self.userInteractionEnabled = NO;
        [UIView animateWithDuration:animateDuration animations:^{
            ws.alpha = 1;
            [ws changeContentViewUp:YES];
        } completion:^(BOOL finished) {
            ws.userInteractionEnabled = YES;
        }];
        
    } else {
        NFCPost_FloatingPlayShow;
        UMengEventWithParameter(UM_MarketDetail_More, UM_MarketDetail_More, @"关闭行情提醒小窗口");
        
        [self showMPError:NO];
        _canShowMpError = NO;
        self.alpha = 1;
        self.userInteractionEnabled = NO;
        [self changeContentViewUp:YES];
        [UIView animateWithDuration:animateDuration animations:^{
            ws.alpha = 0.3;
            [ws changeContentViewUp:NO];
        } completion:^(BOOL finished) {
            ws.userInteractionEnabled = YES;
            ws.hidden = YES;
        }];
    }
    
}

- (void)changeContentViewUp:(BOOL)bl {
    self.contentView.frame = bl ? _contentViewUpRect : _contentViewDownRect;
}









#pragma mark - init

- (void)createView {
    
    UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bgBtn.backgroundColor = self.backgroundColor;
    bgBtn.frame = CGRectMake(0, 0, self.w_, tempH);
    [bgBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bgBtn];
    
    self.contentViewUpRect = CGRectMake(0, tempH, self.w_, contentViewH);
    self.contentViewDownRect = CGRectMake(0, self.h_, self.w_, contentViewH);
    self.contentView = [[UIView alloc] init];
    _contentView.backgroundColor = LTWhiteColor;
    _contentView.frame = _contentViewDownRect;
    [_contentView addSingeTap:@selector(shutKeyBoard) target:self];
    [self addSubview:_contentView];
    
    [self createHeadView];
    [self createMPView];
    [self createWaveView];
    [self createSelView];
    [self createFootView];
}


//头部
- (void)createHeadView {
    self.headView = [[UIView alloc] init];
    _headView.frame = CGRectMake(0, 0, self.w_, LTAutoW(kHeadH));
    _headView.backgroundColor = LTBgColor;
    [_contentView addSubview:_headView];
    
    CGFloat labw = 160;
    self.titLab = [[UILabel alloc] init];
    _titLab.frame = CGRectMake((self.w_ - labw)*0.5, 0, labw, LTAutoW(kHeadH));
    _titLab.font = autoBoldFontSiz(17);
    _titLab.textColor = LTTitleColor;
    _titLab.text = @"添加提醒";
    _titLab.textAlignment = NSTextAlignmentCenter;
    [_headView addSubview:_titLab];
    
    UIButton *leftBtn = [self btnX:0 sel:@selector(cancleAction)];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_headView addSubview:leftBtn];
    
    UIButton *rightBtn = [self btnX:self.w_ - LTAutoW(kHeadBtnW) sel:@selector(clickRightBtn)];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_headView addSubview:rightBtn];
    
    [self createTypeView];
    
}

- (void)createMPView {
    self.mpView = [[UIView alloc] init];
    _mpView.frame = CGRectMake(0, _buyBtn.yh_+LTAutoW(20), self.w_, LTAutoW(kMPViewH));
    [_contentView addSubview:_mpView];
    

    UILabel *tip0 = [[UILabel alloc] init];
    tip0.frame = CGRectMake(LTAutoW(kLeftMar),  LTAutoW(10.5), LTAutoW(65), LTAutoW(15));
    tip0.font = autoFontSiz(15);
    tip0.textColor = LTTitleColor;
    tip0.text = @"行情达到";
    [_mpView addSubview:tip0];
    
    

    
    self.mpField = [[UITextField alloc] init];
    _mpField.frame = CGRectMake(tip0.xw_ + LTAutoW(12), 0, LTAutoW(126), LTAutoW(36));
    [_mpField layerRadius:3.0 borderColor:borderColor borderWidth:0.5];
    _mpField.delegate = self;
    [_mpField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _mpField.keyboardType = UIKeyboardTypeDecimalPad;
    [_mpView addSubview:_mpField];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, _mpField.h_)];
    _mpField.leftView = paddingView;
    _mpField.leftViewMode = UITextFieldViewModeAlways;
    
//    UILabel *tip1 = [[UILabel alloc] init];
//    tip1.frame = CGRectMake(_mpField.xw_ + LTAutoW(5), tip0.y_, LTAutoW(30), LTAutoW(15));
//    tip1.font = autoFontSiz(15);
//    tip1.textColor = LTSubTitleColor;
//    tip1.text = @"点";
//    [_mpView addSubview:tip1];
    
    self.mpTipLab = [[UILabel alloc] init];
    _mpTipLab.frame = CGRectMake(_mpField.x_ , _mpField.yh_ + LTAutoW(8), LTAutoW(200), LTAutoW(16));
    _mpTipLab.font = autoFontSiz(12);
    _mpTipLab.textColor = LTKLineRed;
    _mpTipLab.hidden = YES;
    [_mpView addSubview:_mpTipLab];
}

- (void)createWaveView {
    self.waveView = [[UIView alloc] init];
    _waveView.frame = CGRectMake(0, _mpView.yh_ + LTAutoW(20), self.w_, LTAutoW(kWaveViewH));
    [_contentView addSubview:_waveView];
    
    
    UILabel *tip1 = [[UILabel alloc] init];
    tip1.frame = CGRectMake(LTAutoW(kLeftMar), LTAutoW(11), LTAutoW(65), LTAutoW(15));
    tip1.font = autoFontSiz(15);
    tip1.textColor = LTTitleColor;
    tip1.text = @"波动范围";
    [_waveView addSubview:tip1];
    
    
    btnx = tip1.xw_ + LTAutoW(12);
    btnw = LTAutoW(60);
    btnh = LTAutoW(36);
    
    self.waveIconIV = [[UIImageView alloc] init];
    _waveIconIV.image = [UIImage imageNamed:@"market_pic_corner"];
    [_waveView addSubview:_waveIconIV];
    
    
    self.waveTipLab = [[UILabel alloc] init];
    _waveTipLab.frame = CGRectMake(btnx, btnh , LTAutoW(259), LTAutoW(46));
    _waveTipLab.font = autoFontSiz(12);
    _waveTipLab.textColor = LTSubTitleColor;
    _waveTipLab.numberOfLines = 0;
    [_waveView addSubview:_waveTipLab];
    
}
-(void)createTypeView{
    _buyType=@"2";
    CGRect frame = CGRectMake(16, _headView.yh_+LTAutoW(20) , ScreenW_Lit/2-16, LTAutoW(40));
    CGFloat fs= LTAutoW(15);
    _buyBtn=[self createBtnWithF:frame title:@"买价" fsize:fs];
    [_buyBtn setBackgroundColor:LTKLineRed];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_buyBtn.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(3, 3)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _buyBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    _buyBtn.layer.mask = maskLayer;
    [_contentView addSubview:_buyBtn];
    
    CGRect frame1 = CGRectMake(ScreenW_Lit/2, _buyBtn.y_, ScreenW_Lit/2-16, _buyBtn.h_);
    _sellBtn=[self createBtnWithF:frame1 title:@"卖价" fsize:fs];
    [_sellBtn setTitleColor:LTTitleColor forState:UIControlStateNormal];
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:_sellBtn.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(3, 3)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = _sellBtn.bounds;
    maskLayer1.path = maskPath1.CGPath;
    _sellBtn.layer.mask = maskLayer1;
    [_contentView addSubview:_sellBtn];


}
- (void)createSelView {
    self.selView = [[UIView alloc] init];
    _selView.frame = CGRectMake(0, _waveView.yh_, self.w_, LTAutoW(kSelViewH));
    [_contentView addSubview:_selView];
    
    UIView *lineView = [UIView lineFrame:CGRectMake(0, 0, self.w_, 0.5) color:LTLineColor];
    [_selView addSubview:lineView];
    
    self.todayBtn = [self selStateBtn:LTAutoW(kLeftMar) idx:1];
    [_selView addSubview:_todayBtn];
    UILabel *todayLab = [[UILabel alloc] init];
    todayLab.frame = CGRectMake(_todayBtn.xw_ + LTAutoW(8), LTAutoW(22.5), LTAutoW(200), LTAutoW(15));
    todayLab.font = autoFontSiz(15);
    todayLab.textColor = LTTitleColor;
    todayLab.text = @"提醒24小时有效";
    [_selView addSubview:todayLab];
    
    self.weekBtn = [self selStateBtn:0.5*self.w_ idx:2];
    [_selView addSubview:_weekBtn];
    UILabel *weekLab = [[UILabel alloc] init];
    weekLab.frame = CGRectMake(_weekBtn.xw_ + LTAutoW(8), LTAutoW(22.5), LTAutoW(200), LTAutoW(15));
    weekLab.font = autoFontSiz(15);
    weekLab.textColor = LTTitleColor;
    weekLab.text = @"提醒7日内有效";
    [_selView addSubview:weekLab];
    
    self.cycleType = 1;
    self.curIdx = 0;
}

- (void)createFootView {
    self.footLab = [[UILabel alloc] init];
    _footLab.frame = CGRectMake(LTAutoW(kLeftMar), contentViewH - LTAutoW(32) - LTAutoW(kFootLabH), self.w_ - 2*LTAutoW(kLeftMar), LTAutoW(kFootLabH));
    _footLab.font = autoFontSiz(12);
    _footLab.textColor = LTSubTitleColor;
    _footLab.numberOfLines = 0;
    [_contentView addSubview:_footLab];
    NSString *txt = @"行情达到：为您需要被提醒的点位，可设置到小数点后二位\n波动范围：为允许上下波动的范围，可以有效预防跳点的情况";
    NSAttributedString *ABStr = [txt ABSpacing:5 font:autoFontSiz(12)];
    _footLab.attributedText = ABStr;
    
    CGFloat footBtnW = LTAutoW(160);
    CGFloat footBtnY = self.footLab.y_ - LTAutoW(16) - LTAutoW(kFootBtnH);
    CGRect footBtnFrame = CGRectMake((self.w_ - footBtnW)*0.5, footBtnY, footBtnW, LTAutoW(kFootBtnH));
    self.footBtn = [UIButton btnWithTarget:self action:@selector(delectRemind) frame:footBtnFrame];
    [_footBtn layerRadius:3.0 borderColor:LTKLineRed borderWidth:0.5];
    [_footBtn setTitle:@"删除提醒" forState:UIControlStateNormal];
    _footBtn.titleLabel.font = autoFontSiz(15);
    [_footBtn setTitleColor:LTKLineRed forState:UIControlStateNormal];
    [_contentView addSubview:_footBtn];
    _footBtn.hidden = YES;
}


- (void)changeFoot:(BOOL)error {
    if (_mo && ScreenH_Lit == 480 && error) {

        _footLab.frame = CGRectMake(LTAutoW(kLeftMar), contentViewH - LTAutoW(12) - LTAutoW(kFootLabH), self.w_ - 2*LTAutoW(kLeftMar), LTAutoW(kFootLabH));
        
        CGFloat footBtnW = LTAutoW(160);
        CGFloat footBtnY = self.footLab.y_ - LTAutoW(16) - LTAutoW(30);
        CGRect footBtnFrame = CGRectMake((self.w_ - footBtnW)*0.5, footBtnY, footBtnW, LTAutoW(kFootBtnH));
        _footBtn.frame = footBtnFrame;
    } else {
        _footLab.frame = CGRectMake(LTAutoW(kLeftMar), contentViewH - LTAutoW(32) - LTAutoW(kFootLabH), self.w_ - 2*LTAutoW(kLeftMar), LTAutoW(kFootLabH));
        
        CGFloat footBtnW = LTAutoW(160);
        CGFloat footBtnY = self.footLab.y_ - LTAutoW(16) - LTAutoW(kFootBtnH);
        CGRect footBtnFrame = CGRectMake((self.w_ - footBtnW)*0.5, footBtnY, footBtnW, LTAutoW(kFootBtnH));
        _footBtn.frame = footBtnFrame;
    }
}
#pragma mark - btnAction
-(void)btnAction:(UIButton *)btn{
    if (btn==_buyBtn) {
        [_buyBtn setBackgroundColor:LTKLineRed];
        [_buyBtn setTitleColor:LTWhiteColor forState:UIControlStateNormal];
        [_sellBtn setBackgroundColor:LTBgColor];
        [_sellBtn setTitleColor:LTTitleColor forState:UIControlStateNormal];
        _buyType=@"2";
    }else{
        [_buyBtn setBackgroundColor:LTBgColor];
        [_buyBtn setTitleColor:LTTitleColor forState:UIControlStateNormal];
        [_sellBtn setBackgroundColor:LTKLineGreen];
        [_sellBtn setTitleColor:LTWhiteColor forState:UIControlStateNormal];
        _buyType=@"1";
    }
}
#pragma mark - utils
-(UIButton *)createBtnWithF:(CGRect)frame title:(NSString *)title fsize:(CGFloat)fsize{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:LTBgColor];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font=[UIFont systemFontOfSize:fsize];
    return btn;
}
@end
