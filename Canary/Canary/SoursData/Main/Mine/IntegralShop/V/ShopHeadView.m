//
//  ShopHeadView.m
//  ixit
//
//  Created by litong on 2016/12/19.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "ShopHeadView.h"
#import "LTWebCache.h"
#import "UIView+LTGesture.h"

@interface ShopHeadView ()

/** banner，可能不存在 */
@property (nonatomic,strong) UIImageView *bannerView;
@property (nonatomic,strong) InviteFriendsInfo *inviteFriendsInfo;

/** 我的积分，卡片样式 */
@property (nonatomic,strong) UIView *cardContentView;
@property (nonatomic,strong) UIImageView *cardView;//卡片背景
@property (nonatomic,strong) UILabel *numLab;//13,838
@property (nonatomic,strong) UILabel *rankLab;//打败89.3%的八元用户
@property (nonatomic,strong) UILabel *discountLab;//我的会员等级..9折优惠
@property (nonatomic,strong) UIImageView *vipIV;//会员等级
@property (nonatomic,strong) UILabel *vipDiscountLab;//优惠折扣

/** 积分兑换Bar */
@property (nonatomic,strong) UIView *exchangeBar;

@end

@implementation ShopHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}


- (void)createView {
    [self createBannerView];
    [self createCardView];
    [self createExchangeBar];
}

/** banner，可能不存在 */
- (void)createBannerView {
    self.bannerView = [[UIImageView alloc] init];
    _bannerView.frame = CGRectZero;
    _bannerView.userInteractionEnabled = YES;
    [self addSubview:_bannerView];
    [_bannerView addSingeTap:@selector(clickBanner) target:self];
    
//    UIButton *btn = [UIButton btnWithTarget:self action:@selector(clickBanner) frame:CGRectMake(0, 0, _bannerView.w_, _bannerView.h_)];
//    btn.backgroundColor = [UIColor clearColor];
//    [_bannerView addSubview:btn];
}

static CGFloat cardViewH = 195;//188
/** 我的积分，卡片样式 */
- (void)createCardView {
    
    self.cardContentView = [[UIView alloc] init];
    _cardContentView.frame = CGRectMake(0, _bannerView.yh_, ScreenW_Lit, LTAutoW(MyIntegralViewH));
    [self addSubview:_cardContentView];
    
    CGFloat leftMar = LTAutoW(kLeftMar);
    CGFloat cardViewW = ScreenW_Lit - 2*leftMar;
    self.cardView = [[UIImageView alloc] init];
    _cardView.frame = CGRectMake(leftMar, LTAutoW(24), cardViewW, LTAutoW(cardViewH));
    _cardView.image = [UIImage imageNamed:@"shop_pic_background"];
    _cardView.userInteractionEnabled = YES;
    [_cardContentView addSubview:_cardView];
    
    CGFloat labW = LTAutoW(150);
    CGFloat labX = (cardViewW - labW)*0.5;
    UILabel *myNumLab = [self lab:CGRectMake(labX, LTAutoW(22), labW, LTAutoW(12)) fontSize:12 color:LTColorHexA(0xffffff, 0.8)];
    myNumLab.textAlignment = NSTextAlignmentCenter;
    myNumLab.text = @"我的积分";
    [_cardView addSubview:myNumLab];
    
    
    self.numLab = [self lab:CGRectMake(0, myNumLab.yh_ + LTAutoW(8), cardViewW, LTAutoW(34)) fontSize:34 color:LTWhiteColor];
    _numLab.textAlignment = NSTextAlignmentCenter;
    [_cardView addSubview:_numLab];
    
    self.rankLab = [self lab:CGRectMake(labX, _numLab.yh_ + LTAutoW(12), labW, LTAutoW(12)) fontSize:12 color:LTColorHexA(0xffffff, 0.8)];
    _rankLab.textAlignment = NSTextAlignmentCenter;
    [_cardView addSubview:_rankLab];
    
    CGFloat lookDetailsBtnW = LTAutoW(65);
    UIButton *lookDetailsBtn = [UIButton btnWithTarget:self action:@selector(lookDetailsAction) frame:CGRectMake(cardViewW - lookDetailsBtnW, LTAutoW(16), lookDetailsBtnW, LTAutoW(26))];
    [lookDetailsBtn setBackgroundImage:[UIImage imageNamed:@"shopDetailBtn"] forState:UIControlStateNormal];
    [_cardView addSubview:lookDetailsBtn];
    
    CGFloat discountLabX = LTAutoW(42);
    CGFloat discountLabW = cardViewW - 2*discountLabX;
    self.discountLab = [self lab:CGRectMake(discountLabX, _rankLab.yh_ + LTAutoW(18), discountLabW, LTAutoW(36)) fontSize:12 color:LTTitleColor];
    _discountLab.textAlignment = NSTextAlignmentCenter;
    [_cardView addSubview:_discountLab];
    
    self.vipIV = [[UIImageView alloc] init];
    [_cardView addSubview:_vipIV];
    
    self.vipDiscountLab = [self lab:CGRectMake(LTAutoW(230), _discountLab.y_-LTAutoW(1.5), LTAutoW(33), _discountLab.h_) fontSize:17 color:LTColorHex(0xFF7901)];
    _vipDiscountLab.textAlignment = NSTextAlignmentCenter;
    _vipDiscountLab.font = autoBoldFontSiz(17);
    _vipDiscountLab.backgroundColor = LTClearColor;
    [_cardView addSubview:_vipDiscountLab];
}

