//
//  LTAlertView.m
//  ixit
//
//  Created by litong on 2016/11/30.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "LTAlertView.h"


static CGFloat kLTAlertViewTopMar = 26;//上边距
static CGFloat kLTAlertViewBtmMar = 22;//下边距
static CGFloat kLTAlertViewLeftMar = 30;//左边距
static CGFloat kLTAlertViewH = 170;//alertView默认高度
static CGFloat kLTAlertViewVSpacing = 12;  //垂直空白高度

//static CGFloat centerBtnH = 20;
//static CGFloat centerBtnW = 100;
//static CGFloat centerBtSpacingTopBottom = 10;
//static CGFloat marginLeft = 15;

#define kLTAlertViewTag    5001
#define kLTButtonTag        6100

#define titleFontSize           15.f
#define titleTextColor          LTTitleColor

#define messageFontSize   12.f
#define messageTextColor  LTSubTitleColor

#define kLTAlertViewBtnH    44    //按钮高度
#define btnFontSize             15.f
#define sureBtnTexColor      LTSureFontBlue
#define cancelBtnTexColor  LTSubTitleColor

#define iconIVWH 46

@interface LTAlertView ()

@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,strong) UIView *alertView;

@property (nonatomic,strong) UIImageView *iconIV;
@property (nonatomic,strong) UILabel *titleLable;
@property (nonatomic,strong) UILabel *messageLable;
@property (nonatomic,strong) UIView *customView;
@property (nonatomic,assign) BOOL allCustom;

@property (nonatomic,strong) UIView *btnView;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *sureBtn;

@property(nonatomic,strong) UITextField *field;

@property (nonatomic, copy) LTAlertAction sureAction;
@property (nonatomic, copy) LTAlertInputAction sureInputAction;
@property (nonatomic, copy) LTAlertAction cancelAction;

@end

@implementation LTAlertView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, ScreenW_Lit, ScreenH_Lit);
        self.tag = kLTAlertViewTag;
        [self createView];
        
    }
    return self;
}

- (void)setSureBtnTextColor:(UIColor *)color {
    [_sureBtn setTitleColor:color forState:UIControlStateNormal];
}

- (void)setCancelBtnTextColor:(UIColor *)color {
    [_cancelBtn setTitleColor:color forState:UIControlStateNormal];
}

#pragma mark - init

- (void)createView {
    
    self.maskView = [[UIView alloc] init];
    _maskView.frame = CGRectMake(0, 0, ScreenW_Lit, ScreenH_Lit);
    _maskView.backgroundColor = LTMaskColor;
    [self addSubview:_maskView];
    
    self.alertView = [[UIView alloc] init];
    _alertView.frame = CGRectMake((self.w_ - kLTAlertViewW)/2, (self.w_ - kLTAlertViewH)/2, kLTAlertViewW, kLTAlertViewH);
    _alertView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_alertView];
    
    self.iconIV = [[UIImageView alloc] init];
    _iconIV.image = [UIImage imageNamed:@"alertSuccess"];
    _iconIV.frame = CGRectMake((kLTAlertViewW - iconIVWH)*0.5, kLTAlertViewTopMar, iconIVWH, iconIVWH);
    [_alertView addSubview:_iconIV];
    _iconIV.hidden = YES;
    
    self.titleLable = [self lab:titleFontSize textColor:titleTextColor];
    [_alertView addSubview:_titleLable];

    
    self.messageLable = [self lab:messageFontSize textColor:messageTextColor];
    [_alertView addSubview:_messageLable];
    
    self.btnView = [[UIView alloc] init];
    _btnView.backgroundColor = LTBgColor;
    [_alertView addSubview:_btnView];
    
    
    self.sureBtn = [self btn:sureBtnTexColor sel:@selector(sureBtnAction)];
    [_btnView addSubview:_sureBtn];
    
    self.cancelBtn = [self btn:cancelBtnTexColor sel:@selector(cancelBtnAction)];
    [_btnView addSubview:_cancelBtn];
    
}


#pragma mark - utils

