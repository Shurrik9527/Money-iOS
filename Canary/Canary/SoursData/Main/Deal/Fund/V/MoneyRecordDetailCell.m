//
//  MoneyRecordDetailCell.m
//  Canary
//
//  Created by litong on 2017/6/2.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "MoneyRecordDetailCell.h"

@interface MoneyRecordDetailCell ()

@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *contentLab;


@end

@implementation MoneyRecordDetailCell

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
    
    CGFloat titleLabW = 70;
    CGFloat labh = kMoneyRecordDetailCellH;
    self.titleLab = [[UILabel alloc] init];
    _titleLab.frame = CGRectMake(kLeftMar, 0, titleLabW, labh);
    _titleLab.font = boldFontSiz(15);
    _titleLab.textColor = LTTitleColor;
    _titleLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_titleLab];
    
    CGFloat contentx = _titleLab.xw_+15;
    self.contentLab = [[UILabel alloc] init];
    _contentLab.frame = CGRectMake(contentx, 0, ScreenW_Lit - contentx - kLeftMar, labh);
    _contentLab.font = fontSiz(15);
    _contentLab.textColor = LTSubTitleColor;
    [self addSubview:_contentLab];
    
    UIView *lineView = [[UIView alloc] init] ;
    lineView.frame = CGRectMake(0, labh-0.5, ScreenW_Lit, 0.5);
    lineView.backgroundColor = LTLineColor;
    [self addSubview:lineView];
    
}

#pragma mark - 外部

- (void)bindData:(NSDictionary *)dict {
    NSString *title = [dict stringFoKey:key_MRDC_Title];
    NSString *contet = [dict stringFoKey:key_MRDC_Content];
    self.titleLab.text = title;
    self.contentLab.text = contet;
}

@end
