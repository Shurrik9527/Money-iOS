//
//  QuickDealHoldCell.m
//  Canary
//
//  Created by litong on 2017/5/16.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "QuickDealHoldCell.h"

@interface QuickDealHoldCell ()

//做多1手 | 做空1收
@property (nonatomic,strong) UILabel *upDownNumLab;
//盈利或亏损
@property (nonatomic,strong) UILabel *earnLab;
//建仓价
@property (nonatomic,strong) UILabel *priceLab;
//建仓时间
@property (nonatomic,strong) UILabel *timeLab;
//是否选中
@property (nonatomic,strong) UIButton *selectBtn;

@end

@implementation QuickDealHoldCell

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
    
    CGFloat left = 16;
    CGFloat right = 13;
    CGFloat ivwh = 30;
    CGFloat vw = ScreenW_Lit - left - right - ivwh;
    
    
    //做多1手 | 做空1收
    CGFloat numPer = 0.45;
    CGFloat numH = 37;
    self.upDownNumLab = [UILabel labRect:CGRectMake(kLeftMar, 0, vw*numPer, numH) font:boldFontSiz(15) textColor:LTTitleColor];
    [self addSubview:self.upDownNumLab];
    
    //盈利或亏损
    CGFloat earnW = vw*(1-numPer);
    self.earnLab = [UILabel labRect:CGRectMake(self.upDownNumLab.xw_, 0, earnW, numH) font:boldFontSiz(20) textColor:LTTitleColor];
    [self addSubview:self.earnLab];
    
    //建仓价
    self.priceLab = [UILabel labRect:CGRectMake(self.upDownNumLab.x_, self.upDownNumLab.yh_, self.upDownNumLab.w_, 15) font:fontSiz(15) textColor:LTTitleColor];
    [self addSubview:self.priceLab];
    //建仓时间
    self.timeLab = [UILabel labRect:CGRectMake(self.earnLab.x_, self.earnLab.yh_, self.earnLab.w_, 15) font:fontSiz(15) textColor:LTSubTitleColor];
    [self addSubview:self.timeLab];
    
    //选中图片
    CGRect frame = CGRectMake(ScreenW_Lit - right - ivwh, (kQuickDealHoldCellH - ivwh)*0.5, ivwh, ivwh);
    self.selectBtn = [UIButton btnWithTarget:self action:@selector(selectAction) frame:frame];
    [self.selectBtn setNorImageName:@"grayQuanBG"];
    [self.selectBtn setSelImageName:@"blueCheck"];
    self.selectBtn.selected = NO;
    [self addSubview:self.selectBtn];
    
    
    UIView *line = [UIView lineFrame:CGRectMake(0, 0, ScreenW_Lit, 0.5) color:LTLineColor];
    [self addSubview:line];
}


- (void)selectAction {
    
}

- (void)selectedCell:(BOOL)sel {
    self.selectBtn.selected = sel;
}



@end
