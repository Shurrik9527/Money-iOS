//
//  ProductCell.m
//  Canary
//
//  Created by litong on 2017/5/26.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "ProductCell.h"

#define kTempH        8
#define kTabH           40
#define kContentH    90


@interface ProductCell ()

@property (nonatomic,strong) ProductMO *mo;

@property (nonatomic,strong) UILabel *nameLab;//产品名称
@property (nonatomic,strong) UILabel *closeMarkLab;//休市中
@property (nonatomic,strong) UILabel *pointDiffLab;//点差

@property (nonatomic,strong) UIButton *questionBtn;
@property (nonatomic,strong) UIImageView *questionBgIV;
@property (nonatomic,strong) UILabel *questionLab;

@property (nonatomic,strong) UILabel *sellLab;//卖出价
@property (nonatomic,strong) UILabel *buyLab;//买入价
@property (nonatomic,strong) UILabel *buyUpLab;//买涨人数比例%
@property (nonatomic,strong) UILabel *buyDownLab;//买跌人数比例%

@property (nonatomic,strong) UIButton *buyUpBtn;//买涨人数
@property (nonatomic,strong) UIButton *buyDownBtn;//买跌人数


@end

@implementation ProductCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = LTBgColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createCell];
    }
    return self;
}

- (void)createCell {

    UIView *tabView = [UIView lineFrame:CGRectMake(0, kTempH, ScreenW_Lit, kTabH) color:LTWhiteColor];
    [self addSubview:tabView];
    
    //产品名称
    self.nameLab = [self lab:CGRectMake(kLeftMar, 0, 0, kTabH) font:boldFontSiz(15) color:LTTitleColor];
    [tabView addSubview:_nameLab];
    
    CGFloat closeMarkW = 50;
    CGFloat closeMarkH = 20;
    self.closeMarkLab = [self lab:CGRectMake(0, (kTabH - closeMarkH)*0.5, closeMarkW, closeMarkH) font:fontSiz(10) color:LTSubTitleColor];
    [_closeMarkLab layerRadius:1.f bgColor:LTBgColor];
    _closeMarkLab.hidden = YES;
    _closeMarkLab.text = @"休市中";
    _closeMarkLab.textAlignment = NSTextAlignmentCenter;
    [tabView addSubview:_closeMarkLab];
    
    //点差
    CGFloat pointDiffLabW = ScreenW_Lit*0.4;
    CGRect pointDiffFrame = CGRectMake(ScreenW_Lit - kLeftMar - pointDiffLabW, 0, pointDiffLabW, kTabH);
    self.pointDiffLab = [self lab:pointDiffFrame font:fontSiz(14) color:LTSubTitleColor];
    _pointDiffLab.textAlignment = NSTextAlignmentRight;
    [tabView addSubview:_pointDiffLab];
    
    
    CGRect rect = CGRectMake(ScreenW_Lit - 80 - kTabH, 0, kTabH, kTabH);
    self.questionBtn = [UIButton btnWithTarget:self action:@selector(questionBtnAction) frame:rect];
    [_questionBtn setNorImageName:@"icon_question"];
    [tabView addSubview:_questionBtn];
    
    CGFloat bgivw = 282;
    CGFloat bgivh = 80;
    if (ScreenW_Lit <=320) {
        bgivw = 200;
        bgivh = 80;
    }
    self.questionBgIV = [[UIImageView alloc] init];
    _questionBgIV.frame = CGRectMake(0, _nameLab.yh_+5, bgivw, bgivh);
    _questionBgIV.image = [[UIImage imageNamed:@"bg_question"] stretchMiddle];
    _questionBgIV.hidden = YES;
    _questionBgIV.userInteractionEnabled = YES;
    [self addSubview:_questionBgIV];
    
    
    CGFloat qlabx = 10;
    CGFloat qlaby = 6;
    CGRect frame = CGRectMake(qlabx, qlaby, bgivw - 2*qlabx, bgivh - qlaby);
    UILabel *questionLab = [UILabel labRect:frame font:autoFontSiz(15) textColor:LTSubTitleColor];
    questionLab.text = @"点差是买涨价和买跌价的差额，是交易成本。点差会随着汇率波动或交易量大小等原因产生浮动。";
    questionLab.numberOfLines = 0;
    [_questionBgIV addSubview:questionLab];
    [questionLab addSingeTap:@selector(questionBgAction) target:self];
    
    
    UIView *lineView = [UIView lineFrame:CGRectMake(0, kTabH-0.5, ScreenW_Lit, 0.5) color:LTLineColor];
    [tabView addSubview:lineView];
    
    
    UIView *contentView = [UIView lineFrame:CGRectMake(0, tabView.yh_, ScreenW_Lit, kContentH) color:LTWhiteColor];
    [self addSubview:contentView];
    
    CGFloat sellY = 8;
    CGFloat mid = 20;
    CGFloat priceH = 36;
    CGFloat priceW = (kMidW - mid)*0.5;
    
    //买入价 涨
    self.buyLab = [self lab:CGRectMake(kLeftMar, sellY, priceW, priceH) font:boldFontSiz(20) color:LTTitleColor];
    _buyLab.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:_buyLab];
    
    //卖出价 跌
    self.sellLab = [self lab:CGRectMake(ScreenW_Lit - kLeftMar - priceW, sellY, priceW, priceH) font:boldFontSiz(20) color:LTTitleColor];
    _sellLab.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:_sellLab];
    
    
    CGFloat btnH = 33;
    CGFloat btnW = priceW + mid - 5;
    //买涨人数
    self.buyUpBtn = [UIButton btnWithTarget:self action:@selector(buyUpAction) frame:CGRectMake(kLeftMar, _buyLab.yh_, btnW, btnH)];
    [_buyUpBtn setNorBGImage:[UIImage imageNamed:@"buyLeft_red"]];
    [_buyUpBtn setSelBGImage:[UIImage imageNamed:@"buyLeft_gray"]];
    [contentView addSubview:_buyUpBtn];
    //买涨人数比例%
    self.buyUpLab = [self lab:CGRectMake(0, 0, priceW, btnH) font:fontSiz(15) color:LTWhiteColor];
    _buyUpLab.textAlignment = NSTextAlignmentCenter;
    _buyUpLab.userInteractionEnabled = YES;
    [_buyUpBtn addSubview:_buyUpLab];
    [self.buyUpLab addSingeTap:@selector(buyUpAction) target:self];
    
    //买跌人数
    self.buyDownBtn = [UIButton btnWithTarget:self action:@selector(buyDownAction) frame:CGRectMake(ScreenW_Lit - kLeftMar - btnW, _buyLab.yh_, btnW, btnH)];
    [_buyDownBtn setNorBGImage:[UIImage imageNamed:@"buyRight_green"]];
    [_buyDownBtn setSelBGImage:[UIImage imageNamed:@"buyRight_gray"]];
    [contentView addSubview:_buyDownBtn];
    //买跌人数比例%
    self.buyDownLab = [self lab:CGRectMake(mid, 0, priceW, btnH) font:fontSiz(15) color:LTWhiteColor];
    _buyDownLab.textAlignment = NSTextAlignmentCenter;
    _buyDownLab.userInteractionEnabled = YES;
    [_buyDownBtn addSubview:_buyDownLab];
    [self.buyDownLab addSingeTap:@selector(buyDownAction) target:self];

    UIColor *color = LTWhiteColor;
    self.buyUpLab.textColor = color;
    self.buyDownLab.textColor = color;
    
    [self bringSubviewToFront:_questionBgIV];
}

