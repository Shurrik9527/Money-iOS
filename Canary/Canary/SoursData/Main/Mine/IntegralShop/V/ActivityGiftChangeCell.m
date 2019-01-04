//
//  ActivityGiftChangeCell.m
//  ixit
//
//  Created by litong on 2017/4/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "ActivityGiftChangeCell.h"
#import "LTWebCache.h"

@interface ActivityGiftChangeCell ()

@property (nonatomic,strong) UIImageView *bgIV;//背景
@property (nonatomic,strong) UILabel *titleLab;//亏损包赔
@property (nonatomic,strong) UILabel *pointLab;//1,000,000积分
@property (nonatomic,strong) UILabel *exchangeLab;//10,345人已兑换
@property (nonatomic,strong) UILabel *timeLab;//时间
@property (nonatomic,strong) UIImageView *nextIV;

@end

@implementation ActivityGiftChangeCell

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
    CGFloat ivw = LTAutoW(353);
    CGFloat ivh = LTAutoW(80);
    
    self.bgIV = [[UIImageView alloc] init];
    self.bgIV.frame = CGRectMake((ScreenW_Lit - ivw)*0.5, LTAutoW(3), ivw, ivh);
    [self addSubview:self.bgIV];
    
    self.titleLab = [self lab:15 color:LTWhiteColor];
    self.titleLab.frame = LTRectAutoW(36, 20, 200, 15);
    [self addSubview:self.titleLab];
    
    self.pointLab = [self lab:15 color:LTColorHexA(0xFFFFFF, 0.6)];
    self.pointLab.frame = CGRectMake(_titleLab.x_, _titleLab.yh_+LTAutoW(10), _titleLab.w_, LTAutoW(15));
    [self addSubview:self.pointLab];
    
    
    CGFloat labw = LTAutoW(120);
    self.exchangeLab = [self lab:12 color:LTColorHexA(0xFFFFFF, 0.6)];
    self.exchangeLab.frame = CGRectMake(ScreenW_Lit - LTAutoW(36) - labw, _titleLab.y_, labw, _titleLab.h_);
    self.exchangeLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.exchangeLab];
    
    self.timeLab = [self lab:12 color:LTColorHexA(0xFFFFFF, 0.6)];
    self.timeLab.frame = CGRectMake(_exchangeLab.x_, _pointLab.y_, labw, _pointLab.h_);
    self.timeLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.timeLab];
    
    
    CGFloat nextIVW = LTAutoW(7);
    CGFloat nextIVH = LTAutoW(11);
    self.nextIV = [[UIImageView alloc] init];
    _nextIV.frame = CGRectMake(ScreenW_Lit - LTAutoW(24) - nextIVW, (kActivityGiftChangeCellH - nextIVH)*0.5, nextIVW, nextIVH);
    _nextIV.image = [UIImage imageNamed:@"next_white"];
    [self addSubview:_nextIV];
}


#pragma mark - utils

- (UILabel *)lab:(CGFloat)fs color:(UIColor *)color {
    UILabel *lab = [[UILabel alloc] init];
    lab.font = autoFontSiz(fs);
    lab.textColor = color;
    return lab;
}


#pragma mark - 外部

- (void)bindData:(GiftChangeMO *)mo {
    
    [self.bgIV lt_setImageWithURL:mo.giftPic];
    
    self.titleLab.text = mo.giftName;
    self.pointLab.text = [mo totalPoins_fmt];
    self.exchangeLab.text = @"兑换成功";
    self.timeLab.text = mo.createTimeStr;
}

@end
