//
//  AnalystView.m
//  ixit
//
//  Created by litong on 2017/3/30.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "AnalystView.h"
#import "LTWebCache.h"

#define kMarkViewH  LTAutoW(17)
#define kMarkViewTopMar  LTAutoW(12)

@interface AnalystView ()

@property (nonatomic,strong) UIImageView *headBg;//头像背景
@property (nonatomic,strong) UIImageView *headIV;//头像
@property (nonatomic,strong) UILabel *nameLab;//名称
@property (nonatomic,strong) UILabel *subLab;//资格证号
@property (nonatomic,strong) UIView *markView;//标签
@property (nonatomic,strong) UIButton *attBtn;//关注按钮

@property (nonatomic,strong) UIButton *giftBg;//直播中背景
@property (nonatomic,strong) UIImageView *gifIV;//直播中动画标记

@property (nonatomic,strong) UIView *numView;//直播时长、粉丝数、礼物积分
@property (nonatomic,strong) UILabel *numPlayLab;//直播时长
@property (nonatomic,strong) UILabel *numFansLab;//粉丝数
@property (nonatomic,strong) UILabel *numPointLab;//礼物积分

@property (nonatomic,assign) BOOL darkBg;

@end


@implementation AnalystView




- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame darkBg:NO];
}

- (instancetype)initWithFrame:(CGRect)frame darkBg:(BOOL)darkBg {
    self = [super initWithFrame:frame];
    if (self) {
        self.darkBg = darkBg;
        self.backgroundColor = [AnalystView darkBgColor:darkBg];
        [self createView];
    }
    return self;
}



