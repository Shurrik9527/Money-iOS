//
//  AnalystScheduleCell.m
//  ixit
//
//  Created by litong on 2017/3/29.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "AnalystScheduleCell.h"

#define pointWH LTAutoW(7)
#define leftMar LTAutoW(16)
#define topMar LTAutoW(12)
#define labh LTAutoW(19)

@interface AnalystScheduleCell ()

@property (nonatomic,strong) UILabel *descLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UIImageView *iv;
@property (nonatomic,strong) UIImageView *lineIV;

@end


@implementation AnalystScheduleCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

- (void)createCell {
    
    CGFloat timeLabW = LTAutoW(128);
    CGFloat timeLabRM = LTAutoW(20);
    CGFloat timeLabX = ScreenW_Lit - timeLabRM - timeLabW;
    self.timeLab = [self lab:CGRectMake(timeLabX, topMar, timeLabW, labh) fontSize:15 color:LTSubTitleColor];
    _timeLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_timeLab];
    
    
    CGFloat descLabX = LTAutoW(29);
    CGFloat descLabW = timeLabX - descLabX;
    self.descLab = [self lab:CGRectMake(descLabX, topMar, descLabW, labh) fontSize:15 color:LTSubTitleColor];
    [self addSubview:_descLab];
    
    self.lineIV = [[UIImageView alloc] init];
    _lineIV.frame = CGRectMake(leftMar+(pointWH/2.0)-LTAutoW(0.5), 0, LTAutoW(1), pointWH);
    UIColor *linebgcolor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"live_pic_Dotted"]];
    _lineIV.backgroundColor = linebgcolor;
    [self addSubview:_lineIV];
    
    self.iv = [[UIImageView alloc] init];
    _iv.frame = CGRectMake(leftMar, topMar + (labh - pointWH)/2.0, pointWH, pointWH);
    _iv.image = [UIImage imageNamed:@"outcry_dian"];
    [self addSubview:_iv];

}

- (UILabel *)lab:(CGRect)frame fontSize:(CGFloat)fontSize color:(UIColor *)color {
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = frame;
    lab.font = autoFontSiz(fontSize);
    lab.textColor = color;
    return lab;
}

#pragma mark - 外部


- (void)bindData:(LiveTimeMo *)mo row:(BOOL)row {
    if (row == 0) {
        _lineIV.frame = CGRectMake(leftMar+(pointWH/2.0)-LTAutoW(0.5), topMar, LTAutoW(1), LTAutoW(kAnalystScheduleCellH) - topMar);
    } else {
        _lineIV.frame = CGRectMake(leftMar+(pointWH/2.0)-LTAutoW(0.5), 0, LTAutoW(1), LTAutoW(kAnalystScheduleCellH));
    }
    
    _descLab.text = mo.liveDescription;
    _timeLab.text = mo.liveTime;
    
    //直播状态（0，未直播，1直播中，2完成直播）
    NSInteger status = mo.status;
    if (status == 2) {//完成
        self.iv.image = [UIImage imageNamed:@"outcry_dian"];
        _descLab.textColor = LTSubTitleColor;
        _timeLab.textColor = LTSubTitleColor;
    }
    else if (status == 1) {//进行中
        self.iv.image = [UIImage imageNamed:@"outcry_dian1"];
        _descLab.textColor = LTTitleColor;
        _timeLab.textColor = LTTitleColor;
    }
    else {//未开始
        self.iv.image = [UIImage imageNamed:@"outcry_dian2"];
        _descLab.textColor = LTTitleColor;
        _timeLab.textColor = LTTitleColor;
    }
    
}

@end



