
//
//  ProductSingeView.m
//  ixit
//
//  Created by litong on 2017/3/13.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "ProductSingeView.h"

@interface ProductSingeView ()
{
    CGFloat prePrice;
    CGFloat labx;
    CGFloat labw;
}
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *priceLab;

@end

@implementation ProductSingeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        prePrice = 0;
        labx = LTAutoW(12);
        labw = self.w_ - 2*labx;
        [self createView];
    }
    return self;
}

- (void)createView {
    self.userInteractionEnabled = YES;
    
    CGFloat nameFontSize = 17;
    self.nameLab = [self lab:CGRectMake(labx, LTAutoW(12), labw, nameFontSize) color:LTTitleColor font:autoFontSiz(nameFontSize)];
    [self addSubview:_nameLab];
    
    self.priceLab = [self lab:CGRectMake(labx, _nameLab.yh_ +LTAutoW(6), labw, LTAutoW(19)) color:LTSubTitleColor font:autoFontSiz(15)];
    [self addSubview:_priceLab];
    
    [self layerRadius:3 borderColor:LTColorHexA(0x848999, 0.4) borderWidth:0.5];
    
    
    UIButton *btn = [UIButton btnWithTarget:self action:@selector(clickBtn) frame:CGRectMake(0, 0, self.w_, self.h_)];
    [self addSubview:btn];
    [btn setHighlightedBgColor:LTColorHexA(0x848999, 0.1)];
    [btn setNormalBgColor:LTClearColor];
}

- (void)setQuotation:(Quotation *)quotation {
    _quotation = quotation;
    
    self.nameLab.text = quotation.productNamed;
    NSString *price = quotation.price_fmt;
    UIColor *color = LTKLineGreen;
    CGFloat m = [quotation.change floatValue];
    if (m > 0) {
        color = LTKLineRed;
    } else if (m == 0) {
        color = LTGrayColor;
    }
    
    self.priceLab.textColor = color;
    self.priceLab.text = price;
}

- (void)clickBtn {
    _productSingeBlock ? _productSingeBlock(_quotation) : nil;
}


#pragma mark - utils

- (UILabel *)lab:(CGRect)frame color:(UIColor *)color font:(UIFont *)font {
    UILabel *lab = [[UILabel alloc] initWithFrame:frame];
    lab.font = font;
    lab.textColor = color;
    return lab;
}

@end
