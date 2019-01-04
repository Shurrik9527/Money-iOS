//
//  KLineOtherIndexView.m
//  FMStock
//
//  Created by dangfm on 15/5/24.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

#import "KLineOtherIndexView.h"
@interface KLineOtherIndexView(){
    UIView *_superView;
    UIView *_box;
    UIView *_maskview;
    NSMutableArray *_data;
    BOOL _isHide;
}

@end
@implementation KLineOtherIndexView

-(void)dealloc{
    [self removeFromSuperview];
    _superView = nil;
    _box = nil;
    _maskview = nil;
}

-(instancetype)initWithFrame:(CGRect)frame SuperView:(UIView*)superview Data:(NSArray*)data{
    if (self=[super initWithFrame:frame]) {
        _superView = superview;
        _data = [NSMutableArray arrayWithArray:data];
        _isHide = YES;
        [self initViews];
    }
    return self;
}

-(void)show{
    if (_isHide) {
        [self removeFromSuperview];
        [_superView addSubview:self];
        _box.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
        [UIView animateWithDuration:0.3 animations:^{
            _maskview.alpha = 0.5;
            _box.alpha = 1;
            _box.transform = CGAffineTransformMakeScale(1.01f, 1.01f);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.1 animations:^{
                _box.transform = CGAffineTransformMakeScale(0.99f, 0.99f);
            } completion:^(BOOL finished){
                [UIView animateWithDuration:0.1 animations:^{
                    _box.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                } completion:^(BOOL finished){
                    
                }];
            }];
        }];
    }
    
}

-(void)hide{
    
    [UIView animateWithDuration:0.2 animations:^{
        _box.transform = CGAffineTransformMakeScale(1.01f, 1.01f);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.2 animations:^{
            _maskview.alpha = 0;
            _box.alpha = 0;
            _box.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
        } completion:^(BOOL finished){
            [self removeFromSuperview];
        }];
    }];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan");
    UIView *touchView = [self hitTest:[touches.anyObject locationInView:self] withEvent:event];
    if (touchView.tag!=10010) {
        [self hide];
    }
    
}

-(void)initViews{
    self.layer.backgroundColor = LTClearColor.CGColor;
    _maskview = [[UIView alloc] initWithFrame:self.frame];
    [self addSubview:_maskview];
    _maskview.layer.backgroundColor = LTColorHex(0x000000).CGColor;
    _maskview.layer.opacity = 0.5;
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat h = 210;
    CGFloat w = self.frame.size.width*0.8;
    x = (self.frame.size.width-w)/2;
    y = (self.frame.size.height-h)/2;
    // 添加一个盒子
    _box = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
//    _box.backgroundColor = LTColorHex(0xFFFFFF);
    _box.tag = 10010;
    _box.alpha = 0.0;
    _box.layer.borderColor = LTColorHex(0x000000).CGColor;
    _box.layer.borderWidth = 1;
    _box.layer.cornerRadius = 3;
    [self addSubview:_box];
    // k线周期
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, _box.frame.size.width, 50)];
    l.font = [UIFont fontWithName:kFontName size:18];
    l.textColor = LTHEX(0x469cff);
    l.text = @"K线周期";
    [_box addSubview:l];
    
    [LTUtils drawLineAtSuperView:_box andTopOrDown:0 andHeight:2 andColor:l.textColor andFrame:CGRectMake(0, 50, _box.frame.size.width, 3)];
    l = nil;
    x = 0;
    y = 53;
    h = 50;
    //if(h>30) h = 30;
    int i = 0;
    UIFont *font = [UIFont fontWithName:kFontName size:20];
    for (NSString *value in _data) {
        
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(x, y+(i*h), _box.frame.size.width, h)];
        bt.backgroundColor = LTClearColor;
        [bt setTitle:value forState:UIControlStateNormal];
        bt.titleLabel.font = font;
        
        bt.tag = i;
        [bt setTitleColor:LTColorHex(0x000000) forState:UIControlStateNormal];
        [bt addTarget:self action:@selector(clickButtons:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat textlen = [bt.titleLabel.text sizeWithFont:bt.titleLabel.font].width;
        [bt setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, bt.frame.size.width-textlen-35)];
        [bt setBackgroundImage:[UIImage imageWithColor:LTColorHex(0xCCCCCC) size:bt.frame.size] forState:UIControlStateHighlighted];
        [bt setBackgroundImage:[UIImage imageWithColor:LTColorHex(0xFFFFFF) size:bt.frame.size] forState:UIControlStateNormal];
        [_box addSubview:bt];
        // 画根线
//        [LTUtils drawLineAtSuperView:bt andTopOrDown:1 andHeight:0.5 andColor:LTColorHex(0xCCCCCC)];
        bt = nil;
        i++;
    }
    
    UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(x, y+(i*h), _box.frame.size.width, h)];
    bt.backgroundColor = LTClearColor;
    [bt setTitle:@"关闭" forState:UIControlStateNormal];
    bt.titleLabel.font = font;
    bt.titleLabel.textAlignment = NSTextAlignmentLeft;
    bt.tag = i;
    [bt setTitleColor:LTColorHex(0x000000) forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(closeButtonBundle) forControlEvents:UIControlEventTouchUpInside];
    [bt setBackgroundImage:[UIImage imageWithColor:LTColorHex(0xCCCCCC) size:bt.frame.size] forState:UIControlStateHighlighted];
    [bt setBackgroundImage:[UIImage imageWithColor:LTColorHex(0xFFFFFF) size:bt.frame.size] forState:UIControlStateNormal];
    [_box addSubview:bt];
    bt = nil;
    
}
-(void)closeButtonBundle{
    [self hide];
    if (self.clickSelectButtonsBlock) {
        self.clickSelectButtonsBlock(@"");
    }
}
-(void)clickButtons:(UIButton*)button{
    [self hide];
    NSString *code = @"";
    if (button.tag==0) {
        code = @"min15";
    }else{
        code = @"hr4";
    }
    if (self.clickSelectButtonsBlock) {
        self.clickSelectButtonsBlock(code);
    }
}

@end