- (UILabel *)lab:(CGFloat)fontSize textColor:(UIColor *)textColor {
    UILabel *lab = [[UILabel alloc] init];
    lab.font = [self fontOfSize:fontSize];
    lab.textColor = textColor;
    lab.numberOfLines = 0;
    lab.textAlignment = NSTextAlignmentCenter;
    return lab;
}

- (UIButton *)btn:(UIColor *)color sel:(SEL)sel {
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font =[self fontOfSize:btnFontSize];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UIFont *)fontOfSize:(CGFloat)fontSize {
    return [UIFont systemFontOfSize:fontSize];
}

- (CGSize)autoSizeFont:(UIFont *)font text:(NSString *)text constrainedToSize:(CGSize)size {
    return [text boundingRectWithSize:size
                              options:
            NSStringDrawingTruncatesLastVisibleLine |
            NSStringDrawingUsesLineFragmentOrigin |
            NSStringDrawingUsesFontLeading
                           attributes:@{NSFontAttributeName:font}
                              context:nil].size;
}

#pragma mark - action

- (void)sureBtnAction {
    if (_field) {
        if (_sureInputAction) {
            _sureInputAction(_field.text);
            return;
        }
    }
    _sureAction ? _sureAction() : nil;
    [self dismiss];
}

- (void)cancelBtnAction {
    _cancelAction ? _cancelAction() : nil;
    [self dismiss];
}

- (void)show {
    NFCPost_FloatingPlayHide;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    UIView *view = [keyWindow viewWithTag:kLTAlertViewTag];
    if ([view isKindOfClass:[LTAlertView class]]) {
        [view removeFromSuperview];
    }
    
    [keyWindow addSubview:self];
    [keyWindow bringSubviewToFront:self];
}

- (void)dismiss {
    NFCPost_FloatingPlayShow;
    [self removeFromSuperview];
}