/** 积分兑换Bar */
- (void)createExchangeBar {
    self.exchangeBar = [[UIView alloc] init];
    _exchangeBar.frame = CGRectMake(0, _cardContentView.yh_, ScreenW_Lit, LTAutoW(IntegralExchangeBarH));
    _exchangeBar.backgroundColor = LTBgColor;
    [self addSubview:_exchangeBar];
    
    
    CGFloat exLabW = LTAutoW(100);
    UILabel *excLab = [self lab:CGRectMake(LTAutoW(kLeftMar), 0, exLabW, _exchangeBar.h_) fontSize:15 color:LTTitleColor];
    excLab.text = @"积分兑换";
    [_exchangeBar addSubview:excLab];
    
    [self exchangeBarAddBlueHline];//颜色条
    
    CGFloat excHisBtnW = LTAutoW(92);
    UIButton *excHisBtn = [UIButton btnWithTarget:self action:@selector(excHisAction) frame:CGRectMake(_exchangeBar.w_ - excHisBtnW, 0, excHisBtnW, _exchangeBar.h_)];
    [excHisBtn setTitle:@"兑换历史 >" forState:UIControlStateNormal];
    [excHisBtn setTitleColor:LTSubTitleColor forState:UIControlStateNormal];
    excHisBtn.titleLabel.font = autoFontSiz(12);
    [_exchangeBar addSubview:excHisBtn];
}


#pragma mark - action

- (void)excHisAction {
    _myExchangeHistoryBlock ? _myExchangeHistoryBlock() : nil;
}

- (void)lookDetailsAction {
    _lookIntegralDetailsBlock ? _lookIntegralDetailsBlock() : nil;
}

- (void)clickBanner {
    _lookBannerDetailsBlock ? _lookBannerDetailsBlock(_inviteFriendsInfo) : nil;
}

#pragma mark - utils

- (void)exchangeBarAddBlueHline {
    CGFloat w = LTAutoW(4);
    CGFloat h = LTAutoW(20);
    
    UIView *lineView = [[UIView alloc] init] ;
    lineView.frame = CGRectMake(0, (_exchangeBar.h_ - h)*0.5, w, h);
    lineView.backgroundColor = LTSureFontBlue;
    [_exchangeBar addSubview:lineView];
}

- (UILabel *)lab:(CGRect)frame fontSize:(CGFloat)fontSize color:(UIColor *)color {
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = frame;
    lab.font = autoFontSiz(fontSize);
    lab.textColor = color;
    return lab;
}


#pragma mark - 外部

#define vipColors @[@"FF9F01",\
                                 @"FF9F01",@"FF7901",@"FF5101",\
                                 @"FF3A01",@"FF0000",@"FF006A"]

- (void)refView:(IntegralMo *)mo {
    //13,838
    self.numLab.text = mo.validPoints_fmt1;
    //打败89.3%的八元用户
    self.rankLab.text = mo.pointsRanking_fmt;
    //会员等级
    self.vipIV.image = [UIImage imageNamed:mo.levelImgName];
    
    
    if ([mo.levelNum integerValue] == 1) {
        _discountLab.text = @"我的会员等级        积分商城无优惠";
        _vipIV.frame = CGRectMake(LTAutoW(155), LTAutoW(123), LTAutoW(20), LTAutoW(23));
        
    } else {
        _discountLab.text = @"我的会员等级        可享受积分商城        折优惠";
        _vipIV.frame = CGRectMake(LTAutoW(123), LTAutoW(123), LTAutoW(20), LTAutoW(23));
        //9折优惠
        self.vipDiscountLab.text = mo.rebateRate_fmt;
        NSInteger lv = [mo.levelNum integerValue] - 1;
        if (lv < 0) {
            return;
        }
        NSString *colorStr = vipColors[lv];
        self.vipDiscountLab.textColor = LTColorHexString(colorStr);
    }

}

- (void)addBanner:(InviteFriendsInfo *)inviteFriendsInfo {
    self.inviteFriendsInfo = inviteFriendsInfo;
    NSString *imgUrl = inviteFriendsInfo.pic;
    if (emptyStr(imgUrl)) {
        return;
    }
    
    [self setSH:LTAutoW(ShopHeadViewH1)];
    _bannerView.frame = CGRectMake(0, 0, ScreenW_Lit, LTAutoW(ShopBannerViewH));
    
    [_cardContentView setSH:LTAutoW(MyIntegralViewH1)];
    _cardView.frame = CGRectMake(LTAutoW(kLeftMar), LTAutoW(16), _cardView.w_, LTAutoW(cardViewH));
    [_bannerView lt_setImageWithURL:imgUrl placeholderImage:nil];
    WS(ws);
    [UIView animateWithDuration:0.3 animations:^{
        [ws.cardContentView setOY:ws.bannerView.yh_];
        [ws.exchangeBar setOY:ws.cardContentView.yh_];
    }];
    

    
    
}

@end
