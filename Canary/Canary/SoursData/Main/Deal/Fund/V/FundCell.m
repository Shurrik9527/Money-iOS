//
//  FundCell.m
//  Canary
//
//  Created by litong on 2017/6/1.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "FundCell.h"


@interface FundCell ()

@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *detailLab;
@property (nonatomic,strong) UIImageView *nextIV;

@end

@implementation FundCell

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
    self.titleLab = [[UILabel alloc] init];
    _titleLab.frame = CGRectMake(kLeftMar, 0, ScreenW_Lit*0.5, kFundCellH);
    _titleLab.font = fontSiz(15);
    _titleLab.textColor = LTTitleColor;
    [self addSubview:_titleLab];
    
    
    CGFloat mar = 32;
    CGFloat detailLabW = ScreenW_Lit*0.5;
    self.detailLab = [[UILabel alloc] init];
    _detailLab.frame = CGRectMake(ScreenW_Lit - mar - detailLabW, 0, detailLabW, kFundCellH);
    _detailLab.font = fontSiz(15);
    _detailLab.textColor = LTSubTitleColor;
    _detailLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_detailLab];

    
    CGFloat nextIVW = 7;
    CGFloat nextIVH = 11;
    self.nextIV = [[UIImageView alloc] init];
    _nextIV.frame = CGRectMake(ScreenW_Lit - kLeftMar - nextIVW, (kFundCellH - nextIVH)/2.0, nextIVW, nextIVH);
    _nextIV.image = [UIImage imageNamed:@"next"];
    [self addSubview:_nextIV];

    
    UIView *lineView = [[UIView alloc] init] ;
    lineView.frame = CGRectMake(0, kFundCellH-0.5, ScreenW_Lit, 0.5);
    lineView.backgroundColor = LTLineColor;
    [self addSubview:lineView];
    
}


- (void)bindData:(NSString *)title {
    _titleLab.text = title;
}

- (void)changeDetails:(NSString *)detail {
    _detailLab.text = detail;
}

@end
