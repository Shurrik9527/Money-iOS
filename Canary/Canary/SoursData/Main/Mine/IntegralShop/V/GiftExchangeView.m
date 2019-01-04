//
//  GiftExchangeView.m
//  ixit
//
//  Created by litong on 2016/12/21.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "GiftExchangeView.h"
#import "UIImageView+WebCache.h"
#import "UIView+LTGesture.h"

#define GEView0H    48          //优惠券
#define GEView1H    60          //兑换数量
#define GEView2H    60          //我的积分
#define GEView3H    60          //总计积分

static CGFloat addBtnWH = 36;

@interface GiftExchangeView ()
{
    CGFloat tLabW;
    CGFloat subLabX;
    CGFloat selNum;
}

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIImageView *icon;//优惠券图片
@property (nonatomic,strong) UILabel *titleLab;//优惠券名称
@property (nonatomic,strong) UILabel *selNumLab;//兑换数量
@property (nonatomic,strong) UILabel *myIntegralLab;//我的积分13,823
@property (nonatomic,strong) UILabel *allIntegralTitleLab;//总计积分
@property (nonatomic,strong) UILabel *useRealIntegralLab;//折后180,000
@property (nonatomic,strong) UILabel *useIntegralLab;//无折扣200,000
@property (nonatomic,strong) UILabel *discountLab;//V3会员9折


@end

@implementation GiftExchangeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        selNum = 1;
        tLabW = LTAutoW(65);
        subLabX = LTAutoW(kLeftMar+65+20);
        self.backgroundColor = LTMaskColor;
        [self createView];
    }
    return self;
}

