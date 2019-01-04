//
//  GainBtmView.m
//  ixit
//
//  Created by litong on 2016/11/14.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "GainBtmView.h"
#import "UIImageView+WebCache.h"
#import "UIView+LTAnimation.h"

static CGFloat headWH = 36.f;

static CGFloat headWH0 = 28.f;
static CGFloat headWH1 = 24.f;
static CGFloat headWH2 = 20.f;
static CGFloat headWH3 = 16.f;

static CGFloat headAlpha0 = 1.f;
static CGFloat headAlpha1 = 0.8f;
static CGFloat headAlpha2 = 0.6f;
static CGFloat headAlpha3 = 0.0f;

@interface GainBtmView ()

/**  */
@property (nonatomic,strong) UIView *logoutView;
/**  */
@property (nonatomic,strong) UIView *outTopView;
/**  */
@property (nonatomic,strong) UIView *inTopView;
@property (nonatomic,strong) UIImageView *iv3;
@property (nonatomic,strong) UIImageView *iv2;
@property (nonatomic,strong) UIImageView *iv1;
@property (nonatomic,strong) UIImageView *iv0;
@property (nonatomic,strong) UILabel *showGianNumLab;

@property (nonatomic,strong) UIImageView *iv;
@property (nonatomic,strong) UILabel *myNumLab;


@property (nonatomic,strong) UIButton *showGainBtn;

@end

@implementation GainBtmView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}



- (void)createView {
    
    UIImageView *bgIV = [[UIImageView alloc] init];
    bgIV.frame = CGRectMake(0, LTAutoW(6), ScreenW_Lit, LTAutoW(62.f));
    bgIV.image = [UIImage imageNamed:@"GainBtmBg"];
    bgIV.userInteractionEnabled = YES;
    [self addSubview:bgIV];
    
    [self createOutTopView];
    [self createInTopView];
    [self createLogoutView];
    
    CGFloat btnWH = LTAutoW(64.f);
    CGRect r = CGRectMake(self.w_ - LTAutoW(12.f) - btnWH, 0, btnWH, btnWH);
    self.showGainBtn = [UIButton btnWithTarget:self action:@selector(clickShowGainBtn) frame:r];
    _showGainBtn.hidden = YES;
    [_showGainBtn setNorBGImageName:@"showGainBtn"];
    [self addSubview:_showGainBtn];
    
    self.typ = GainBtmViewType_logout;
}