#pragma mark - action

- (void)questionBtnAction {
    BOOL sel = !_questionBtn.selected;;
    _questionBtn.selected = sel;
    self.questionBgIV.hidden = !sel;
}

- (void)questionBgAction {
    _questionBtn.selected = NO;
    self.questionBgIV.hidden = YES;
}

- (void)buyUpAction {
    [self questionBgAction];
    
    if (_mo.closed) {
        return;
    }
    
    if (_buyProductBlock) {
        _buyProductBlock(_mo, YES);
    }
    
}

- (void)buyDownAction {
    [self questionBgAction];
    if (_mo.closed) {
        return;
    }
    if (_buyProductBlock) {
        _buyProductBlock(_mo, NO);
    }
}

#pragma mark - utils

- (UILabel *)lab:(CGRect)frame font:(UIFont *)font color:(UIColor *)color {
    UILabel *lab = [[UILabel alloc] initWithFrame:frame];
    lab.font = font;
    lab.textColor = color;
    return lab;
}

#pragma mark - 外部

- (void)bindData:(ProductMO *)mo {
    self.mo = mo;
    
    //产品名称
    NSString *name = mo.name;
    CGSize siz = [name boundingW:15 font:fontSiz(15)];
    _nameLab.text = name;
    [_nameLab setSW:(siz.width+10)];
    
    //休市中
    BOOL closing = [mo closed];
    _closeMarkLab.hidden = !closing;
    [_closeMarkLab setOX:(_nameLab.xw_)];

    //点差
    NSString *pointDiffStr = [NSString stringWithFormat:@"点差：%@",mo.pointDiff];
    self.pointDiffLab.text = pointDiffStr;
    
    //问号相关
    CGSize pointDiffSize = [pointDiffStr boundingW:14 font:fontSiz(14)];
    CGFloat pointDiffW = pointDiffSize.width;
    [_questionBtn setOX:(ScreenW_Lit - kLeftMar - pointDiffW - kTabH + 5)];
    CGFloat qx = 260;
    if (ScreenW_Lit <=320) {
        qx = 178;
    }
    [_questionBgIV setOX:(_questionBtn.center.x - qx)];
    
    //卖出价
    self.sellLab.text = [mo sell_fmt];
    //买入价
    self.buyLab.text = [mo buy_fmt];
    
    //人数比例%
    self.buyUpLab.attributedText = [mo buyUpRate_fmtABStr];
    self.buyDownLab.attributedText = [mo buyDownRate_fmtABStr];
    
    self.buyUpBtn.selected = closing;
    self.buyDownBtn.selected = closing;
}

+ (CGFloat)cellH {
    return kTempH + kTabH + kContentH;
}


@end
