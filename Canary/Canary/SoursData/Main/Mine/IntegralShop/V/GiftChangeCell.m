//
//  GiftChangeCell.m
//  ixit
//
//  Created by litong on 2016/12/20.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "GiftChangeCell.h"
#import "UIImageView+WebCache.h"

@interface GiftChangeCell ()

@property (nonatomic,strong) UIImageView *icon;//优惠券
@property (nonatomic,strong) UILabel *titleLab;//哈贵所8元代金券1张
@property (nonatomic,strong) UILabel *subLab;//100,000积分
@property (nonatomic,strong) UILabel *exchangeLab;//兑换成功
@property (nonatomic,strong) UILabel *timeLab;//2016-5-18  14:06


@end

@implementation GiftChangeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = LTWhiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createCell];
    }
    return self;
}

- (void)createCell {
    
    self.icon = [[UIImageView alloc] init];
    _icon.frame = LTRectAutoW(kLeftMar, 20, 80, 44);
    _icon.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_icon];
    
    self.titleLab = [self lab:CGRectMake(_icon.xw_+LTAutoW(12), LTAutoW(21), LTAutoW(150), LTAutoW(15)) fontSize:15 color:LTTitleColor];
    [self addSubview:_titleLab];
    
    self.subLab = [self lab:CGRectMake(_titleLab.x_, _titleLab.yh_ + LTAutoW(12), _titleLab.w_, LTAutoW(15)) fontSize:15 color:LTColorHex(0xFF5D01)];
    [self addSubview:_subLab];
    
    CGFloat exchangeLabW = LTAutoW(98);
    self.exchangeLab = [self lab:CGRectMake(ScreenW_Lit - LTAutoW(kLeftMar)-exchangeLabW, _titleLab.y_, exchangeLabW, LTAutoW(12)) fontSize:12 color:LTSubTitleColor];
    _exchangeLab.textAlignment = NSTextAlignmentRight;
    _exchangeLab.text = @"兑换成功";
    [self addSubview:_exchangeLab];
    
    
    CGFloat timeLabW = LTAutoW(120);
    self.timeLab = [self lab:CGRectMake(ScreenW_Lit - LTAutoW(kLeftMar)-timeLabW, _subLab.y_, timeLabW, LTAutoW(12)) fontSize:12 color:LTSubTitleColor];
    _timeLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_timeLab];
    
    
    UIView *lineView = [[UIView alloc] init] ;
    lineView.frame = CGRectMake(0, kGiftChangeCellH-0.5, ScreenW_Lit, 0.5);
    lineView.backgroundColor = LTLineColor;
    [self addSubview:lineView];
    
}



#pragma mark - utils

- (UILabel *)lab:(CGRect)frame fontSize:(CGFloat)fontSize color:(UIColor *)color {
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = frame;
    lab.font = autoFontSiz(fontSize);
    lab.textColor = color;
    return lab;
}


#pragma mark - 外部

- (void)bindData:(GiftChangeMO *)mo {
    //优惠券
    [_icon sd_setImageWithURL:[mo.giftPic toURL] placeholderImage:[UIImage imageNamed:@"Shop_pic_def"]];
    //哈贵所8元代金券1张
    self.titleLab.text = mo.fullName;
    //100,000积分
    self.subLab.text = mo.totalPoins_fmt;
    //2016-5-18  14:06
    self.timeLab.text = mo.createTimeStr;
}

@end
