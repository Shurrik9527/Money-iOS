//
//  QuickDealListView.m
//  ixit
//
//  Created by litong on 2017/3/13.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "QuickDealListView.h"

@interface QuickDealListView ()

@property (nonatomic,strong) UIButton *btn0;
@property (nonatomic,strong) UIButton *btn1;
@property (nonatomic,strong) UIButton *btn2;

@end

@implementation QuickDealListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = LTClearColor;
        [self createView];
    }
    return self;
}

#define kQuickBtnTag 10000

#define kQuickBtnW  66
#define kQuickBtnH  36
#define kQuickLineH  0.5
#define kQuickLineColor LTColorHex(0xC5D0E8)
#define kQuickBtnHighlightedColor LTColorHex(0xEDF2FD)
#define kQuickShadowColor LTRGB(195, 206, 231)

- (void)createView {

    CGFloat x = kQuickDealViewW - kQuickBtnW;
    CGFloat sy = kQuickDealViewH - 3*kQuickBtnH;
    
    //阴影
    UIView *shadowView = [[UIView alloc] init];
    shadowView.frame = CGRectMake(x, 0, kQuickDealViewW, 3*kQuickBtnH);
    [self addSubview:shadowView];
    shadowView.backgroundColor = LTWhiteColor;
    [shadowView layerShadowOffset:CGSizeMake(-x, sy)
                       color:kQuickShadowColor
                     opacity:0.3
                      radius:2];
    shadowView.layer.cornerRadius = 5.0;
    
    
    //按钮背景
    UIView *btnBaseView = [[UIView alloc] init];
    btnBaseView.frame = CGRectMake(x, 0, kQuickDealViewW, 3*kQuickBtnH);
    [self addSubview:btnBaseView];
    [btnBaseView layerRadius:5.0 corners:(UIRectCornerTopLeft|UIRectCornerBottomLeft) rect:CGRectMake(0, 0, kQuickBtnW, 3*kQuickBtnH) strokeColor:kQuickLineColor lineWidth:1];
    
    self.btn0 = [self btn:CGRectMake(0.5, 0.5, kQuickBtnW, kQuickBtnH) title:@"建仓"];
    _btn0.tag = kQuickBtnTag;
    [btnBaseView addSubview:_btn0];
    [_btn0 layerRadius:5 corners:UIRectCornerTopLeft];
    [self addLineInView:_btn0];
    
    self.btn1 = [self btn:CGRectMake(0.5, _btn0.yh_, kQuickBtnW, kQuickBtnH) title:@"平仓"];
    _btn1.tag = kQuickBtnTag+1;
    [btnBaseView addSubview:_btn1];
    [self addLineInView:_btn1];
    
    self.btn2 = [self btn:CGRectMake(0.5, _btn1.yh_, kQuickBtnW, kQuickBtnH-1) title:@"行情"];
    _btn2.tag = kQuickBtnTag+2;
    [btnBaseView addSubview:_btn2];
    [_btn2 layerRadius:5 corners:UIRectCornerBottomLeft];
    
}

#pragma mark  - utils

- (void)addLineInView:(UIView *)view {
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(0, kQuickBtnH-kQuickLineH, kQuickBtnW, kQuickLineH);
    line.backgroundColor = kQuickLineColor;
    [view addSubview:line];
}

- (UIButton *)btn:(CGRect)frame title:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setBackgroundImage:[UIImage imageWithColor:kQuickBtnHighlightedColor size:CGSizeMake(kQuickBtnW, kQuickBtnH)] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:LTColorHex(0x4877E6) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontOfSize:15];

    return btn;
}

#pragma mark - action

- (void)clickBtn:(UIButton *)sender {
    NSInteger row = sender.tag % kQuickBtnTag;
    _quickDealBlock ? _quickDealBlock(row) : nil;
}

#pragma mark  - 外部

- (void)configSellNum:(NSInteger)num {
    if (num > 9) {
        _btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _btn1.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _btn0.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _btn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    } else {
        _btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _btn1.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _btn0.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _btn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    NSString *numStr = [NSString stringWithFormat:@"(%ld)",num];
    NSString *sellStr = [NSString stringWithFormat:@"平仓%@",numStr];
    NSAttributedString *AbStr = [sellStr ABStrColor:LTSubTitleColor font:[UIFont fontOfSize:12] range:NSMakeRange(2, numStr.length)];
    [_btn1 setAttributedTitle:AbStr forState:UIControlStateNormal];
}


@end