- (void)alertTitle:(NSString *)title
           message:(NSString *)message
         sureTitle:(NSString *)sureTitle
        sureAction:(LTAlertAction)sureAction
       cancelTitle:(NSString *)cancelTitle
      cancelAction:(LTAlertAction)cancelAction {
    
    CGFloat labW = kLTAlertViewW - 2*kLTAlertViewLeftMar;

    
    CGFloat y = kLTAlertViewTopMar;
    if (title) {
        if (!message) {
            if (_allCustom) {
                y = 16;
            } else {
                y +=20;
            }
        }
        
        CGSize size = [self autoSizeFont:[self fontOfSize:titleFontSize] text:title constrainedToSize:CGSizeMake(labW, MAXFLOAT)];
        _titleLable.frame = CGRectMake(kLTAlertViewLeftMar, y, labW, size.height);
        _titleLable.text = title;
    } else {
        _titleLable.frame = CGRectMake(kLTAlertViewLeftMar, y, labW, 0);
    }
    
    
    y = _titleLable.yh_;
    if (message) {
        CGFloat fs = messageFontSize;
        if (!title) {
            y +=6;
            fs = titleFontSize;
        }
        
//        CGSize size = [self autoSizeFont:[self fontOfSize:messageFontSize] text:message constrainedToSize:CGSizeMake(labW, MAXFLOAT)];
        NSAttributedString *ABStr = [message ABStrSpacing:4 font:autoFontSiz(fs)];
        CGSize size = [ABStr autoSize:CGSizeMake(labW, MAXFLOAT)];
        
        _messageLable.frame = CGRectMake(kLTAlertViewLeftMar, y + kLTAlertViewVSpacing, labW, size.height);
        _messageLable.attributedText = ABStr;
        _messageLable.textAlignment = NSTextAlignmentCenter;
    } else {
        _messageLable.frame = CGRectMake(kLTAlertViewLeftMar, y, labW, 0);
    }
    
    y = _messageLable.yh_;
    if (_customView) {
        CGRect r = CGRectMake(0, y, _customView.w_, _customView.h_);
        _customView.frame = r;
        [_alertView addSubview:_customView];
        y = _customView.yh_;
    } else {
        y += kLTAlertViewBtmMar;
        if (!title) {
            y += 12;
        }
        if (!message) {
            y += 18;
        }

    }
    
    _btnView.frame = CGRectMake(0, y, kLTAlertViewW, kLTAlertViewBtnH);
    
    NSInteger btnCount = 1;
    if (cancelTitle && sureTitle) {
        btnCount = 2;
        UIView *HLine = [[UIView alloc] init];
        HLine.frame = CGRectMake(_btnView.w_/2.0, 0, 0.5, kLTAlertViewBtnH);
        HLine.backgroundColor = [UIColor whiteColor];
        [_btnView addSubview:HLine];
    }
    CGFloat btnW = 1.0*kLTAlertViewW/btnCount;
    
    if (cancelTitle) {
        [_cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
       _cancelBtn.frame = CGRectMake(0, 0, btnW, kLTAlertViewBtnH);
        self.cancelAction = cancelAction;
    }
    
    if (sureTitle) {
        [_sureBtn setTitle:sureTitle forState:UIControlStateNormal];
        _sureBtn.frame = CGRectMake((btnCount - 1)*btnW, 0, btnW, kLTAlertViewBtnH);
        self.sureAction = sureAction;
    }
    

    CGFloat alertViewH = _btnView.yh_;
    _alertView.frame = CGRectMake((self.w_ - kLTAlertViewW)/2, (self.h_ - alertViewH)/2, kLTAlertViewW, alertViewH);
    _alertView.layer.cornerRadius = 3;
    _alertView.layer.masksToBounds = YES;
 
    
}

- (void)alertFieldTitle:(NSString *)title
                 sureTitle:(NSString *)sureTitle
                sureAction:(LTAlertInputAction)sureAction
               cancelTitle:(NSString *)cancelTitle
              cancelAction:(LTAlertAction)cancelAction  {
    
    CGFloat y = 18;
    CGFloat labW = kLTAlertViewW - 2*kLTAlertViewLeftMar;
    CGSize size = [self autoSizeFont:[self fontOfSize:titleFontSize] text:title constrainedToSize:CGSizeMake(labW, MAXFLOAT)];
    _titleLable.frame = CGRectMake(kLTAlertViewLeftMar, y, labW, size.height);
    _titleLable.text = title;
    
    CGFloat fieldViewX = 12;
    UIView *fieldView = [UIView lineFrame:CGRectMake(fieldViewX, _titleLable.yh_ + 15, kLTAlertViewW - 2*fieldViewX, 44) color:LTWhiteColor];
    [fieldView layerRadius:3 borderColor:LTLineColor borderWidth:1];
    [_alertView addSubview:fieldView];
    
    CGFloat fieldx = 16;
    self.field = [[UITextField alloc] init];
    _field.frame = CGRectMake(fieldx, 0, kLTAlertViewW - 2*fieldx, fieldView.h_);
    [fieldView addSubview:_field];
    
    
    _btnView.frame = CGRectMake(0, fieldView.yh_ + 20, kLTAlertViewW, kLTAlertViewBtnH);
    
    NSInteger btnCount = 1;
    if (cancelTitle && sureTitle) {
        btnCount = 2;
        UIView *HLine = [[UIView alloc] init];
        HLine.frame = CGRectMake(_btnView.w_/2.0, 0, 0.5, kLTAlertViewBtnH);
        HLine.backgroundColor = [UIColor whiteColor];
        [_btnView addSubview:HLine];
    }
    CGFloat btnW = 1.0*kLTAlertViewW/btnCount;
    
    if (cancelTitle) {
        [_cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
        _cancelBtn.frame = CGRectMake(0, 0, btnW, kLTAlertViewBtnH);
        self.cancelAction = cancelAction;
    }
    
    if (sureTitle) {
        [_sureBtn setTitle:sureTitle forState:UIControlStateNormal];
        _sureBtn.frame = CGRectMake((btnCount - 1)*btnW, 0, btnW, kLTAlertViewBtnH);
        self.sureInputAction = sureAction;
    }
    
    
    CGFloat alertViewH = _btnView.yh_;
    _alertView.frame = CGRectMake((self.w_ - kLTAlertViewW)/2, (self.h_ - alertViewH)/2, kLTAlertViewW, alertViewH);
    _alertView.layer.cornerRadius = 3;
    _alertView.layer.masksToBounds = YES;
    
}


#pragma mark - blcok


#pragma mark  button title 默认 取消 & 确定
+ (void)alertWithMessage:(NSString *)message sureAction:(LTAlertAction)sureAction {
    [LTAlertView alertWithTitle:nil message:message sureAction:sureAction cancelAction:nil];
}
+ (void)alertWithTitle:(NSString *)title sureAction:(LTAlertAction)sureAction {
    [LTAlertView alertWithTitle:title message:nil sureAction:sureAction cancelAction:nil];
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message sureAction:(LTAlertAction)sureAction cancelAction:(LTAlertAction)cancelAction {
    [LTAlertView alertTitle:title message:message
                  sureTitle:@"确定" sureAction:sureAction
                cancelTitle:@"取消" cancelAction:cancelAction];
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message sureTitle:(NSString *)sureTitle sureAction:(LTAlertAction)sureAction cancelAction:(LTAlertAction)cancelAction {
    [LTAlertView alertTitle:title message:message
                  sureTitle:sureTitle sureAction:sureAction
                cancelTitle:@"取消" cancelAction:cancelAction];
}

#pragma mark  通用

+ (void)alertMessage:(NSString *)message {
    if (!notemptyStr(message)) {
        return;
    }
    [LTAlertView alertTitle:message message:nil
                  sureTitle:@"确定" sureAction:nil
                cancelTitle:nil cancelAction:nil];
}
+ (void)alertMessage:(NSString *)message sureAction:(LTAlertAction)sureAction {
    [LTAlertView alertTitle:nil message:message
                  sureTitle:@"确定" sureAction:sureAction
                cancelTitle:nil cancelAction:nil];
}
+ (void)alertMessage:(NSString *)message sureTitle:(NSString *)sureTitle sureAction:(LTAlertAction)sureAction {
    [LTAlertView alertTitle:nil message:message
                  sureTitle:sureTitle sureAction:sureAction
                cancelTitle:nil cancelAction:nil];
}

+ (void)alertTitle:(NSString *)title {
    [LTAlertView alertTitle:title message:nil
                  sureTitle:@"确定" sureAction:nil
                cancelTitle:nil cancelAction:nil];
}

+ (void)alertTitle:(NSString *)title message:(NSString *)message
         sureTitle:(NSString *)sureTitle sureAction:(LTAlertAction)sureAction {
    [LTAlertView alertTitle:title message:message
                  sureTitle:sureTitle sureAction:sureAction
                cancelTitle:nil cancelAction:nil];
}

+ (void)alertTitle:(NSString *)title message:(NSString *)message
         sureTitle:(NSString *)sureTitle sureAction:(LTAlertAction)sureAction
       cancelTitle:(NSString *)cancelTitle  {
    [LTAlertView alertTitle:title message:message
                  sureTitle:sureTitle sureAction:sureAction
                cancelTitle:cancelTitle cancelAction:nil];
}

#pragma mark  base

+ (void)alertTitle:(NSString *)title message:(NSString *)message
         sureTitle:(NSString *)sureTitle sureAction:(LTAlertAction)sureAction
       cancelTitle:(NSString *)cancelTitle cancelAction:(LTAlertAction)cancelAction {
    
    LTAlertView *alertView = [[LTAlertView alloc] init];
    [alertView alertTitle:title message:message
                sureTitle:sureTitle sureAction:sureAction
              cancelTitle:cancelTitle cancelAction:cancelAction];
    [alertView show];
}

#pragma mark  自定义

+ (void)alertTitle:(NSString *)title message:(NSString *)message
         sureTitle:(NSString *)sureTitle sureAction:(LTAlertAction)sureAction
       cancelTitle:(NSString *)cancelTitle cancelAction:(LTAlertAction)cancelAction
        customView:(UIView *)customView {
    
    LTAlertView *alertView = [[LTAlertView alloc] init];
    alertView.customView = customView;
    [alertView alertTitle:title message:message
                sureTitle:sureTitle sureAction:sureAction
              cancelTitle:cancelTitle cancelAction:cancelAction];
    [alertView show];
}


+ (void)alertTitle:(NSString *)title message:(NSString *)message
         sureTitle:(NSString *)sureTitle sureAction:(LTAlertAction)sureAction
       cancelTitle:(NSString *)cancelTitle cancelAction:(LTAlertAction)cancelAction
  sureBtnTextColor:(UIColor *)sureBtnTextColor cancelBtnTextColor:(UIColor *)cancelBtnTextColor {
    
    LTAlertView *alertView = [[LTAlertView alloc] init];
    [alertView setSureBtnTextColor:sureBtnTextColor];
    [alertView setCancelBtnTextColor:cancelBtnTextColor];
    
    [alertView alertTitle:title message:message
                sureTitle:sureTitle sureAction:sureAction
              cancelTitle:cancelTitle cancelAction:cancelAction];
    
    [alertView show];
}

+ (void)alertTitle:(NSString *)title message:(NSString *)message
         sureTitle:(NSString *)sureTitle sureAction:(LTAlertAction)sureAction
       cancelTitle:(NSString *)cancelTitle cancelAction:(LTAlertAction)cancelAction
  sureBtnTextColor:(UIColor *)sureBtnTextColor cancelBtnTextColor:(UIColor *)cancelBtnTextColor customView:(UIView *)customView {
    
    LTAlertView *alertView = [[LTAlertView alloc] init];
    [alertView setSureBtnTextColor:sureBtnTextColor];
    [alertView setCancelBtnTextColor:cancelBtnTextColor];
    alertView.customView = customView;
    alertView.allCustom = YES;
    [alertView alertTitle:title message:message
                sureTitle:sureTitle sureAction:sureAction
              cancelTitle:cancelTitle cancelAction:cancelAction];
    [alertView show];
    
}






#pragma mark - 成功view

+ (void)alertSuccessMsg:(NSString *)msg
              sureTitle:(NSString *)sureTitle sureAction:(LTAlertAction)sureAction
            cancelTitle:(NSString *)cancelTitle cancelAction:(LTAlertAction)cancelAction {
    
    LTAlertView *alertView = [[LTAlertView alloc] init];
    CGFloat labW = kLTAlertViewW - 2*kLTAlertViewLeftMar;
    
    alertView.iconIV.hidden = NO;
    
    CGSize size = [msg boundingRectWithSize:CGSizeMake(labW, MAXFLOAT)
                                     options:
                   NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:titleFontSize]}
                                     context:nil].size;
    alertView.titleLable.frame = CGRectMake(kLTAlertViewLeftMar, kLTAlertViewTopMar+iconIVWH+12, labW, size.height);
    alertView.titleLable.text = msg;
    

    alertView.btnView.frame = CGRectMake(0, alertView.titleLable.yh_+16, kLTAlertViewW, kLTAlertViewBtnH);
    
    NSInteger btnCount = 1;
    if (cancelTitle && sureTitle) {
        btnCount = 2;
        UIView *HLine = [[UIView alloc] init];
        HLine.frame = CGRectMake(alertView.btnView.w_/2.0, 0, 0.5, kLTAlertViewBtnH);
        HLine.backgroundColor = [UIColor whiteColor];
        [alertView.btnView addSubview:HLine];
    }
    CGFloat btnW = 1.0*kLTAlertViewW/btnCount;
    
    if (cancelTitle) {
        [alertView.cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
        alertView.cancelBtn.frame = CGRectMake(0, 0, btnW, kLTAlertViewBtnH);
        alertView.cancelAction = cancelAction;
    }
    
    if (sureTitle) {
        [alertView.sureBtn setTitle:sureTitle forState:UIControlStateNormal];
        alertView.sureBtn.frame = CGRectMake((btnCount - 1)*btnW, 0, btnW, kLTAlertViewBtnH);
        alertView.sureAction = sureAction;
    }
    
    
    CGFloat alertViewH = alertView.btnView.yh_;
    alertView.alertView.frame = CGRectMake((ScreenW_Lit - kLTAlertViewW)/2, (ScreenH_Lit - alertViewH)/2, kLTAlertViewW, alertViewH);
    alertView.alertView.layer.cornerRadius = 3;
    alertView.alertView.layer.masksToBounds = YES;
    
    [alertView show];
}

+ (UIView *)successViewWithMsg:(NSString *)msg {
    UIView *BGView=[[UIView alloc]init];
    BGView.frame=CGRectMake(0, 0, Screen_width,Screen_height);
    BGView.backgroundColor=LTRGBA(1, 1, 1, 0.5);
    
    UIView * _successView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.72*Screen_width, 124)];
    _successView.backgroundColor=[UIColor whiteColor];
    _successView.layer.masksToBounds=YES;
    _successView.layer.cornerRadius=4;
    
    UIImageView *img=[[UIImageView alloc]init];
    img.frame=CGRectMake((0.72*Screen_width-40)/2, 24, 40,40);
    img.image= [UIImage imageNamed:@"success_green"];
    [_successView addSubview:img];
    
    UILabel *label=[[UILabel alloc]init];
    label.frame=CGRectMake(0, 68, 0.72*Screen_width, 40);
    label.text=msg;
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=LTTitleRGB;
    label.font=fontSiz(17);
    [_successView addSubview:label];
    _successView.center=BGView.center;
    [BGView addSubview:_successView];
    return BGView;
}

#pragma mark - Field提示

+ (void)alertFieldMsg:(NSString *)msg sureTitle:(NSString *)sureTitle sureAction:(LTAlertInputAction)sureAction cancelTitle:(NSString *)cancelTitle cancelAction:(LTAlertAction)cancelAction {
    LTAlertView *alertView = [[LTAlertView alloc] init];
    [alertView alertFieldTitle:msg sureTitle:sureTitle sureAction:sureAction cancelTitle:cancelTitle cancelAction:cancelAction];
    [alertView show];
}

#pragma mark - 更新提示

+ (void)alertAppUpdate:(NSString *)version content:(NSString *)content {
    CGFloat toptemp = 16;
    CGFloat leftMar = 24;
    CGFloat topMar = 20;
    CGFloat midMar = 15;
    CGFloat verLabh = 20;
    CGFloat labW = kLTAlertViewW - 2*leftMar;
    UIFont *font = [UIFont fontOfSize:15];
    
    NSString *ver = [NSString stringWithFormat:@"新版本号：%@",version];
    NSString *cont = [NSString stringWithFormat:@"更新内容：\n%@",content];
    NSAttributedString *contABStr = [cont ABStrSpacing:5 font:font];
    CGSize size = [contABStr autoSize:CGSizeMake(labW, MAXFLOAT)];
    CGFloat ch = size.height;
    CGFloat h = toptemp + 2*topMar + verLabh + midMar + ch;
    
    UIView *customView = [[UIView alloc] init];
    customView.frame = CGRectMake(0, 0, kLTAlertViewW, h);
    
    [customView addLine:LTLineColor frame:CGRectMake(0, toptemp, customView.w_, 0.5) ];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(leftMar, (toptemp + 0.5) + topMar, labW, verLabh);
    lab.text = ver;
    lab.font = font;
    lab.textColor = LTSubTitleColor;
    lab.textAlignment = NSTextAlignmentLeft;
    [customView addSubview:lab];
    
    UILabel *labContent = [[UILabel alloc] init];
    labContent.frame = CGRectMake(leftMar, lab.yh_ + midMar, labW, ch);
    labContent.attributedText = contABStr;
    labContent.font = font;
    labContent.textColor = LTSubTitleColor;
    labContent.textAlignment = NSTextAlignmentLeft;
    labContent.numberOfLines = 0;
    [customView addSubview:labContent];
    
    [LTAlertView alertTitle:@"检测到新版本" message:nil sureTitle:@"立即更新" sureAction:^{
        NSString* urlPath = [@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=" stringByAppendingString:APPCONFIG_APPID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlPath]];
    } cancelTitle:@"暂不更新" cancelAction:nil
           sureBtnTextColor:LTSureFontBlue
         cancelBtnTextColor:LTSubTitleColor
                 customView:customView];
}


@end
