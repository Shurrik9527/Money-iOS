//
//  WarningView.m
//  Canary
//
//  Created by litong on 2017/6/8.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "WarningView.h"

#define kViewH  20

@interface WarningView ()
{
    CGFloat tm;//上边距
    CGFloat lm;//左边距
    CGFloat ivwh;//图片宽高
    CGFloat labx;//lab的左边距
    CGFloat labw;//lab的宽度
    UIFont *font;//lab字体大小
}
@property (nonatomic,strong) UIImageView *iconIV;
@property (nonatomic,strong) UILabel *lab;

@end

@implementation WarningView

- (instancetype)initWithY:(CGFloat)y {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, y, ScreenW_Lit, kViewH);
        [self createView];
    }
    return self;
}

- (void)createView {
    tm = 4;//上边距
    lm = 10;//左边距
    ivwh = 13;//图片宽高
    labx = lm + ivwh + 6;//lab的左边距
    labw = ScreenW_Lit - 2 - labx;//lab的宽度
    font = [UIFont fontOfSize:12];//lab字体大小
    
    self.iconIV = [[UIImageView alloc] init];
    _iconIV.frame = CGRectMake(lm, tm, ivwh, ivwh);
    _iconIV.image = [UIImage imageNamed:_imgName];
    _iconIV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_iconIV];
    
    self.lab = [[UILabel alloc] init];
    _lab.frame = CGRectMake(labx, 0, labw, self.h_);
    _lab.font = font;
    _lab.numberOfLines = 0;
    [self addSubview:_lab];
    
}

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    self.backgroundColor = _bgColor;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.lab.textColor = textColor;
}

- (void)setImgName:(NSString *)imgName {
    _imgName = imgName;
    self.iconIV.image = [UIImage imageNamed:_imgName];
}

- (void)setContent:(NSString *)content {
    if (ScreenW_Lit <= 320 && [content contains:@"合约到期提醒"]) {
        content = [content replacStr:@"合约到期提醒" withStr:@"提醒"];
    }
    _content = content;
    
    CGSize size = [_content boundingSize:CGSizeMake(labw, MAXFLOAT) font:font];
    CGFloat sh = size.height;
    CGFloat h =  (sh <= 20) ? 20 : (sh + 12);
    
    [self setSH:h];
    [self.lab setSH:h];
    self.lab.text = _content;
    
    [_iconIV setCenterY:_lab.center.y];
}


#pragma mark - 外部

+ (WarningView *)orangeView:(CGFloat)y {
    WarningView *view = [[WarningView alloc] initWithY:y];
    view.textColor = LTWhiteColor;
    view.bgColor = LTColorHex(0xffa14d);
    return view;
}

+ (WarningView *)pinkView:(CGFloat)y {
    WarningView *view = [[WarningView alloc] initWithY:y];
    view.textColor = LTKLineRed;
    view.bgColor = LTColorHex(0xffe5e3);
    return view;
}

@end
