//
//  MyGainCell.m
//  ixit
//
//  Created by litong on 2016/11/14.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "MyGainCell.h"

@interface MyGainCell ()

@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *subLab;

@end

@implementation MyGainCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

- (void)createCell {
    
    CGFloat labW = ScreenW_Lit/2.5;
    self.titleLab = [[UILabel alloc] init];
    _titleLab.frame = CGRectMake(LTAutoW(kLeftMar), LTAutoW(12.f), labW, LTAutoW(24.f));
    _titleLab.textColor = LTTitleColor;
    _titleLab.font = autoFontSiz(17.f);
    [self addSubview:_titleLab];
    
    self.timeLab = [[UILabel alloc] init];
    _timeLab.frame = CGRectMake(LTAutoW(kLeftMar), _titleLab.yh_ + LTAutoW(4.f), labW, LTAutoW(21.f));
    _timeLab.textColor = LTSubTitleColor;
    _timeLab.font = autoFontSiz(15.f);
    [self addSubview:_timeLab];
    
    
    CGFloat ivW = 7.f;
    CGFloat ivH = 11.f;
    UIImageView *nextIV = [[UIImageView alloc] init];
    nextIV.frame = CGRectMake(ScreenW_Lit - LTAutoW(kLeftMar + ivW), [self ay:ivH], LTAutoW(ivW), LTAutoW(ivH));
    nextIV.image = [UIImage imageNamed:@"next"];
    [self addSubview:nextIV];
    
    CGFloat subW = ScreenW_Lit/2.5;
    self.subLab = [[UILabel alloc] init];
    _subLab.frame = CGRectMake(ScreenW_Lit - LTAutoW(kLeftMar+ivW+8)-subW, 0, subW, LTAutoW(MyGainCellH));
    _subLab.textColor = LTKLineRed;
    _subLab.font = autoFontSiz(17.f);
    _subLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_subLab];
    
    [self addLine:LTLineColor frame:CGRectMake(0, LTAutoW(MyGainCellH)-0.5, ScreenW_Lit, 0.5)];
}

- (CGFloat)ay:(CGFloat)h {
    return  LTAutoW((MyGainCellH - h)/2.0);
}


#pragma mark - 外部
- (void)bindData:(MyGainModel *)mo {
    _titleLab.text = [NSString stringWithFormat:@"%@(%@元)",mo.productName,mo.productPrice];
    _timeLab.text = [mo.closeTime stringFMD:@"yyyy-MM-dd HH:mm"];
    _subLab.text = [NSString stringWithFormat:@"+ %@元 (%@)",mo.profitLoss,mo.profitRate];
}

@end
