//
//  GainCell.m
//  ixit
//
//  Created by litong on 2016/11/14.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "GainCell.h"
#import "UIImageView+WebCache.h"
#import "NSDate+LT.h"

static CGFloat garyViewW = 24.f;//灰色区域宽
static CGFloat leftMar = 12.f;//左边距
static CGFloat headWH = 36.f;//头像宽高
static CGFloat nickLabW = 80.f;//昵称宽
static CGFloat gainLabW = 30.f;//盈利 宽
static CGFloat gainRateLabW = 50.f;//盈利百分比 宽
static CGFloat predictW = 52.f;//预计奖励 宽
static CGFloat ticketW = 49.f;//券 宽
static CGFloat ticketH = 21.f;//券 高

@interface GainCell ()

/** 左边灰色区域 */
@property (nonatomic,strong) UILabel *garyView;
@property (nonatomic,strong) UIImageView *leftView;

/** 头像 */
@property (nonatomic,strong) UIImageView *headView;
/** 昵称 */
@property (nonatomic,strong) UILabel *nickLab;
/** 盈利百分比 */
@property (nonatomic,strong) UILabel *gainRateLab;

/** 文字：预计奖励 或者 奖励 */
@property (nonatomic,strong) UILabel *predictLab;

/** 券 */
@property (nonatomic,strong) UIImageView *ticketView;

@end

@implementation GainCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

- (void)addLine {
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, LTAutoW(GainCellH) - 0.5, ScreenW_Lit, 0.5);
    lineView.backgroundColor = LTLineColor;
    [self addSubview:lineView];
}



- (void)createCell {
    [self addLine];
    
    self.leftView = [[UIImageView alloc] init];
    _leftView.frame = CGRectMake(LTAutoW(6), LTAutoW(12), LTAutoW(22), LTAutoW(24));
    _leftView.hidden = YES;
    [self addSubview:_leftView];
    
    self.garyView = [[UILabel alloc] init];
    _garyView.frame = CGRectMake(0, 0, LTAutoW(garyViewW), LTAutoW(GainCellH+1));
    _garyView.backgroundColor = LTBgColor;
    _garyView.textColor = LTSubTitleColor;
    _garyView.font = autoFontSiz(15.f);
    _garyView.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_garyView];
    
    self.headView = [[UIImageView alloc] init];
    _headView.frame = CGRectMake(_garyView.xw_ + LTAutoW(leftMar), LTAutoW((GainCellH - headWH))/2.0, LTAutoW(headWH), LTAutoW(headWH));
    [_headView layerRadius:(_headView.w_ / 2.0) borderColor:LTColorHex(0xdddddd) borderWidth:0.5f];
    [self addSubview:_headView];
    
    self.nickLab = [[UILabel alloc] init];
    _nickLab.frame = CGRectMake(_headView.xw_ + LTAutoW(leftMar), 0, LTAutoW(nickLabW), LTAutoW(GainCellH));
    _nickLab.textColor = LTTitleColor;
    _nickLab.font = autoFontSiz(15.f);
    [self addSubview:_nickLab];
    
    UILabel *gainLab = [[UILabel alloc] init];
    gainLab.frame = CGRectMake(_nickLab.xw_+LTAutoW(13), 0, LTAutoW(gainLabW), LTAutoW(GainCellH));
    gainLab.textColor = LTSubTitleColor;
    gainLab.font = autoFontSiz(12.f);
    gainLab.text = @"盈利";
    gainLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:gainLab];
    
    self.gainRateLab = [[UILabel alloc] init];
    _gainRateLab.frame = CGRectMake(gainLab.xw_, 0, LTAutoW(gainRateLabW), LTAutoW(GainCellH));
    _gainRateLab.textColor = LTKLineRed;
    _gainRateLab.font = autoFontSiz(15.f);
    [self addSubview:_gainRateLab];
    
    self.predictLab = [[UILabel alloc] init];
    _predictLab.frame = CGRectMake(_gainRateLab.xw_, 0, LTAutoW(predictW), LTAutoW(GainCellH));
    _predictLab.textColor = LTSubTitleColor;
    _predictLab.font = autoFontSiz(12.f);
    _predictLab.text = @"奖励";
    _predictLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_predictLab];
    
    self.ticketView = [[UIImageView alloc] init];
    _ticketView.frame = CGRectMake(_predictLab.xw_ + LTAutoW(9) , LTAutoW((GainCellH - ticketH))/2.0, LTAutoW(ticketW), LTAutoW(ticketH));
    [self addSubview:_ticketView];
    
}

#pragma mark - 外部

- (void)bindData:(GainModel *)mo idx:(NSInteger)idx {
    
    idx +=1;
    if (idx <= 3) {
        _leftView.hidden = NO;
        _garyView.hidden = YES;
        NSString *iconName = [NSString stringWithFormat:@"GainIcon%ld",(long)idx];
        _leftView.image = [UIImage imageNamed:iconName];
    } else {
        _leftView.hidden = YES;
        _garyView.hidden = NO;
        _garyView.text = [NSString stringWithInteger:idx];
    }
    
    [_headView sd_setImageWithURL:[mo.avatar toURL] placeholderImage:[UIImage imageNamed:@"Head80"]];
    _nickLab.text = mo.nickName;
    _gainRateLab.text = mo.profitRate;
    
    
    NSString *ymd = [[NSDate date] chinaYMDString];
    if ([ymd isEqualToString:mo.closeDate]) {
        _predictLab.text = @"预计奖励";
    } else {
        _predictLab.text = @"奖励";
    }
    
    
    NSInteger cu = mo.giveVoucher;
    NSString *imgName = [NSString stringWithFormat:@"quan_icon%ld",(long)cu];
    _ticketView.image = [UIImage imageNamed:imgName];
    
    
    
    NSString *temp = [NSString stringWithFormat:@"%@%@",UD_UserId,mo.orderId];
    NSString *locMark = [temp md5];
    
    if ([mo.uod isEqualToString:locMark]) {
        _nickLab.font = autoBoldFontSiz(15.f);
        self.backgroundColor = LTColorHex(0xF7F8FA);//背景色
    } else {
        _nickLab.font = autoFontSiz(15.f);
        self.backgroundColor = LTWhiteColor;
    }
    
}


@end
