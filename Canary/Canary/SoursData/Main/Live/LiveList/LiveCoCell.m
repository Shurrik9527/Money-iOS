//
//  LiveCoCell.m
//  ixit
//
//  Created by litong on 2017/3/28.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "LiveCoCell.h"
#import "LTWebCache.h"

#define kPlayStateViewW   LTAutoW(55)
#define kLabH   LTAutoW(15)
#define kLabMid   LTAutoW(5)
#define gifx LTAutoW(4)
#define gifw LTAutoW(7)
#define gifh LTAutoW(9)

@interface LiveCoCell ()

@property (nonatomic,strong) UIImageView *picBgIV;//背景图片
@property (nonatomic,strong) UIView *playStateView;//直播中背景
@property (nonatomic,strong) UILabel *playStateLab;//直播中
@property (nonatomic,strong) UIImageView *gifIV;//直播中动画标记
@property (nonatomic,strong) UILabel *nameLab;//名字
@property (nonatomic,strong) UILabel *jobTitleLab;//
@property (nonatomic,strong) UILabel *markLab;//EIA

@end

@implementation LiveCoCell


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = LTBgColor;
        [self createCoCell];
    }
    return self;
}


- (void)createCoCell {
    //背景图片
    self.picBgIV = [[UIImageView alloc] init];
    _picBgIV.frame = CGRectMake(0, 0, self.w_, self.w_);
    [self addSubview:_picBgIV];
    _picBgIV.layer.cornerRadius = 1;
    _picBgIV.layer.masksToBounds = YES;
    
    //直播中
    CGFloat timeW = kPlayStateViewW;
    CGRect rect = CGRectMake(self.w_ - timeW, 0, timeW, LTAutoW(16));
    self.playStateView = [[UIView alloc] initWithFrame:rect];
    [self addSubview:_playStateView];
    
    self.playStateLab = [self lab:LTWhiteColor fz:10];
    _playStateLab.frame = rect;
    _playStateLab.textAlignment = NSTextAlignmentCenter;
    [_playStateView addSubview:_playStateLab];
    

    self.gifIV = [[UIImageView alloc] init];
    _gifIV.frame = CGRectMake(gifx, (_playStateView.h_ - gifh)*0.5, gifw, gifh);
    [_playStateView addSubview:_gifIV];
    _gifIV.hidden = YES;
    [_gifIV animationTime:1.2 repeatCount:0 imgNamePrefix:@"live_icon_wave" imgCount:4 begin:1];
    
    
    //直播描述
    self.nameLab = [self lab:LTTitleColor fz:12];
    _nameLab.frame = CGRectMake(0, _picBgIV.yh_ + LTAutoW(11), 60, kLabH);
    [self addSubview:_nameLab];
    
    self.jobTitleLab = [self lab:LTSubTitleColor fz:10];
    _jobTitleLab.textAlignment = NSTextAlignmentCenter;
    _jobTitleLab.frame = CGRectMake(_nameLab.xw_ +kLabMid, _nameLab.y_, 60, kLabH);
    [self addSubview:_jobTitleLab];
    [_jobTitleLab layerRadius:2 borderColor:LTColorHex(0xB4B9CB) borderWidth:1];
    
    //EIA
    self.markLab = [self lab:LTSubTitleColor fz:10];
    _markLab.frame = CGRectMake(_jobTitleLab.xw_ + kLabMid, _nameLab.y_, 60, kLabH);
    _markLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_markLab];
}

#pragma mark - utils

- (UILabel *)lab:(UIColor *)color fz:(CGFloat)fz {
    UILabel *lab = [[UILabel alloc] init];
    lab.font = autoFontSiz(fz);
    lab.textColor = color;
    return lab;
}



#pragma mark - 外部

- (void)bindData:(LiveMO *)mo {
    
    [_picBgIV lt_setImageWithURL:mo.image placeholderImage:[UIImage imageNamed:@"Head_s100"]];

    NSString *str = [mo beginTime_fmt];
    _playStateLab.text = str;
    CGFloat w = ([_playStateLab fitWidth]+LTAutoW(8));
    
    
    BOOL show = [mo isLiving];
    if (show) {
        CGFloat gifIVX = gifx+gifw;
        CGFloat allW = gifIVX + w;
        _playStateView.frame = CGRectMake(self.w_ - allW, 0, allW, _playStateView.h_);
//        _gifIV.frame = CGRectMake(gifx, (_playStateView.h_ - gifh)*0.5, gifw, gifh);
        _playStateLab.frame = CGRectMake(gifIVX, 0, w, _playStateView.h_);
        
        [_gifIV startAnimating];
        _playStateView.backgroundColor = LTColorHex(0x4877E6);
        _playStateLab.backgroundColor = _playStateView.backgroundColor;
        [_playStateView layerRadius:1 corners:UIRectCornerTopRight | UIRectCornerBottomLeft];
        _gifIV.hidden = NO;
    } else {
        [_gifIV stopAnimating];
        _playStateView.backgroundColor = LTColorHex(0x858DA5);
        _playStateView.frame = CGRectMake(self.w_ - kPlayStateViewW, 0, kPlayStateViewW, _playStateView.h_);
        _playStateLab.backgroundColor = _playStateView.backgroundColor;
        _playStateLab.frame = CGRectMake(0, 0, kPlayStateViewW, _playStateView.h_);
        [_playStateView layerRadius:0 corners:UIRectCornerTopRight | UIRectCornerBottomLeft];
        _gifIV.hidden = YES;
    }
    
    
    //老师名称
    NSString *name = mo.descStr_fmt;
    _nameLab.text = name;
    CGFloat namew = [_nameLab fitWidth];
    [_nameLab setSW:namew];
    
    //职称 特邀分析师
    NSString *jobTitle = [[mo segmentModel_fmt] professionalTitle];
    CGFloat jobTitleW = [_jobTitleLab fitWidth] + LTAutoW(6);
    jobTitleW = MAX(LTAutoW(58), jobTitleW);
    _jobTitleLab.frame = CGRectMake(_nameLab.xw_ +kLabMid, _nameLab.y_, jobTitleW, kLabH);
    _jobTitleLab.text = jobTitle;

    //标签
    NSString *lableStr = mo.lableStr_fmt;
    CGFloat lableStrw = [lableStr autoFitW:LTAutoW(17)];
    _markLab.text = lableStr;
    _markLab.frame = CGRectMake(_jobTitleLab.xw_ + kLabMid, _nameLab.y_, lableStrw, kLabH);
    if (lableStr) {
        UIColor *color = LTColorHex(0xB4B9CB);
        [_markLab layerRadius:2 borderColor:color borderWidth:1];
    } else {
        [_markLab layerRadius:2 borderColor:self.backgroundColor borderWidth:0];
    }
    
}

@end
