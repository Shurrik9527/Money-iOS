//
//  LTAlertSheetView.m
//  ixit
//
//  Created by litong on 2016/12/23.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "LTAlertSheetView.h"

#define LTTipSheetH    35
#define LTSheetH    44
#define LTSheetTag  1000

@interface LTAlertSheetView ()
{
    CGFloat sheetH;
    CGFloat contentViewY;
    CGFloat contentViewH;
}
@property (nonatomic,strong) NSArray *mos;
@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UILabel *tipLab;
@property (nonatomic,strong) UILabel *msgLab;
@property (nonatomic,strong) UIButton *cancleBtn;


@property (nonatomic,assign) CGRect contentViewUpRect;
@property (nonatomic,assign) CGRect contentViewDownRect;

@end

@implementation LTAlertSheetView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        sheetH = LTSheetH;
        self.backgroundColor = LTMaskColor;//LTRGBA(0, 0, 0, 0.5);
        [self createView];
    }
    return self;
}

- (void)createView {
    
    UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bgBtn.backgroundColor = self.backgroundColor;
    bgBtn.frame = CGRectMake(0, 0, self.w_, self.h_);
    [bgBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bgBtn];
    
    self.contentView = [[UIView alloc] init];
    _contentView.backgroundColor = LTWhiteColor;
    [self addSubview:_contentView];
    
    
    self.tipLab = [[UILabel alloc] init];
    _tipLab.textColor = LTSubTitleColor;
    _tipLab.font = [UIFont fontOfSize:12];
    _tipLab.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:_tipLab];
    
    self.msgLab = [[UILabel alloc] init];
    _msgLab.textColor = LTTitleColor;
    _msgLab.backgroundColor=LTWhiteColor;
    _msgLab.font = [UIFont fontOfSize:15];
    _msgLab.textAlignment = NSTextAlignmentCenter;
    _msgLab.numberOfLines=0;
    [_contentView addSubview:_msgLab];
    
    self.cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancleBtn.backgroundColor = LTWhiteColor;
    [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancleBtn setTitleColor:LTSubTitleColor  forState:UIControlStateNormal];
    [_cancleBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_cancleBtn];
    
    self.hidden = YES;
}

- (void)addSheet:(NSInteger)idx {
    NSString *title = _mos[idx];
    CGFloat y = _msgLab.yh_ + idx * sheetH;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, y, _contentView.w_, sheetH);
    btn.tag = LTSheetTag + idx;
    btn.backgroundColor = LTWhiteColor;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:LTTitleColor  forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sheetAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:btn];
    
    UIView *lineView = [[UIView alloc] init] ;
    lineView.frame = CGRectMake(0, sheetH-0.5, ScreenW_Lit, 0.5);
    lineView.backgroundColor = LTLineColor;
    [btn addSubview:lineView];
}


#pragma mark - action

- (void)sheetAction:(UIButton *)sender {
    NSInteger idx = sender.tag - LTSheetTag;
    
    _alertSheetBlock ? _alertSheetBlock(idx) : nil;
    [self showView:NO];
}

- (void)cancleAction {
    [self showView:NO];
}

#pragma mark - 外部

- (void)configSheetH:(CGFloat)sh {
    sheetH = sh;
}