- (void)createView {
    
    [self addSingeTap:@selector(bgAction) target:self];
    
    
    CGFloat y0 = self.h_ - LTAutoW(GiftExchangeViewH);
    self.contentView = [self view:y0 h:GiftExchangeViewH bgColor:LTWhiteColor];
    [self addSubview:_contentView];
    [_contentView addSingeTap:@selector(tempAciton) target:self];
    
    //优惠券
    UIView *view0 = [self view:0 h:GEView0H bgColor:LTBgColor];
    [_contentView addSubview:view0];
    
    self.icon = [[UIImageView alloc] init];
    _icon.frame = LTRectAutoW(kLeftMar, 8, 72, 32);
    [view0 addSubview:_icon];
    
    self.titleLab = [self lab:CGRectMake(_icon.xw_+LTAutoW(16), 0, LTAutoW(150), view0.h_) fontSize:15 color:LTTitleColor];
    [view0 addSubview:_titleLab];
    
    //兑换数量
    UIView *view1 = [self view:view0.yh_ h:GEView1H bgColor:LTWhiteColor];
    [_contentView addSubview:view1];
    [self addLineView:view1.yh_];
    
    UILabel *excNumLab = [self lab:CGRectMake(LTAutoW(kLeftMar), 0, tLabW, view1.h_) fontSize:15 color:LTSubTitleColor];
    excNumLab.text = @"兑换张数";
    [view1 addSubview:excNumLab];
    
    CGFloat selNumIVW = LTAutoW(160);
    CGFloat selNumIVH = LTAutoW(36);
    UIImageView *selNumIV = [[UIImageView alloc] init];
    selNumIV.frame = CGRectMake(subLabX, (view1.h_ - selNumIVH)*0.5, selNumIVW, selNumIVH);
    selNumIV.image = [UIImage imageNamed:@"GE_SelNum"];
    selNumIV.userInteractionEnabled = YES;
    [view1 addSubview:selNumIV];
    
    CGFloat minusWH = LTAutoW(addBtnWH);
    UIButton *minusBtn = [self btn:0 sel:@selector(minusAction)];
    [selNumIV addSubview:minusBtn];
    
    UIButton *addBtn = [self btn:(selNumIVW - minusWH) sel:@selector(addAction)];
    [selNumIV addSubview:addBtn];
    
  self.selNumLab = [self lab:CGRectMake(minusWH, 0, selNumIVW - 2*minusWH, minusWH) fontSize:17 color:LTTitleColor];
    _selNumLab.textAlignment = NSTextAlignmentCenter;
    _selNumLab.text = [NSString stringWithInteger:selNum];
    [selNumIV addSubview:_selNumLab];
    
    
    
    
    //我的积分
    UIView *view2 = [self view:view1.yh_ h:GEView2H bgColor:LTWhiteColor];
    [_contentView addSubview:view2];
    [self addLineView:view2.yh_];
    
    UILabel *myLab = [self lab:CGRectMake(LTAutoW(kLeftMar), 0, tLabW, view2.h_) fontSize:15 color:LTSubTitleColor];
    myLab.text = @"我的积分";
    [view2 addSubview:myLab];
    
    self.myIntegralLab = [self lab:CGRectMake(subLabX, 0, LTAutoW(200), view2.h_) fontSize:17 color:LTTitleColor];
    [view2 addSubview:_myIntegralLab];
    
    
    
    
    //总计积分
    UIView *view3 = [self view:view2.yh_ h:GEView3H bgColor:LTWhiteColor];
    [_contentView addSubview:view3];
    
    self.allIntegralTitleLab = [self lab:CGRectMake(LTAutoW(kLeftMar), LTAutoW(12), tLabW, LTAutoW(15)) fontSize:15 color:LTSubTitleColor];
    _allIntegralTitleLab.text = @"总计积分";
    [view3 addSubview:_allIntegralTitleLab];
    
    self.useRealIntegralLab = [self lab:CGRectMake(subLabX, LTAutoW(11), LTAutoW(150), LTAutoW(20)) fontSize:20 color:LTKLineRed];
    [view3 addSubview:_useRealIntegralLab];
    
    self.useIntegralLab = [[UILabel alloc] init];
    _useIntegralLab.font = autoFontSiz(12);
    _useIntegralLab.textColor = LTSubTitleColor;
    [view3 addSubview:_useIntegralLab];
    
    UIColor *discountColor = LTColorHex(0xFF7901);
    self.discountLab = [[UILabel alloc] init];
    _discountLab.font = autoFontSiz(11);
    _discountLab.textColor = discountColor;
    _discountLab.textAlignment = NSTextAlignmentCenter;
    [_discountLab layerRadius:3 borderColor:discountColor borderWidth:0.5];
    [view3 addSubview:_discountLab];
    
    
    CGFloat btnW = LTAutoW(90);
    CGFloat btnH = view3.h_;
    
    UIButton *exchangeBtn = [UIButton btnWithTarget:self action:@selector(exchangeAction) frame:CGRectMake(ScreenW_Lit - btnW, 0, btnW, btnH)];
    exchangeBtn.backgroundColor = LTSureFontBlue;
    [exchangeBtn setTitle:@"兑换" forState:UIControlStateNormal];
    [exchangeBtn setTitleColor:LTWhiteColor forState:UIControlStateNormal];
    exchangeBtn.titleLabel.font = autoFontSiz(17);
    [view3 addSubview:exchangeBtn];
    
    self.hidden = YES;
}



#pragma mark - action

- (void)bgAction {
    [self showView:NO];
}

- (void)tempAciton{}

- (void)exchangeAction {
    [self showView:NO];
    
//    _giftExchangeBlock ? _giftExchangeBlock(_mo.giftId,selNum,_mo.excode) : nil;
    _giftExchangeBlock ? _giftExchangeBlock(_mo,selNum) : nil;
}


- (void)minusAction {
    if (selNum < 2) {
        _giftExShowTipBlock ? _giftExShowTipBlock(@"不能再减了") : nil;
        return;
    }
    
    selNum-=1;
    [self configPrice];
}
- (void)addAction {
    selNum+=1;
    [self configPrice];
}

