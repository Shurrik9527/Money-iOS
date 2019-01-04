//
//  LiveTimeCell.m
//  ixit
//
//  Created by litong on 2016/12/29.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "LiveTimeCell.h"

@interface LiveTimeCell ()

@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *nameLab;

@end


@implementation LiveTimeCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

- (void)createCell {
    CGFloat leftMar = 20;
    self.timeLab = [self lab:CGRectMake(LTAutoW(leftMar), LTAutoW(12.5), LTAutoW(160), LTAutoW(15)) fontSize:15 color:LTSubTitleColor];
    [self addSubview:_timeLab];
    
    self.titleLab = [self lab:CGRectMake(LTAutoW(leftMar), _timeLab.yh_ + LTAutoW(9), LTAutoW(160), LTAutoW(15)) fontSize:15 color:LTTitleColor];
    [self addSubview:_titleLab];
    
    CGFloat nameW = 100;
    self.nameLab = [self lab:CGRectMake(LTAutoW(LiveTimeCellW - leftMar - nameW), _titleLab.y_, LTAutoW(nameW), LTAutoW(15)) fontSize:15 color:LTTitleColor];
    _nameLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_nameLab];
    
    UIView *lineView = [[UIView alloc] init] ;
    lineView.frame = CGRectMake(0, LTAutoW(LiveTimeCellH) - 0.5, self.w_, 0.5);
    lineView.backgroundColor = LTLineColor;
    [self addSubview:lineView];
}

- (UILabel *)lab:(CGRect)frame fontSize:(CGFloat)fontSize color:(UIColor *)color {
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = frame;
    lab.font = autoFontSiz(fontSize);
    lab.textColor = color;
    return lab;
}

#pragma mark - 外部

- (void)bindData:(LiveTimeMo *)mo {
    _timeLab.text = mo.liveTime;
    _titleLab.text = mo.liveDescription;
    _nameLab.text = mo.authorName;
}

@end