- (void)createView {
    //头像背景
    CGFloat headBgWH = LTAutoW(84);
    self.headBg = [[UIImageView alloc] init];
    _headBg.frame = CGRectMake(LTAutoW(11.5), 0, headBgWH, headBgWH);
    _headBg.image = [UIImage imageNamed:@"live_headbg"];
    [self addSubview:_headBg];
    
    //头像
    CGFloat headIVWH = LTAutoW(75);
    self.headIV = [[UIImageView alloc] init];
    _headIV.frame = CGRectMake(LTAutoW(16), LTAutoW(4.5), headIVWH, headIVWH);
    _headIV.image = [UIImage imageNamed:@"Head80"];
    _headIV.center = _headBg.center;
    [self addSubview:_headIV];

    
    //直播中
    CGFloat giftBgWH = LTAutoW(20);
    CGFloat giftBgXY = headIVWH-giftBgWH;
    self.giftBg = [UIButton buttonWithType:UIButtonTypeCustom];
    _giftBg.frame = CGRectMake(giftBgXY, giftBgXY, giftBgWH, giftBgWH);
    [_headIV addSubview:_giftBg];
    [_giftBg setNorBGImageName:@"live_play_black"];
    [_giftBg setSelBGImageName:@"live_play_white"];
    
    CGFloat gifw = LTAutoW(7);
    CGFloat gifh = LTAutoW(9);
    self.gifIV = [[UIImageView alloc] init];
    _gifIV.frame = CGRectMake((giftBgWH - gifw)*0.5, (giftBgWH - gifh)*0.5, gifw, gifh);
    [_giftBg addSubview:_gifIV];
    [_gifIV animationTime:1.2 repeatCount:0 imgNamePrefix:@"live_icon_wave" imgCount:4 begin:1];
    
    //名称
    UIColor *nameColor = _darkBg ? LTWhiteColor : LTTitleColor;
    CGFloat nameLabX = _headBg.xw_ + LTAutoW(11.5);
    self.nameLab = [self lab:nameColor fz:20];
    _nameLab.frame =  CGRectMake(nameLabX, LTAutoW(5), LTAutoW(100), LTAutoW(28));
    [self addSubview:_nameLab];
    //分析师描述  |  资格证号
    self.subLab = [self lab:LTSubTitleColor fz:12];
    _subLab.frame =  CGRectMake(nameLabX, _nameLab.yh_ + LTAutoW(4), ScreenW_Lit, LTAutoW(16.5));
    [self addSubview:_subLab];
    //标签
    self.markView = [[UIView alloc] init];
    _markView.frame = CGRectMake(nameLabX, _subLab.yh_ + LTAutoW(12), ScreenW_Lit - nameLabX - LTAutoW(16), kMarkViewH);
    [self addSubview:_markView];
    //关注按钮
    CGFloat attw = LTAutoW(68);
    CGFloat atth = LTAutoW(32);
    CGRect attrect = CGRectMake(ScreenW_Lit - LTAutoW(16) - attw, LTAutoW(4.5), attw, atth);
    self.attBtn = [UIButton btnWithTarget:self action:@selector(attAction:) frame:attrect];
    [_attBtn setNorBGImageName:@"btn_border_blue"];
    [_attBtn setSelBGImageName:@"btn_border_gray"];
    [_attBtn setTitleColor:LTColorHex(0x4877E6) forState:UIControlStateNormal];
    [_attBtn setTitleColor:LTSubTitleColor forState:UIControlStateSelected];
    [_attBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
    [_attBtn setTitle:@"已关注" forState:UIControlStateSelected];
    _attBtn.titleLabel.font = autoFontSiz(12);
    [self addSubview:_attBtn];



    //直播时长、粉丝数、礼物积分
    CGFloat numViewX = LTAutoW(16);
    CGFloat numViewW = (ScreenW_Lit - numViewX - LTAutoW(60));//92
    CGFloat numViewH = LTAutoW(39);
    self.numView = [[UIView alloc] init];
    _numView.frame = CGRectMake(numViewX, _headBg.yh_ + LTAutoW(39.5), numViewW, numViewH);
    [self addSubview:_numView];
    
    CGFloat labw = numViewW/3.0;
    CGFloat labh = LTAutoW(21);
    CGFloat labh0 = LTAutoW(14);
    CGFloat lab0y = labh + LTAutoW(6);
    CGFloat fz = 15;
    CGFloat fz0 = 10;
    
    self.numPlayLab = [self lab:LTTitleColor fz:fz];
    self.numPlayLab.frame = CGRectMake(0, 0, labw, labh);
    [_numView addSubview:self.numPlayLab];
    UILabel *playLab0 = [self lab:LTSubTitleColor fz:fz0];
    playLab0.frame = CGRectMake(0, lab0y, labw, labh0);
    playLab0.text = @"直播时长(小时)";
    [_numView addSubview:playLab0];
    
    self.numFansLab = [self lab:LTTitleColor fz:fz];
    self.numFansLab.frame = CGRectMake(labw, 0, labw, labh);
    [_numView addSubview:self.numFansLab];
    UILabel *fansLab0 = [self lab:LTSubTitleColor fz:fz0];
    fansLab0.frame = CGRectMake(labw, lab0y, labw, labh0);
    fansLab0.text = @"观看数(人)";
    [_numView addSubview:fansLab0];
    
    
    self.numPointLab = [self lab:LTTitleColor fz:fz];
    self.numPointLab.frame = CGRectMake(labw*2, 0, labw, labh);
    [_numView addSubview:self.numPointLab];
    UILabel *pointLab0 = [self lab:LTSubTitleColor fz:fz0];
    pointLab0.frame = CGRectMake(labw*2, lab0y, labw, labh0);
    pointLab0.text = @"礼物总额(积分)";
    [_numView addSubview:pointLab0];
    
    
    self.numPlayLab.text = @"0";
    self.numFansLab.text = @"0";
    self.numPointLab.text = @"0";
}

#define kMarkLRM    LTAutoW(8)
#define kMarkMM    LTAutoW(4)

- (void)configMarkView:(NSArray *)marks {
    [_markView removeAllSubView];
    
    NSInteger count = marks.count;
    if (count == 0) {
        return;
    }
    
    CGFloat allW = 0;
    UIColor *color = _darkBg ? LTColorHexA(0xFFFFFF, 0.06) : LTColorHexA(0xF0F2F5, 0.7);
    for (NSString *tmp in marks) {
        NSString *str = [tmp trim];
        UILabel *lab = [self lab:LTSubTitleColor fz:12];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = str;
        CGSize size = [lab sizeThatFits:CGSizeMake(MAXFLOAT, kMarkViewH)];
        CGFloat labw = size.width + 2*kMarkLRM;
        lab.frame = CGRectMake(allW, 0, labw, kMarkViewH);
        [lab layerRadius:2 bgColor:color];
        [_markView addSubview:lab];
        
        allW = allW + labw + kMarkMM;
    }

    [_markView setSW:allW];
}


#pragma mark - action

- (void)attAction:(UIButton *)sender {
    
}

#pragma mark - utils

- (UILabel *)lab:(UIColor *)color fz:(CGFloat)fz {
    UILabel *lab = [[UILabel alloc] init];
    lab.font = autoFontSiz(fz);
    lab.textColor = color;
    return lab;
}


- (void)gifShow:(BOOL)show {
    if (show) {
        [_gifIV startAnimating];
        _giftBg.selected = YES;
        _giftBg.hidden = NO;
    } else {
        [_gifIV stopAnimating];
        _giftBg.selected = NO;
        _giftBg.hidden = YES;
    }
}

#pragma mark - 外部

- (void)configViewWithLiveMO:(LiveMO *)liveMO {
    LiveTimeMo *mo = liveMO.segmentModel_fmt;
    
    BOOL isliving = [liveMO isLiving];
    [self gifShow:isliving];
    
    [_headIV lt_setImageWithURL:mo.authorAvatar placeholderImage:[UIImage imageNamed:@"Head80"]];
    _nameLab.text = mo.authorName;
    _subLab.text = liveMO.cardId_fmt;
    
    [self configMarkView:mo.introduction_fmt];
}

- (void)configViewWithAnalystMO:(AnalystMO *)analystMO {
    self.numPlayLab.text = analystMO.liveTimeCount_fmt;
    self.numFansLab.text = analystMO.watchCount_fmt;
    self.numPointLab.text = analystMO.integralCount_fmt;
}


+ (UIColor *)darkBgColor:(BOOL)darkBg {
    UIColor *color = darkBg ? LTColorHex(0x373A50) : LTColorHex(0xF8FAFF);
    return color;
}

@end