- (void)configPrice {
    _selNumLab.text = [NSString stringWithInteger:selNum];
    
    CGFloat rebateRatef = [_integralMo.rebateRate floatValue];
    CGFloat usePoint = [_mo.poins floatValue];//1张券面值
    CGFloat allPrice = selNum * usePoint;//价格
    CGFloat realPrice = rebateRatef * allPrice;//折后价格
    
    if ([_integralMo.levelNum integerValue] == 1) {
        
        NSNumber *realNP = [NSNumber numberWithFloat:realPrice];
        NSString *realNPStr = [realNP numberDecimalFmt];
        _useRealIntegralLab.text = realNPStr;
        
    } else {
        NSNumber *realNP = [NSNumber numberWithFloat:realPrice];
        NSString *realNPStr = [realNP numberDecimalFmt];
        _useRealIntegralLab.text = realNPStr;
        
        NSNumber *allNP = [NSNumber numberWithFloat:allPrice];
        NSString *allNPStr = [allNP numberDecimalFmt];
        NSAttributedString *ABStr = [allNPStr ABStrStrikethrough];
        
        CGFloat h = LTAutoW(12);
        CGSize size = [ABStr autoSize:CGSizeMake(MAXFLOAT, h)];
        _useIntegralLab.frame = CGRectMake(subLabX, _useRealIntegralLab.yh_+LTAutoW(6), size.width+5, h);
        _useIntegralLab.attributedText = ABStr;
        
        //V3会员9折
        CGFloat discountLabH = LTAutoW(16);
        NSString *discountStr = _integralMo.vipLevelName_fmt;
        _discountLab.text = discountStr;
        CGSize discountSize = [discountStr boundingSize:CGSizeMake(MAXFLOAT, discountLabH) font:autoFontSiz(11)];

        _discountLab.frame = CGRectMake(_useIntegralLab.xw_ + LTAutoW(6), _useRealIntegralLab.yh_ + LTAutoW(5), discountSize.width+10, discountLabH);
    }
    

}

#pragma mark - utils

- (UIView *)view:(CGFloat)y  h:(CGFloat)h bgColor:(UIColor *)bgColor {
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, y, ScreenW_Lit, LTAutoW(h));
    view.backgroundColor = bgColor;
    return view;
}

- (UILabel *)lab:(CGRect)frame fontSize:(CGFloat)fontSize color:(UIColor *)color {
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = frame;
    lab.font = autoFontSiz(fontSize);
    lab.textColor = color;
    return lab;
}

- (void)addLineView:(CGFloat)y {
    UIView *lineView = [[UIView alloc] init] ;
    lineView.frame = CGRectMake(0, y-0.5, ScreenW_Lit, 0.5);
    lineView.backgroundColor = LTLineColor;
    [_contentView addSubview:lineView];
}

- (UIButton *)btn:(CGFloat)x sel:(SEL)sel {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(x, 0, LTAutoW(addBtnWH), LTAutoW(addBtnWH));
    btn.backgroundColor = LTClearColor;
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - 外部

- (void)setMo:(GiftMO *)mo {
    _mo = mo;
    selNum = 1;
    //优惠券图片
    [_icon sd_setImageWithURL:[mo.giftSmallPic toURL] placeholderImage:[UIImage imageNamed:@"Shop_pic_def"]];
    //哈贵所200元代金券
    self.titleLab.text = mo.giftName;

}

- (void)setIntegralMo:(IntegralMo *)integralMo {
    _integralMo = integralMo;
    
    //我的积分13,823
    self.myIntegralLab.text = _integralMo.validPoints_fmt1;
    
    if ([_integralMo.levelNum integerValue] == 1) {
        self.useIntegralLab.hidden = YES;
        self.discountLab.hidden = YES;
    
        _allIntegralTitleLab.frame = CGRectMake(LTAutoW(kLeftMar), 0, tLabW, LTAutoW(GEView3H));
        _useRealIntegralLab.frame = CGRectMake(subLabX, 0, LTAutoW(150), LTAutoW(GEView3H));
    } else {
        self.useIntegralLab.hidden = NO;
        self.discountLab.hidden = NO;
        
        _allIntegralTitleLab.frame = CGRectMake(LTAutoW(kLeftMar), LTAutoW(12), tLabW, LTAutoW(15));
        _useRealIntegralLab.frame = CGRectMake(subLabX, LTAutoW(11), LTAutoW(150), LTAutoW(20));
    }
    
    [self configPrice];
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
    
    if (bl) {
        CGFloat y = self.h_ - LTAutoW(GiftExchangeViewH);
        _contentView.frame = CGRectMake(0, y, ScreenW_Lit, LTAutoW(GiftExchangeViewH));
    } else {
        _contentView.frame = CGRectMake(0, self.h_, ScreenW_Lit, LTAutoW(GiftExchangeViewH));
    }
}


@end
