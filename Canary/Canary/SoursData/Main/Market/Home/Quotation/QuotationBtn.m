
//
//  QuotationBtn.m
//  ixit
//
//  Created by litong on 2016/11/10.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "QuotationBtn.h"
#import "NSObject+MJUtils.h"
#import "UIView+LTGesture.h"
#import "SocketModel.h"
@interface QuotationBtn ()
{
    CGFloat oldPrice;
}

@property (nonatomic,strong)BuySellingModel *quotation;
@property (nonatomic,strong)NSString *name;

@end

@implementation QuotationBtn

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = LTWhiteColor;
        [self createView];
    }
    return self;
}

- (void)createView {
    
    self.nameLab = [self lab:0];
    [self addSubview:_nameLab];
    
    self.priceLab = [self lab:1];
    [self addSubview:_priceLab];
    
    self.changeLab = [self lab:2];
    [self addSubview:_changeLab];
    
    CGFloat lineH = LTAutoW(64);
    [self addLine:LTLineColor frame:CGRectMake(self.w_-0.5, (self.h_ - lineH)/2.0, 0.5, lineH)];
    
    [self addSingeTap:@selector(bgViewAction) target:self];
    
}
#pragma mark - socketModle
-(void)socketmodel:(BuySellingModel *)m
{
    
    _priceLab.text = [m price];
    CGFloat price = [[m price] doubleValue];
    oldPrice = [m.close floatValue];
    CGFloat changeValue =price - oldPrice;
    float  gains =changeValue/price * 100;
    NSString *change = [NSString stringWithFormat:@"%@%%",[NSString stringWithFormat:@"%.3f",gains]];
    NSString *changerate = [NSString stringWithFormat:@"%.2f",changeValue];
        if (emptyStr(change) || emptyStr(changerate) || price == 0) {
            return;
        }
        self.quotation = m;
        [self bgFlicker:price];

        UIColor *color = LTKLineGreen;
        if ([change floatValue]>0) {
            color=LTKLineRed;
            change=[NSString stringWithFormat:@"+%@",change];
            changerate=[NSString stringWithFormat:@"+%@",[NSString stringWithFormat:@"%.2f",changeValue]];
        } else if ([change floatValue] == 0) {
            color=LTGrayColor;
        }
        _changeLab.text = [NSString stringWithFormat:@"%@%@%@",change,@"  ",changerate];
        _priceLab.textColor = color;
        _changeLab.textColor = color;
    
}
#pragma mark - 外部
- (void)refData:(BuySellingModel *)q {
    _nameLab.text =  [q symbolName];
    
    
    _priceLab.text = q.maxPrice;
    CGFloat price = [q.maxPrice doubleValue];
    oldPrice = [q.close floatValue];
    CGFloat changeValue =price - oldPrice;
    float  gains =changeValue/price * 100;
    NSString *change = [NSString stringWithFormat:@"%@%%",[NSString stringWithFormat:@"%.3f",gains]];
    NSString *changerate = [NSString stringWithFormat:@"%.2f",changeValue];
    if (emptyStr(change) || emptyStr(changerate) || price == 0) {
        return;
    }
    [self bgFlicker:price];
    self.name = q.symbolName;

    self.quotation = q;
    UIColor *color = LTKLineGreen;
    if ([change floatValue]>0) {
        color=LTKLineRed;
        change=[NSString stringWithFormat:@"+%@",change];
        changerate=[NSString stringWithFormat:@"+%@",[NSString stringWithFormat:@"%.2f",changeValue]];
    } else if ([change floatValue] == 0) {
        color=LTGrayColor;
    }
    _changeLab.text = [NSString stringWithFormat:@"%@%@%@",change,@"  ",changerate];
    _priceLab.textColor = color;
    _changeLab.textColor = color;
    
}
//背景闪动
- (void)bgFlicker:(CGFloat)price {
    UIColor *color = LTKLineGreen;
    if (price >= oldPrice && oldPrice > 0) {
        color = LTKLineRed;
    }
    
    
    UIView *bg = [[UIView alloc] init];
    bg.frame = CGRectMake(0, 0, self.w_, self.h_);
    bg.backgroundColor = LTWhiteColor;
    [self insertSubview:bg belowSubview:_nameLab];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, self.w_, self.h_);
    [self insertSubview:bgView belowSubview:_nameLab];
    
    bgView.layer.backgroundColor = color.CGColor;
    bgView.layer.cornerRadius = 2;
    bgView.layer.opacity = 0.1;
    
    [UIView animateWithDuration:0.3 animations:^{
        bgView.layer.opacity = 0.2;
    } completion:^(BOOL isfinish){
        [UIView animateWithDuration:0.3 animations:^{
            bgView.layer.opacity = 0;
        } completion:^(BOOL isfinish){
            [bgView removeFromSuperview];
            [bg removeFromSuperview];
        }];
    }];
    
    bgView = nil;
    bg = nil;
}
- (UILabel *)lab:(NSInteger)type {
    UILabel *lab = [[UILabel alloc] init];
    
    CGRect frame = CGRectZero;
    UIColor *color = nil;
    UIFont *font = nil;
    if (type == 0) {//nameLab  :  哈贵油
        color = LTTitleColor;
        font = [UIFont autoFontSize:15.f];
        frame = CGRectMake(0, LTAutoW(12.f), [QuotationBtn viewW], LTAutoW(21.f));
    } else if (type == 1) {//priceLab  :  2464.7
        color = LTKLineGreen;
        font = [UIFont autoFontSize:24.f];
        frame = CGRectMake(0, LTAutoW(36.f), [QuotationBtn viewW], LTAutoW(24.f));
    } else {//changeLab  :  -10.7  -0.41%
        color = LTKLineGreen;
        font = [UIFont autoFontSize:12.f];
        frame = CGRectMake(0, LTAutoW(64.f), [QuotationBtn viewW], LTAutoW(20.f));
    }
    
    lab.frame = frame;
    lab.textColor = color;
    lab.font = font;
    lab.textAlignment = NSTextAlignmentCenter;
    
    return lab;
}
- (void)bgViewAction {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NFC_ClickQuotationBtn object:_quotation];
    
}

+ (CGFloat)viewH {
    CGFloat h = LTAutoW(QuotationBtnH);
    return h;
}

+ (CGFloat)viewW {
    CGFloat w = ScreenW_Lit/3.0;
    return w;
}

@end
