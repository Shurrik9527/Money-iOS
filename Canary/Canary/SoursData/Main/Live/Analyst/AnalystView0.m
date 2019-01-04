//
//  AnalystView0.m
//  ixit
//
//  Created by litong on 2017/3/30.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "AnalystView0.h"
#import "LTWebCache.h"

#define kMarkViewH  LTAutoW(17)
#define kMarkViewTopMar  LTAutoW(12)

@interface AnalystView0 ()

@property (nonatomic,strong) UIView *playStateView;//直播中背景
@property (nonatomic,strong) UILabel *playStateLab;//直播中
@property (nonatomic,strong) UIImageView *gifIV;//直播中动画标记

@property (nonatomic,strong) UIImageView *headIV;//头像
@property (nonatomic,strong) UILabel *nameLab;//名称
//@property (nonatomic,strong) UILabel *qualificationLab;//资格证号

@property (nonatomic,strong) UIView *markView;//标签
@property (nonatomic,strong) UIView *numView;//直播时长、粉丝数、礼物积分
@property (nonatomic,strong) UILabel *numPlayLab;//直播时长
@property (nonatomic,strong) UILabel *numFansLab;//粉丝数
@property (nonatomic,strong) UILabel *numPointLab;//礼物积分

@end


@implementation AnalystView0


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = LTColorHex(0xF7FAFF);
        [self createView];
    }
    return self;
}

- (void)createView {
    
    //直播中
    CGRect rect = CGRectMake(0, LTAutoW(32.5), LTAutoW(66), LTAutoW(24));
    self.playStateView = [[UIView alloc] initWithFrame:rect];
    [self addSubview:_playStateView];
    
    CGFloat gifw = LTAutoW(10);
    CGFloat gifh = LTAutoW(11);
    self.gifIV = [[UIImageView alloc] init];
    _gifIV.frame = CGRectMake(LTAutoW(8), LTAutoW(6.5), gifw, gifh);
    [_playStateView addSubview:_gifIV];
    [_gifIV animationTime:1.2 repeatCount:0 imgNamePrefix:@"live_icon_wave" imgCount:4 begin:1];
    
    CGFloat psLabx = _gifIV.xw_ + LTAutoW(4);
    self.playStateLab = [self lab:LTWhiteColor fz:12];
    _playStateLab.frame =  CGRectMake(psLabx, 0, _playStateView.w_ - psLabx, _playStateView.h_);
    _playStateLab.text = @"直播中";
    [_playStateView addSubview:_playStateLab];
    
    
    
    //头像
    CGFloat headIVWH = LTAutoW(75);
    self.headIV = [[UIImageView alloc] init];
    _headIV.frame = CGRectMake((ScreenW_Lit - headIVWH)*0.5, LTAutoW(16), headIVWH, headIVWH);
    _headIV.image = [UIImage imageNamed:@"Head80"];
    [self addSubview:_headIV];
    
    //名称
    self.nameLab = [self lab:LTTitleColor fz:15];
    _nameLab.frame =  CGRectMake(0, _headIV.yh_ + LTAutoW(12), ScreenW_Lit, LTAutoW(21));
    _nameLab.text = @"分析师";
    [self addSubview:_nameLab];
    //资格证号
    //    self.qualificationLab = [self lab:LTSubTitleColor fz:12];
    //    _qualificationLab.frame =  CGRectMake(0, _nameLab.yh_ + LTAutoW(8), ScreenW_Lit, LTAutoW(16.5));
    //    _nameLab.text = @"资格证号";
    //    [self addSubview:_qualificationLab];
    
    //标签
    self.markView = [[UIView alloc] init];
    [self addSubview:_markView];
    
    //直播时长、粉丝数、礼物积分
    self.numView = [[UIView alloc] init];
    CGFloat numViewX = LTAutoW(16);
    CGFloat numViewW = (ScreenW_Lit - 2*numViewX);
    CGFloat numViewH = LTAutoW(44.5);
    //    _numView.frame = CGRectMake(numViewX, _qualificationLab.yh_ +kMarkViewTopMar + kMarkViewH + LTAutoW(23), numViewW, numViewH);
    _numView.frame = CGRectMake(numViewX, _nameLab.yh_ +kMarkViewTopMar + kMarkViewH + LTAutoW(23), numViewW, numViewH);
    [self addSubview:_numView];
    
    CGFloat labw = numViewW/3.0;
    CGFloat labh = LTAutoW(28);
    CGFloat labh0 = numViewH - labh;
    
    self.numPlayLab = [self lab:LTTitleColor fz:20];
    self.numPlayLab.frame = CGRectMake(0, 0, labw, labh);
    [_numView addSubview:self.numPlayLab];
    UILabel *playLab0 = [self lab:LTSubTitleColor fz:12];
    playLab0.frame = CGRectMake(0, labh, labw, labh0);
    playLab0.text = @"直播时长(小时)";
    [_numView addSubview:playLab0];
    
    self.numFansLab = [self lab:LTTitleColor fz:20];
    self.numFansLab.frame = CGRectMake(labw, 0, labw, labh);
    [_numView addSubview:self.numFansLab];
    UILabel *fansLab0 = [self lab:LTSubTitleColor fz:12];
    fansLab0.frame = CGRectMake(labw, labh, labw, labh0);
    fansLab0.text = @"观看数(人)";
    [_numView addSubview:fansLab0];
    
    
    self.numPointLab = [self lab:LTTitleColor fz:20];
    self.numPointLab.frame = CGRectMake(labw*2, 0, labw, labh);
    [_numView addSubview:self.numPointLab];
    UILabel *pointLab0 = [self lab:LTSubTitleColor fz:12];
    pointLab0.frame = CGRectMake(labw*2, labh, labw, labh0);
    pointLab0.text = @"礼物总额(积分)";
    [_numView addSubview:pointLab0];
    
    CGFloat liney = LTAutoW(4.5);
    UIView *line0 = [UIView lineFrame:CGRectMake(labw, liney, LTAutoW(1), numViewH - liney) color:LTColorHex(0xE5EAFE)];
    [_numView addSubview:line0];
    
    UIView *line1 = [UIView lineFrame:CGRectMake(labw*2, liney, LTAutoW(1), numViewH - liney) color:LTColorHex(0xE5EAFE)];
    [_numView addSubview:line1];
    
    
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
    
    
    CGFloat allW = kMarkMM;
    UIColor *color = LTColorHex(0x6C97FC);
    for (NSString *tmp in marks) {
        NSString *str = [tmp trim];
        UILabel *lab = [self lab:color fz:12];
        lab.text = str;
        CGSize size = [lab sizeThatFits:CGSizeMake(MAXFLOAT, kMarkViewH)];
        CGFloat labw = size.width + 2*kMarkLRM;
        lab.frame = CGRectMake(allW, 0, labw, kMarkViewH);
        [lab layerRadius:2 borderColor:color borderWidth:0.5];
        [_markView addSubview:lab];
        
        allW = allW + labw + kMarkMM;
    }
    allW += kMarkMM;
    //    _markView.frame = CGRectMake((ScreenW_Lit - allW)*0.5, _qualificationLab.yh_ + kMarkViewTopMar, allW, kMarkViewH);
    _markView.frame = CGRectMake((ScreenW_Lit - allW)*0.5, _nameLab.yh_ + kMarkViewTopMar, allW, kMarkViewH);
}