- (void)configContentView:(NSString *)title mos:(NSArray *)mos {
    self.mos = mos;
    
    if (title) {
        _tipLab.text = title;
        _tipLab.frame = CGRectMake(0, 0, self.w_, LTTipSheetH);
        UIView *lineView = [[UIView alloc] init] ;
        lineView.frame = CGRectMake(0, LTTipSheetH-0.5, ScreenW_Lit, 0.5);
        lineView.backgroundColor = LTLineColor;
        [_tipLab addSubview:lineView];
    } else {
        _tipLab.frame = CGRectZero;
    }
    _msgLab.frame=CGRectMake(16, _tipLab.yh_, self.w_-32, 0);

    NSInteger mosCount = mos.count;
    
    contentViewH = (mosCount + 1)*sheetH + _tipLab.yh_;
    contentViewY = self.h_-contentViewH;
    
    self.contentViewUpRect = CGRectMake(0, contentViewY, self.w_, contentViewH);
    self.contentViewDownRect = CGRectMake(0, self.h_, self.w_, contentViewH);
    _contentView.frame = _contentViewUpRect;
    _cancleBtn.frame = CGRectMake(0, contentViewH - sheetH, _contentView.w_, sheetH);
    
    NSInteger i;
    for (i = 0; i < mosCount; i ++) {
        [self addSheet:i];
    }

    
}
- (void)configContentView:(NSString *)title
                      msg:(NSString *)msg
                   subMsg:(NSString *)subMsg
                      mos:(NSArray *)mos{
    self.mos = mos;
    
    if (title) {
        _tipLab.text = title;
        _tipLab.frame = CGRectMake(0, 0, self.w_, LTTipSheetH);
        UIView *lineView = [[UIView alloc] init] ;
        lineView.frame = CGRectMake(0, LTTipSheetH-0.5, ScreenW_Lit, 0.5);
        lineView.backgroundColor = LTLineColor;
        [_tipLab addSubview:lineView];
        _tipLab.backgroundColor=LTOrangeColor;
        _tipLab.textColor=LTWhiteColor;
        _tipLab.font=[UIFont systemFontOfSize:15];
    } else {
        _tipLab.frame = CGRectZero;
    }
    
    CGFloat msgH=0;
    CGFloat labW=self.w_-32;
    if (notemptyStr(msg)) {
        if (!notemptyStr(subMsg)) {
            _msgLab.text=msg;
            msgH=[LTUtils labHeightWithWidth:labW fontsize:15 text:msg];
        }else{
            _msgLab.frame=CGRectMake(16, _tipLab.yh_, labW, 1000);

            NSString *msgStr=[NSString stringWithFormat:@"%@\n%@",msg,subMsg];
            NSRange range = [msgStr rangeOfString:subMsg];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:msgStr];
            [attr addAttribute:NSForegroundColorAttributeName value:LTSubTitleColor range:range];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.alignment = NSTextAlignmentCenter;//设置对齐方式
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            paragraphStyle.lineSpacing = 4.f;
            [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, msgStr.length)];
            _msgLab.attributedText=attr;
            msgH = [_msgLab sizeThatFits:_msgLab.frame.size].height;
        }
        _msgLab.frame=CGRectMake(16, _tipLab.yh_, labW, msgH+16);
        
        UIView *lineView = [[UIView alloc] init] ;
        lineView.frame = CGRectMake(0, _msgLab.yh_-0.5, ScreenW_Lit, 0.5);
        lineView.backgroundColor = LTLineColor;
        [_contentView addSubview:lineView];
    }else{
        _msgLab.frame=CGRectMake(16, _tipLab.yh_, labW, 0);
    }
    
    NSInteger mosCount = mos.count;
    
    contentViewH = (mosCount + 1)*sheetH + _msgLab.yh_+8;
    contentViewY = self.h_-contentViewH;
    
    self.contentViewUpRect = CGRectMake(0, contentViewY, self.w_, contentViewH);
    self.contentViewDownRect = CGRectMake(0, self.h_, self.w_, contentViewH);
    _contentView.frame = _contentViewUpRect;
    _cancleBtn.frame = CGRectMake(0, contentViewH - sheetH, _contentView.w_, sheetH);
    [_cancleBtn setTitleColor:LTSureFontBlue forState:UIControlStateNormal];
    _cancleBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    
    UIView *line=[[UIView alloc]init];
    line.frame=CGRectMake(0, _cancleBtn.y_-8, _contentView.w_,8);
    line.backgroundColor=LTBgColor;
    [_contentView addSubview:line];
    line=nil;
    
    NSInteger i;
    for (i = 0; i < mosCount; i ++) {
        [self addSheet:i];
        UIButton *btn =[_contentView viewWithTag:LTSheetTag + i];
        btn.titleLabel.font=[UIFont systemFontOfSize:15];
    }

    
}
- (void)configCancleTitle:(NSString *)cancle{
    if (notemptyStr(cancle)) {
        [_cancleBtn setTitle:cancle forState:UIControlStateNormal];
    }
}


static CGFloat animateDuration = 0.3;
- (void)showView:(BOOL)show {
    
    WS(ws);
    if (show) {
        NFCPost_FloatingPlayHide;
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

@end
