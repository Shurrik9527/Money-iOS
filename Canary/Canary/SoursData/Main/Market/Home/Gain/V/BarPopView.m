//
//  BarPopView.m
//  ixit
//
//  Created by litong on 2016/11/15.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "BarPopView.h"

@interface BarPopView ()

@property (nonatomic,strong) UIImageView *gainImgView;

@end

@implementation BarPopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createBgView];
        [self createView];
    }
    return self;
}

- (void)createBgView {
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, self.w_, self.h_);
    bgView.backgroundColor = LTRGBA(0, 0, 0, 0.6);
    [self addSubview:bgView];
    [bgView addSingeTap:@selector(clickBgView) target:self];
}

- (void)clickBgView {
    self.hidden = YES;
}

static CGFloat gainImgViewW = 278.f;
//static CGFloat gainImgViewH = 200.f;

- (void)createView {
    
    CGFloat titleLabY = 32;
    CGFloat titleLabH = 15;
    CGFloat contentLeftMar = 16.f;
    CGFloat contentTopMar = 12.f;
    CGFloat contentW = LTAutoW(gainImgViewW-2*contentLeftMar);
    
    NSAttributedString *ABStr = [self ABStr:@"1. 将当前交易日内8:00到次日凌晨4:00间盈利的平仓单晒单至朋友圈 (用券单不可参加)。\n2. 盈利率排名前20者即可上榜，产生前三名后，榜单实时更新。\n3. 上榜者奖金由系统在次日凌晨5:00自动发放。"];
    CGSize size = [ABStr autoSize:CGSizeMake(contentW, MAXFLOAT)];
    
    self.gainImgView = [[UIImageView alloc] init];
    _gainImgView.frame = CGRectMake(ScreenW_Lit-LTAutoW(gainImgViewW)-2, -10, LTAutoW(gainImgViewW), LTAutoW(titleLabY+titleLabH+2*contentTopMar)+size.height);

    _gainImgView.image = [[UIImage imageNamed:@"bar_pop"] stretchMiddle];
    [self addSubview:_gainImgView];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.frame = CGRectMake(LTAutoW(15), LTAutoW(titleLabY), 100.f, LTAutoW(titleLabH));
    titleLab.font = autoBoldFontSiz(13.f);
    titleLab.textColor = LTTitleColor;
    titleLab.text = @"上榜规则：";
    [_gainImgView addSubview:titleLab];
    
    CGFloat contentLabY = LTAutoW(titleLabY+titleLabH+contentTopMar);
    UILabel *contentLab = [[UILabel alloc] init];
    contentLab.frame = CGRectMake(LTAutoW(contentLeftMar), contentLabY, contentW, size.height);
    contentLab.font = autoFontSiz(12.f);
    contentLab.textColor = LTTitleColor;
    contentLab.numberOfLines = 0;
    contentLab.attributedText = ABStr;
    [_gainImgView addSubview:contentLab];

    self.hidden = YES;
}



- (NSAttributedString *)ABStr:(NSString *)str {
    NSMutableAttributedString *ABStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSRange range = NSMakeRange(0, str.length);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4.f;
    paragraphStyle.paragraphSpacing = 6.f;
    paragraphStyle.headIndent = 14.f;
    [ABStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [ABStr addAttribute:NSFontAttributeName value:autoFontSiz(12) range:range];
    
    return ABStr;
}

#pragma mark - 外部

- (void)show {
    self.hidden = NO;
}


@end
