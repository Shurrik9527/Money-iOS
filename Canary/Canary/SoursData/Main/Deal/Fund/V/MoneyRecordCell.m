//
//  MoneyRecordCell.m
//  Canary
//
//  Created by litong on 2017/6/2.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "MoneyRecordCell.h"


@interface MoneyRecordCell ()

@property (nonatomic,strong) MoneyRecordMO *mo;

@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *priceLab;
@property (nonatomic,strong) UILabel *stateLab;
@property (nonatomic,strong) UIImageView *nextIV;

@end

@implementation MoneyRecordCell

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
    _titleLab.frame = CGRectMake(kLeftMar, 15, ScreenW_Lit*0.4, 15);
    _titleLab.font = boldFontSiz(15);
    _titleLab.textColor = LTTitleColor;
    [self addSubview:_titleLab];
    
    self.timeLab = [[UILabel alloc] init];
    _timeLab.frame = CGRectMake(kLeftMar, _titleLab.yh_+10, ScreenW_Lit*0.4, 12);
    _timeLab.font = fontSiz(12);
    _timeLab.textColor = LTSubTitleColor;
    [self addSubview:_timeLab];
    
    CGFloat nextIVW = 7;
    CGFloat nextIVH = 11;
    self.nextIV = [[UIImageView alloc] init];
    _nextIV.frame = CGRectMake(ScreenW_Lit - kLeftMar - nextIVW, (kMoneyRecordCellH - nextIVH)/2.0, nextIVW, nextIVH);
    _nextIV.image = [UIImage imageNamed:@"next"];
    [self addSubview:_nextIV];

    
    
    CGFloat subLabW = ScreenW_Lit*0.4;
    CGFloat subLabX = ScreenW_Lit - (kLeftMar + nextIVH + 10 + subLabW);
    
    self.priceLab = [[UILabel alloc] init];
    _priceLab.frame = CGRectMake(subLabX, 12, subLabW, 20);
    _priceLab.font = boldFontSiz(20);
    _priceLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_priceLab];
    
    
    self.stateLab = [[UILabel alloc] init];
    _stateLab.frame = CGRectMake(subLabX, _priceLab.yh_ + 8, subLabW, 12);
    _stateLab.font = fontSiz(12);
    _stateLab.textColor = LTSubTitleColor;
    _stateLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_stateLab];

  
    UIView *lineView = [[UIView alloc] init] ;
    lineView.frame = CGRectMake(0, kMoneyRecordCellH-0.5, ScreenW_Lit, 0.5);
    lineView.backgroundColor = LTLineColor;
    [self addSubview:lineView];
    
}


#pragma mark - 外部

- (void)bindData:(MoneyRecordMO *)mo {

    UIColor *color = LTKLineGreen;
    NSString *amountSymbol = @"-";
    if (_typ == MoneyRecordType_in) {
        color = LTKLineRed;
        amountSymbol = @"+";
    }
    _priceLab.textColor = color;
    
    self.titleLab.text  = mo.name;
    self.timeLab.text = mo.time;
    self.priceLab.text  = [NSString stringWithFormat:@"%@%@", amountSymbol ,mo.amount];
    self.stateLab.text = mo.state;
}

@end
