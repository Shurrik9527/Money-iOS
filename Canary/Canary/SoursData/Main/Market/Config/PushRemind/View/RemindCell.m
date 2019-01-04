//
//  RemindCell.m
//  ixit
//
//  Created by litong on 2017/2/17.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "RemindCell.h"

@interface RemindCell ()

//行情达到：
@property (nonatomic,strong) UILabel *mpTitleLab;
@property (nonatomic,strong) UILabel *mpLab;

//波动范围：5点     提醒当日有效
@property (nonatomic,strong) UILabel *waveTitleLab;
@property (nonatomic,strong) UILabel *waveLab;

@property (nonatomic,strong) UIImageView *nextIV;

@end

@implementation RemindCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    
    CGFloat titx = LTAutoW(kLeftMar);
    CGFloat titw = LTAutoW(66);
    CGFloat subtitw = ScreenW_Lit - 2*titx - titw;
    //行情达到：
    self.mpTitleLab = [self labFrame:CGRectMake(titx, LTAutoW(16), titw, LTAutoW(16))];
    _mpTitleLab.text = @"买价达到：";
    [self.contentView addSubview:_mpTitleLab];
    
    self.mpLab = [self labBoldFrame:CGRectMake(_mpTitleLab.xw_, LTAutoW(8), subtitw, LTAutoW(28))];
    [self.contentView addSubview:_mpLab];
    
    //波动范围：5点 | 提醒当日有效
    self.waveTitleLab = [self labFrame:CGRectMake(titx, _mpTitleLab.yh_ + LTAutoW(8), titw, LTAutoW(16))];
    _waveTitleLab.text = @"波动范围：";
    [self.contentView addSubview:_waveTitleLab];
    
    self.waveLab = [self labFrame:CGRectMake(_waveTitleLab.xw_, _waveTitleLab.y_, subtitw, LTAutoW(16))];
    [self.contentView addSubview:_waveLab];
    
    CGFloat nextIVW = LTAutoW(7);
    CGFloat nextIVH = LTAutoW(11);
    self.nextIV = [[UIImageView alloc] init];
    _nextIV.frame = CGRectMake(ScreenW_Lit - LTAutoW(kLeftMar) - nextIVW, (LTAutoW(kRemindCellH) - nextIVH)/2.0, nextIVW, nextIVH);
    _nextIV.image = [UIImage imageNamed:@"next"];
    [self addSubview:_nextIV];
    
    
    UIView *lineview = [UIView lineFrame:CGRectMake(0, LTAutoW(kRemindCellH) - 0.5, ScreenW_Lit, 0.5) color:LTLineColor];
    [self addSubview:lineview];
}

- (UILabel *)labFrame:(CGRect)rect {
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = rect;
    lab.font = autoFontSiz(12);
    lab.textColor = LTSubTitleColor;
    return lab;
}

- (UILabel *)labBoldFrame:(CGRect)rect {
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = rect;
    lab.font = autoBoldFontSiz(20);
    lab.textColor = LTTitleColor;
    return lab;
}




#pragma mark  - 外部

- (void)bindData:(PushRemindModel *)mo {
    _mpLab.text = [LTUtils decimalPriceWithCode:mo.productCode floatValue:[mo.customizedProfit floatValue]];
    _waveLab.text = mo.wave_fmd;
    if ([mo.buyType isEqualToString:@"2"]) {
        _mpTitleLab.text=@"买价达到：";
    }else{
        _mpTitleLab.text=@"卖价达到：";
    }
}

@end
