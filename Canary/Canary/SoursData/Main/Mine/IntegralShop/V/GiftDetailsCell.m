//
//  GiftDetailsCell.m
//  ixit
//
//  Created by litong on 2016/12/20.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "GiftDetailsCell.h"

@interface GiftDetailsCell ()


@property (nonatomic,strong) UILabel *titleLab;//获得积分 | 消费积分 (兑换哈贵8元代金券)
@property (nonatomic,strong) UILabel *subLab;//+12000
@property (nonatomic,strong) UILabel *timeLab;//2016-5-18  14:06


@end

@implementation GiftDetailsCell

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
    self.titleLab = [self lab:LTRectAutoW(kLeftMar, 16, 250, 15) fontSize:15 color:LTTitleColor];
    [self addSubview:_titleLab];
    
    self.timeLab = [self lab:CGRectMake(LTAutoW(kLeftMar), _titleLab.yh_ + LTAutoW(9), _titleLab.w_, 12) fontSize:12 color:LTSubTitleColor];
    [self addSubview:_timeLab];
    
    CGFloat subLabW = LTAutoW(80);
    self.subLab = [self lab:CGRectMake(ScreenW_Lit - LTAutoW(kLeftMar) - subLabW, _titleLab.y_, subLabW, 15) fontSize:15 color:LTTitleColor];
    _subLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_subLab];
    
    
    UIView *lineView = [[UIView alloc] init] ;
    lineView.frame = CGRectMake(0, LTAutoW(GiftDetailsCellH)-0.5, ScreenW_Lit, 0.5);
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

- (void)bindData:(GiftDetailsMO *)mo {
    //获得积分 | 消费积分 (兑换哈贵8元代金券)
    self.titleLab.text = mo.pointSourceName;
    
    //+12000
    NSString *vv = mo.pointsValue;
    NSInteger ivv = [vv longLongValue];
    UIColor *color = LTKLineGreen;
    if (ivv > 0 ) {
        color = LTKLineRed;
    }
    self.subLab.text = vv;
    self.subLab.textColor = color;
    
    //2016-5-18  14:06
    self.timeLab.text = mo.createTimeStr_fmt;
}

@end
