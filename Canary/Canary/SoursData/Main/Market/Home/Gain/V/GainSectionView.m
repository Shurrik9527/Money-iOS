//
//  GainSectionView.m
//  ixit
//
//  Created by litong on 2016/11/9.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "GainSectionView.h"

static CGFloat iconWH = 40.f;
static CGFloat topMar = 10.f;

@interface GainSectionView ()
{
    CGFloat labX;
    CGFloat labW;
    CGFloat titleLabH;
}
@property (nonatomic,strong) UIButton *xsView;
@property (nonatomic,strong) UIButton *gainView;
@property (nonatomic,strong) UILabel *gainSubLab;

@end

@implementation GainSectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        labX = LTAutoW(kLeftMar+iconWH+8);
        labW = self.w_ - labX - 16;
        titleLabH = 21.f;
        [self createView];
    }
    return self;
}

- (void)XSBtnAction {
    _clickNewComerBtn ? _clickNewComerBtn() : nil;
}
- (void)gainBtnAction {
    _clickGainBtn ? _clickGainBtn() : nil;
}

- (void)createView {
    CGRect xsRect = CGRectMake(0, 0, self.w_/2, [GainSectionView viewH]);
    self.xsView = [UIButton btnWithTarget:self action:@selector(XSBtnAction) frame:xsRect];
    [self addSubview:_xsView];
    
    UIImageView *xsIV = [self createIV:0];
    [_xsView addSubview:xsIV];
    UILabel *xsTitleLab = [self createLab:@"新手学堂"];
    [_xsView addSubview:xsTitleLab];
//    UILabel *xsSubLab = [self createSubLab:@"什么是8元操盘？"];
//    [_xsView addSubview:xsSubLab];
    [_xsView addLineRight:LTLineColor];
    
    
    CGRect gainRect = CGRectMake(self.w_/2, 0, self.w_/2, [GainSectionView viewH]);
    self.gainView = [UIButton btnWithTarget:self action:@selector(gainBtnAction) frame:gainRect];
    [self addSubview:_gainView];
    
    UIImageView *gainIV = [self createIV:1];
    [_gainView addSubview:gainIV];
    UILabel *gainTitleLab = [self createLab:@"盈利榜"];
    [_gainView addSubview:gainTitleLab];
//    self.gainSubLab = [self createSubLab:@"暂无分享"];
//    [_gainView addSubview:_gainSubLab];
    
    [self addLineTop:LTLineColor];
    [self addLineBottom:LTLineColor];
}

- (UIImageView *)createIV:(NSInteger)idx {
    NSString *imageName = (idx == 0) ? @"newcomer" : @"gain";
    UIImageView *iv = [[UIImageView alloc] init];
    iv.frame =  LTRectAutoW(kLeftMar, topMar, iconWH, iconWH);
    iv.image = [UIImage imageNamed:imageName];
    return iv;
}

- (UILabel *)createLab:(NSString *)title {
    UILabel *lab = [[UILabel alloc] init];
    
    // y轴间距 LTAutoW(topMar) ladel 高度LTAutoW(titleLabH)
    lab.frame = CGRectMake(labX, 0, labW, [GainSectionView viewH]);
    lab.font = [UIFont autoFontSize:17.f];
    lab.textColor = LTTitleColor;
    lab.text = title;
    return lab;
}
- (UILabel *)createSubLab:(NSString *)title {
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(labX, LTAutoW(titleLabH+topMar), labW, LTAutoW(18));
    lab.font = [UIFont autoFontSize:12.f];
    lab.textColor = LTSubTitleColor;
    lab.text = title;
    return lab;
}

#pragma mark - 外部

- (void)refGainLab:(NSString *)name profitRate:(NSString *)profitRate {
    if (emptyStr(profitRate) || emptyStr(name)) {
        _gainSubLab.text = @"暂无分享";
        return;
    }
    

    
    CGFloat fontSize = LTAutoW(12.f);
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    
    //保证文字显示全
    CGSize size = [name boundingSize:CGSizeMake(CGFLOAT_MAX, LTAutoW(16.f)) font:font];
    NSInteger lens = 3;
    if (size.width > fontSize*lens) {
        if (name.length >= lens) {
            name = [name substringToIndex:lens];
            name = [NSString stringWithFormat:@"%@..",name];
        } else if (name.length >= lens-1) {
            name = [name substringToIndex:lens-1];
            name = [NSString stringWithFormat:@"%@..",name];
        }
    }
    //保证文字显示全 ，不需要的话直接删除
    
    NSString *str = [NSString stringWithFormat:@"%@ 盈利 %@",name,profitRate];
    
//    NSInteger len = str.length;
    NSMutableAttributedString *ABStr = [[NSMutableAttributedString alloc] initWithString:str];
    [ABStr setAttributes:@{NSForegroundColorAttributeName:LTKLineRed,
                           NSFontAttributeName:font}
                   range:NSMakeRange(str.length-profitRate.length, profitRate.length)];
    _gainSubLab.attributedText = ABStr;
}

+ (CGFloat)viewH {
    CGFloat h = LTAutoW(60.f);
    return h;
}


@end
