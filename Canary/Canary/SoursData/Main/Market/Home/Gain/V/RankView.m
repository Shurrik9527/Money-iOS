//
//  RankView.m
//  ixit
//
//  Created by litong on 2016/11/21.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "RankView.h"
#import "UIView+LTGesture.h"

@interface RankView ()

@property (nonatomic,strong) GainModel *mo;
@property (nonatomic,assign) NSInteger rankIdx;//排名：1、2、3
@property (nonatomic,strong) RankIV *rankIV;//头像 带徽章
@property (nonatomic,strong) UILabel *nameLab;//昵称
@property (nonatomic,strong) UILabel *gainLab;//盈利58%
@property (nonatomic,strong) UIImageView *quanIV;//优惠券￥168、128、88

@end

@implementation RankView


- (instancetype)initWithFrame:(CGRect)frame rankIdx:(NSInteger)rankIdx {
    self = [super initWithFrame:frame];
    if (self) {
        self.rankIdx = rankIdx;
        [self createView];
    }
    return self;
}

static CGFloat Gain1IVW = 62.5;
static CGFloat Gain1IVH = 63.5;

static CGFloat Gain23IVW = 51.2;
static CGFloat Gain23IVH = 52;

- (void)createView {
    CGFloat rankIVW = 0;
    CGFloat rankIVH = 0;
    NSString *quanIVName = @"";
    
    if (_rankIdx == 1) {
        rankIVW = Gain1IVW;
        rankIVH = Gain1IVH;
        quanIVName = @"quan_TIcon168";
    } else if (_rankIdx == 2) {
        rankIVW = Gain23IVW;
        rankIVH = Gain23IVH;
        quanIVName = @"quan_TIcon128";
    } else if (_rankIdx == 3) {
        rankIVW = Gain23IVW;
        rankIVH = Gain23IVH;
        quanIVName = @"quan_TIcon88";
    }

    CGRect r1 = CGRectMake((self.w_ - LTAutoW(rankIVW))/2, 0, LTAutoW(rankIVW), LTAutoW(rankIVH));
    self.rankIV = [[RankIV alloc] initWithFrame:r1];
    _rankIV.ranking = _rankIdx;
    [self addSubview:_rankIV];
    
    CGRect nameLabRect = CGRectMake(0 , _rankIV.yh_ + LTAutoW(8), self.w_, LTAutoW(15.f));
    self.nameLab = [self lab:nameLabRect color:LTWhiteColor fontsize:15.f];
    [self addSubview:_nameLab];
    
    CGRect gainLabRect = CGRectMake(0 , _nameLab.yh_ + LTAutoW(4), self.w_, LTAutoW(15.f));
    self.gainLab = [self lab:gainLabRect color:LTKLineRed fontsize:15.f];
    [self addSubview:_gainLab];
    
    CGFloat quanIVW = LTAutoW(46);
    CGFloat quanIVH = LTAutoW(19);
    self.quanIV = [[UIImageView alloc] init];
    _quanIV.frame = CGRectMake((self.w_-quanIVW)/2.0, _gainLab.yh_+LTAutoW(5), quanIVW, quanIVH);
    _quanIV.image = [UIImage imageNamed:quanIVName];
    [self addSubview:_quanIV];
 
    [self addSingeTap:@selector(clickView) target:self];
}

- (void)clickView {
    
    NSDictionary *dict = @{
                           @"ranking":@(_rankIdx),
                           @"GainModel":_mo
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:NFC_ClickRankView object:dict];
}

- (UILabel *)lab:(CGRect)r color:(UIColor *)color fontsize:(CGFloat)fontsize {
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = r;
    lab.textColor = color;
    lab.font = autoFontSiz(fontsize);
    lab.textAlignment = NSTextAlignmentCenter;
    return lab;
}

#pragma mark - 外部

- (void)refData:(GainModel *)mo {
    _mo = mo;
    
    [_rankIV setImgUrlStr:mo.avatar];//设置头像
    
    _nameLab.text = mo.nickName;
    
    NSString *str = [NSString stringWithFormat:@"盈利 %@",mo.profitRate];
    NSAttributedString *ABStr = [str ABStrColor:LTSubTitleColor font:autoFontSiz(12) range:NSMakeRange(0, 2)];
    _gainLab.attributedText = ABStr;
    
}


@end
