//
//  KChatLineFootView.m
//  ixit
//
//  Created by litong on 2017/2/21.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "KChatLineFootView.h"

@interface KChatLineFootView ()
{
    NSInteger titCount;
    CGFloat topMargin;
    CGFloat leftMargin;
    CGFloat midMargin;
    CGFloat btnW;
    CGFloat btnH;
}
@property (nonatomic,strong) NSArray *tits;

@property (nonatomic,strong) UIButton *thirdBtn;//@"平仓"、@"暂无持仓"、@"查看持仓"

@end

@implementation KChatLineFootView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        topMargin = 8;
        btnH = self.h_ - 2*topMargin;
        self.backgroundColor = LTTitleRGB;
    }
    return self;
}

- (void)createView {
    [self removeAllSubView];
    if ([LTUser hideDeal]) {
        return;
    }
    NSInteger i = 0;
    for (NSString *str in _tits) {
        CGRect r = CGRectMake(leftMargin + i*(btnW + midMargin), topMargin, btnW, btnH);
        UIButton *btn = [self btnFrame:r title:str];
        [self addSubview:btn];
        [self configBtn:btn];
        
        if (i == 2) {
            self.thirdBtn = btn;
        }
        i ++;
    }
}

#pragma mark - action

- (void)clickBtn:(UIButton *)sender {
    NSString *btnTitle = sender.titleLabel.text;
    
    _kChatLineFootViewBlock ? _kChatLineFootViewBlock(btnTitle) : nil;
}

//@"平仓"、@"暂无持仓"、@"查看持仓"
- (void)changeThirdBtnWithText:(NSString *)txt {
    if (_thirdBtn && titCount >= 3) {
        [_thirdBtn setTitle:txt forState:UIControlStateNormal];
        [self configBtn:_thirdBtn];
    }
}

#pragma mark - utils

- (void)setViewTyp:(KChatLineFootViewType)viewTyp {
    _viewTyp = viewTyp;

  //  if (_viewTyp == KChatLineFootViewType_Buy) {//买涨、买跌
//        self.tits = [NSArray arrayWithObjects:@"买涨",@"买跌", nil];
 //   }
//    else if (_viewTyp == KChatLineFootViewType_BuyAndClose) {//买涨、买跌、平仓
        self.tits = [NSArray arrayWithObjects:@"挂单",@"买涨",@"买跌",@"持仓", nil];
//    }
//    else {//前往交易大厅
//        self.tits = [NSArray arrayWithObjects:@"前往交易大厅", nil];
//    }
    
    titCount = _tits.count;
    if (titCount == 2) {
        leftMargin = 41.5;
        midMargin = 12;
    } else if (titCount == 3) {
        leftMargin = 8.5;
        midMargin = 8;
    } else if (titCount == 4) {
        leftMargin = 8.5;
        midMargin = 8;
    } else {
        leftMargin = 40;
        midMargin = 0;
    }
    btnW = (ScreenW_Lit - 2 * leftMargin - (titCount - 1)*midMargin)/titCount;
    
    [self createView];
}

- (void)configBtn:(UIButton *)btn {
    NSString *btnTitle = btn.titleLabel.text;
    
    if ([btnTitle isEqualToString:@"买涨"]) {
        btn.backgroundColor = LTKLineRed;
        [btn setTitleColor:LTWhiteColor forState:UIControlStateNormal];
        btn.layer.borderWidth = 0;
        btn.layer.borderColor = LTKLineRed.CGColor;
    }
    else if ([btnTitle isEqualToString:@"买跌"]) {
        btn.backgroundColor = LTKLineGreen;
        [btn setTitleColor:LTWhiteColor forState:UIControlStateNormal];
        btn.layer.borderWidth = 0;
        btn.layer.borderColor = LTKLineRed.CGColor;
    }
    else if ([btnTitle isEqualToString:@"前往交易大厅"]) {
        btn.backgroundColor = LTTitleColor;
        [btn setTitleColor:LTSubTitleColor forState:UIControlStateNormal];
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = LTSubTitleColor.CGColor;
    }
    else if ([btnTitle isEqualToString:@"平仓"]) {
        btn.backgroundColor = LTSureFontBlue;
        [btn setTitleColor:LTWhiteColor forState:UIControlStateNormal];
        btn.layer.borderWidth = 0;
        btn.layer.borderColor = LTSureFontBlue.CGColor;
    }
    else if ([btnTitle isEqualToString:@"暂无持仓"]) {
        btn.backgroundColor = LTTitleColor;
        [btn setTitleColor:LTSubTitleColor forState:UIControlStateNormal];
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = LTSubTitleColor.CGColor;
    }
    else if ([btnTitle isEqualToString:@"持仓"]) {
        btn.backgroundColor = LTTitleColor;
        [btn setTitleColor:LTSubTitleColor forState:UIControlStateNormal];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = LTSubTitleColor.CGColor;
    }
    else if ([btnTitle isEqualToString:@"挂单"]) {
        btn.backgroundColor = LTSureFontBlue;
        [btn setTitleColor:LTWhiteColor forState:UIControlStateNormal];
//        btn.layer.borderWidth = 0.5;
//        btn.layer.borderColor = LTSubTitleColor.CGColor;
    }
}

- (UIButton *)btnFrame:(CGRect)frame title:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.titleLabel.font = [UIFont fontOfSize:15];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 3;
    return btn;
}

@end