- (void)createLogoutView {
    self.logoutView = [[UIView alloc] init];
    _logoutView.frame = CGRectMake(0, LTAutoW(GainBtmTempH), ScreenW_Lit, LTAutoW(GainBtmViewH));
    [self addSubview:_logoutView];
    
    UILabel *logoutLab = [[UILabel alloc] init];
    logoutLab.frame = CGRectMake(LTAutoW(kLeftMar), 0, 160.f, _logoutView.h_);
    logoutLab.font = autoBoldFontSiz(15.f);
    logoutLab.textColor = LTTitleColor;
    logoutLab.text = @"登录后可晒单上榜";
    [_logoutView addSubview:logoutLab];
    
    CGFloat btnW = LTAutoW(80.f);
    CGFloat btnH = LTAutoW(32.f);
    UIButton *logoutBtn = [UIButton btnWithTarget:self action:@selector(clickLoginBtn) frame:CGRectMake(_logoutView.w_ - LTAutoW(kLeftMar) - btnW, (_logoutView.h_ - btnH)/2.0, btnW, btnH)];
    [logoutBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:LTWhiteColor forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = autoFontSiz(12.f);
    [logoutBtn layerRadius:3.f bgColor:LTColorHex(0x3A69E3)];
    [_logoutView addSubview:logoutBtn];
}

- (void)createOutTopView {
    self.outTopView = [[UIView alloc] init];
    _outTopView.frame = CGRectMake(0, LTAutoW(GainBtmTempH), ScreenW_Lit, LTAutoW(GainBtmViewH));
    [self addSubview:_outTopView];
    
    CGFloat ivWH = LTAutoW(32.f);
    UIImageView *iv = [[UIImageView alloc] init];
    iv.frame = CGRectMake(LTAutoW(12.f), (_outTopView.h_ - ivWH)/2.0, ivWH, ivWH);
    [iv sd_setImageWithURL:[UD_Avatar toURL] placeholderImage:[UIImage imageNamed:@"Head80"]];
    [iv circleViwe];
    [_outTopView addSubview:iv];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(iv.xw_ + LTAutoW(12.f), 0, 160.f, _outTopView.h_);
    lab.font = autoBoldFontSiz(15.f);
    lab.textColor = LTTitleColor;
    lab.text = @"立刻晒单，占据榜首";

    [_outTopView addSubview:lab];
}

- (void)createInTopView {
    self.inTopView = [[UIView alloc] init];
    _inTopView.frame = CGRectMake(0, LTAutoW(GainBtmTempH), ScreenW_Lit, LTAutoW(GainBtmViewH));
    [self addSubview:_inTopView];
    
    
    
    CGFloat ivWH3 = LTAutoW(headWH0-4);
    CGRect r3 = CGRectMake(LTAutoW(kLeftMar), [self viewy:headWH3], ivWH3, ivWH3);
    self.iv3 = [self imgView:r3];
    [_inTopView addSubview:_iv3];
    
    CGFloat ivWH2 = LTAutoW(headWH2);
    CGRect r2 = CGRectMake(LTAutoW(kLeftMar), [self viewy:headWH2], ivWH2, ivWH2);
    self.iv2 = [self imgView:r2];
    [_inTopView addSubview:_iv2];
    
    CGFloat ivWH1 = LTAutoW(headWH1);
    CGRect r1 = CGRectMake(_iv2.x_ + ivWH2/2.0, [self viewy:headWH1], ivWH1, ivWH1);
    self.iv1 = [self imgView:r1];
    [_inTopView addSubview:_iv1];
    
    CGFloat ivWH0 = LTAutoW(headWH0);
    self.iv0 = [self imgView:CGRectMake(_iv1.x_ + ivWH1/2.0, [self viewy:headWH0], ivWH0, ivWH0)];
    _iv0.alpha = 0;
    [_inTopView addSubview:_iv0];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(LTAutoW(80.f), LTAutoW(7.f), LTAutoW(72.f), LTAutoW(21.f));
    lab.font = autoFontSiz(12.f);
    lab.textColor = LTColorHex(0x969BA9);
    lab.text = @"晒单用户";
    [_inTopView addSubview:lab];
    
    self.showGianNumLab = [[UILabel alloc] init];
    _showGianNumLab.frame = CGRectMake(lab.x_, lab.yh_, LTAutoW(72.f), LTAutoW(21.f));
    _showGianNumLab.font = autoBoldFontSiz(15.f);
    _showGianNumLab.textColor = LTTitleColor;
    [_inTopView addSubview:_showGianNumLab];
    
    CGFloat lineLeft = LTAutoW(153.f);
    [_inTopView addLine:LTLineColor frame:CGRectMake(lineLeft, 0, 0.5, _inTopView.h_)];
    
    
    self.iv = [self imgCircleView:CGRectMake(lineLeft + LTAutoW(kLeftMar), [self viewy:headWH], LTAutoW(headWH), LTAutoW(headWH))];
    [_inTopView addSubview:_iv];
    
    
    UILabel *mylab = [[UILabel alloc] init];
    mylab.frame = CGRectMake(_iv.xw_ + LTAutoW(kLeftMar), LTAutoW(7.f), LTAutoW(72.f), LTAutoW(21.f));
    mylab.font = autoFontSiz(12.f);
    mylab.textColor = LTColorHex(0x969BA9);
    mylab.text = @"我的排名";
    [_inTopView addSubview:mylab];
    
    self.myNumLab = [[UILabel alloc] init];
    _myNumLab.frame = CGRectMake(mylab.x_, mylab.yh_, LTAutoW(72.f), LTAutoW(21.f));
    _myNumLab.font = autoBoldFontSiz(15.f);
    _myNumLab.textColor = LTTitleColor;
    _myNumLab.text = @"第15位";
    [_inTopView addSubview:_myNumLab];
}

- (UIImageView *)imgView:(CGRect)frame {
    UIImageView *iv = [[UIImageView alloc] init];
    iv.frame = frame;
    iv.image = [UIImage imageNamed:@"Head80"];
//    [iv layerRadius:frame.size.width/2.0 borderColor:LTYellowColor borderWidth:1.5];
    [iv circleViwe];
    iv.backgroundColor = LTWhiteColor;
    return iv;
}

- (UIImageView *)imgCircleView:(CGRect)frame {
    UIImageView *iv = [[UIImageView alloc] init];
    iv.frame = frame;
    iv.image = [UIImage imageNamed:@"Head80"];
    [iv circleViwe];
    iv.backgroundColor = LTWhiteColor;
    return iv;
}


- (CGFloat)viewy:(CGFloat)h {
    return LTAutoW((GainBtmViewH - h)/2.0);
}

/*
- (void)headAnimate1 {

    CGFloat ivWH3 = LTAutoW(headWH0-4);
    CGRect r3 = CGRectMake(LTAutoW(kLeftMar), [self viewy:headWH3], ivWH3, ivWH3);
    _iv3.frame = r3;

    CGFloat ivWH2 = LTAutoW(headWH0-2);
    CGRect r2 = CGRectMake(_iv3.x_ + ivWH3/2.0, [self viewy:headWH2], ivWH2, ivWH2);
    _iv2.frame = r2;
    
    CGFloat ivWH1 = LTAutoW(headWH0);
    CGRect r1 = CGRectMake(_iv2.x_ + ivWH2/2.0, [self viewy:headWH1], ivWH1, ivWH1);
    _iv1.frame = r1;
    
//    [_iv1 layerRadius:ivWH1/2.0 borderColor:LTWhiteColor borderWidth:2];
//    [_iv2 layerRadius:ivWH2/2.0 borderColor:LTWhiteColor borderWidth:2];
//    [_iv3 layerRadius:ivWH3/2.0 borderColor:LTWhiteColor borderWidth:2];
    
    _iv0.alpha = 0.f;
    _iv3.alpha = 1.f;
    [_iv0 circleViwe];
    [_iv1 circleViwe];
    [_iv2 circleViwe];
    [_iv3 circleViwe];

    [UIView animateWithDuration:1.6 animations:^{
        CGFloat ivWH2 = LTAutoW(headWH2);
        
        CGFloat ivWH3 = LTAutoW(headWH3);
        CGRect r3 = CGRectMake(LTAutoW(kLeftMar) - ivWH2/2.0, [self viewy:headWH3], ivWH3, ivWH3);
        _iv3.frame = r3;
        _iv3.alpha = headAlpha3;
        
        CGRect r2 = CGRectMake(LTAutoW(kLeftMar), [self viewy:headWH2], ivWH2, ivWH2);
        _iv2.frame = r2;
        _iv2.alpha = headAlpha2;
        
        CGFloat ivWH1 = LTAutoW(headWH1);
        CGRect r1 = CGRectMake(_iv2.x_ + ivWH2/2.0, [self viewy:headWH1], ivWH1, ivWH1);
        _iv1.frame = r1;
        _iv1.alpha = headAlpha1;
    
        _iv0.alpha = headAlpha0;

        
    } completion:^(BOOL finished) {
        [_iv0 circleViwe];
        [_iv1 circleViwe];
        [_iv2 circleViwe];
        [_iv3 circleViwe];
    }];
}
*/


- (void)headAnimate {
    
    _iv1.transform = CGAffineTransformIdentity;
    _iv2.transform = CGAffineTransformIdentity;
    _iv3.transform = CGAffineTransformIdentity;
    
    CGFloat ivWH3 = LTAutoW(headWH0-4);
    CGFloat ivWH2 = LTAutoW(headWH0-2);
    CGFloat ivWH1 = LTAutoW(headWH0);
    
    //下面frame 位置不要调换
    _iv3.frame = CGRectMake(LTAutoW(kLeftMar), [self viewy:headWH3]-LTAutoW(1), ivWH3, ivWH3);
    _iv2.frame = CGRectMake(_iv3.x_ + ivWH3/2.0, [self viewy:headWH2], ivWH2, ivWH2);
    _iv1.frame = CGRectMake(_iv2.x_ + ivWH2/2.0, [self viewy:headWH1], ivWH1, ivWH1);

    _iv0.alpha = 0.f;
    _iv1.alpha = 1.f;
    _iv2.alpha = 0.9f;
    _iv3.alpha = 0.8f;
    
    [_iv0 circleViwe];
    [_iv1 circleViwe];
    [_iv2 circleViwe];
    [_iv3 circleViwe];

    
    WS(ws);
    
    [UIView animateWithDuration:1.6 animations:^{

        ws.iv0.alpha = headAlpha0;
        ws.iv1.alpha = headAlpha1;
        ws.iv2.alpha = headAlpha2;
        ws.iv3.alpha = headAlpha3;//最小
        
        CGFloat s1 = LTAutoW(headWH1)/ivWH1;
        CGFloat s2 = LTAutoW(headWH2)/ivWH2;
        CGFloat s3 = LTAutoW(headWH3)/ivWH3;
        
        [ws.iv1 scaleWithX:s1 Y:s1];
        [ws.iv2 scaleWithX:s2 Y:s2];
        [ws.iv3 scaleWithX:s3 Y:s3];

        [ws.iv1 moveX:-LTAutoW(headWH1-4.6) Y:-LTAutoW(2.3)];
        [ws.iv2 moveX:-LTAutoW(headWH2) Y:-LTAutoW(4)];
        [ws.iv3 moveX:-LTAutoW(headWH3) Y:-LTAutoW(5)];
        
    } completion:^(BOOL finished) {
        
        CGFloat ivWH3 = LTAutoW(headWH3);
        ws.iv3.frame = CGRectMake(LTAutoW(kLeftMar), [ws viewy:headWH3], ivWH3, ivWH3);
        
        CGFloat ivWH2 = LTAutoW(headWH2);
        ws.iv2.frame = CGRectMake(LTAutoW(kLeftMar), [ws viewy:headWH2], ivWH2, ivWH2);
        
        CGFloat ivWH1 = LTAutoW(headWH1);
        ws.iv1.frame = CGRectMake(_iv2.x_ + ivWH2/2.0, [ws viewy:headWH1], ivWH1, ivWH1);
        
        CGFloat ivWH0 = LTAutoW(headWH0);
        ws.iv0.frame = CGRectMake(_iv1.x_ + ivWH1/2.0, [ws viewy:headWH0], ivWH0, ivWH0);

    }];
}


- (void)clickLoginBtn {
    _loginBlock ? _loginBlock() : nil;
}

- (void)clickShowGainBtn {
    _showGainBlock ? _showGainBlock() : nil;
}

#pragma mark - 外部
- (void)setTyp:(GainBtmViewType)typ {
    _typ = typ;
    
    if (typ == GainBtmViewType_meOutTop) {
        _outTopView.hidden = NO;
        _inTopView.hidden = YES;
        _logoutView.hidden = YES;
        _showGainBtn.hidden = NO;
    } else if (typ == GainBtmViewType_meInTop) {
        _outTopView.hidden = YES;
        _inTopView.hidden = NO;
        _logoutView.hidden = YES;
        _showGainBtn.hidden = NO;
    } else {//GainBtmViewType_logout
        _outTopView.hidden = YES;
        _inTopView.hidden = YES;
        _logoutView.hidden = NO;
        _showGainBtn.hidden = YES;
    }
}

- (void)refData:(ShowGainModel *)mo {
    if (_typ == GainBtmViewType_meInTop) {

        NSArray *avatars = [NSArray arrayWithArray:mo.avatars];
        NSInteger avatarsCount = avatars.count;
        
        if (avatarsCount > 0) {
            NSString *imgUrl0 = avatars[0];
            [_iv0 sd_setImageWithURL:[imgUrl0 toURL] placeholderImage:[UIImage imageNamed:@"Head80"]];
        }
        if (avatarsCount > 1) {
            NSString *imgUrl1 = avatars[1];
            [_iv1 sd_setImageWithURL:[imgUrl1 toURL] placeholderImage:[UIImage imageNamed:@"Head80"]];
        }
        if (avatarsCount > 2) {
            NSString *imgUrl2 = avatars[2];
            [_iv2 sd_setImageWithURL:[imgUrl2 toURL] placeholderImage:[UIImage imageNamed:@"Head80"]];
        }
        if (avatarsCount > 3) {
            NSString *imgUrl3 = avatars[3];
            [_iv3 sd_setImageWithURL:[imgUrl3 toURL] placeholderImage:[UIImage imageNamed:@"Head80"]];
        }
      
        
        NSInteger showOrderNum = mo.showOrderNum;
        _showGianNumLab.text = [NSString stringWithFormat:@"%ld位",(long)showOrderNum];
        
        [_iv sd_setImageWithURL:[mo.myAvatar toURL] placeholderImage:[UIImage imageNamed:@"Head80"]];
        
        NSInteger myRanking = mo.myRanking;
        _myNumLab.text = [NSString stringWithFormat:@"第%ld位",(long)myRanking];
        
        [self headAnimate];
    } else if (_typ == GainBtmViewType_meOutTop) {

    } else {//GainBtmViewType_logout

    }
    
    
}

@end