#pragma mark - utils

- (UILabel *)lab:(UIColor *)color fz:(CGFloat)fz {
    UILabel *lab = [[UILabel alloc] init];
    lab.font = autoFontSiz(fz);
    lab.textColor = color;
    lab.textAlignment = NSTextAlignmentCenter;
    return lab;
}


- (void)gifShow:(BOOL)show {
    if (show) {
        [_gifIV startAnimating];
        _playStateView.backgroundColor = LTColorHex(0x4877E6);
    } else {
        [_gifIV stopAnimating];
    }
    
    _playStateView.hidden = !show;
}

#pragma mark - 外部

- (void)configViewWithLiveMO:(LiveMO *)liveMO {
    LiveTimeMo *mo = liveMO.segmentModel_fmt;
    
    [self gifShow:[liveMO isLiving]];
    
    [_headIV lt_setImageWithURL:mo.authorAvatar placeholderImage:[UIImage imageNamed:@"Head80"]];
    _nameLab.text = mo.name_fmt;
    //    _qualificationLab.text = liveMO.cardId_fmt;
    
    [self configMarkView:mo.introduction_fmt];
}

- (void)configViewWithAnalystMO:(AnalystMO *)analystMO {
    self.numPlayLab.text = analystMO.liveTimeCount_fmt;
    self.numFansLab.text = analystMO.watchCount_fmt;
    self.numPointLab.text = analystMO.integralCount_fmt;
}

@end
