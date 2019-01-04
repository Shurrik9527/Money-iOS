//
//  KLineTianjiNavView.m
//  golden_iphone
//
//  Created by dangfm on 15/7/8.
//  Copyright (c) 2015年 golden. All rights reserved.
//

#import "KLineTianjiNavView.h"

@implementation KLineTianjiNavView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self createViews];
    }
    return self;
}

-(void)createViews{
    self.backgroundColor = KLineBoxBG;
    _buttonTag = 100;
    CGFloat w = 60;
    CGFloat h = 30;
    CGFloat x = 10;
    CGFloat y = (self.frame.size.height-h)/2;
    // 震荡版
    [self createButtonWithFrame:CGRectMake(x, y, w, h) Title:@"震荡版" Tag:100];
    // 趋势版
    [self createButtonWithFrame:CGRectMake(2*x+w, y, w, h) Title:@"趋势版" Tag:101];
    // 帮助按钮
    UIImage *helpimg =  [UIImage imageNamed:@"kline/icon_dk_help_default"];
    [self createHelpButtonWithFrame:CGRectMake(self.frame.size.width-x-helpimg.size.width, 0, helpimg.size.width+x, self.frame.size.height) Image:helpimg Tag:102];
    helpimg = nil;
    // 当前信号时间
    _time = [[UILabel alloc] initWithFrame:CGRectMake(3*x+2*w-5, 0, self.frame.size.width-3*x-2*w-helpimg.size.width, self.frame.size.height)];
    _time.font = kLineTianjiNavView_TimeFont;
//    _time.textColor = kLineTianjiNavView_TextColor;
    _time.text = @"当前信号时间: 07-07 15:10";
    _time.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_time];
    
    [LTUtils drawLineAtSuperView:self andTopOrDown:1 andHeight:0.5 andColor:LTHEX(0x469cff)];
    
}

-(void)createButtonWithFrame:(CGRect)frame Title:(NSString*)title Tag:(NSInteger)tag{
    UIButton *bt = [[UIButton alloc] initWithFrame:frame];
    [bt setBackgroundColor:LTClearColor];
    [bt setTitle:title forState:UIControlStateNormal];
    bt.titleLabel.font = kLineTianjiNavView_Font;
    [bt setTitleColor:kLineTianjiNavView_TextColor forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [bt setBackgroundImage:[UIImage imageWithColor:LTHEX(0x24273E) size:frame.size] forState:UIControlStateHighlighted];
    bt.layer.cornerRadius = 3;
    bt.layer.borderColor = LTHEX(0x24273E).CGColor;
    bt.layer.borderWidth = 0.5;
    bt.clipsToBounds = YES;
    bt.tag = tag;
    [bt addTarget:self action:@selector(clickButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
    if (tag==kLineTianjiNavView_DefaulHighlightsIndex) {
        [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bt setBackgroundImage:[UIImage imageWithColor:LTHEX(0x24273E) size:frame.size] forState:UIControlStateNormal];
    }
    [self addSubview:bt];
    bt = nil;
}
-(void)createHelpButtonWithFrame:(CGRect)frame Image:(UIImage*)img Tag:(NSInteger)tag{
    UIButton *bt = [[UIButton alloc] initWithFrame:frame];
    [bt setBackgroundColor:LTClearColor];
    [bt setImage:img forState:UIControlStateNormal];
//    [bt setImage:[LTUtils imageWithTintColor:LTHEX(0x469cff) blendMode:kCGBlendModeDestinationIn WithImageObject:img] forState:UIControlStateHighlighted];
    bt.tag = tag;
    [bt addTarget:self action:@selector(clickButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bt];
    bt = nil;
}
#pragma mark 点击按钮
-(void)clickButtonHandle:(UIButton*)bt{
    NSInteger tag = bt.tag;
    _buttonTag = (int)tag;
    NSLog(@"tag=%ld",(long)tag);
    if (tag<102) {
        for (int i=100; i<102; i++) {
            UIButton *bt = (UIButton*)[self viewWithTag:i];
            [bt setTitleColor:kLineTianjiNavView_TextColor forState:UIControlStateNormal];
            [bt setBackgroundImage:[UIImage imageWithColor:self.backgroundColor size:bt.frame.size] forState:UIControlStateNormal];
            bt = nil;
        }
        [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bt setBackgroundImage:[UIImage imageWithColor:LTHEX(0x24273E) size:bt.frame.size] forState:UIControlStateNormal];
    }
    
    
    if (self.clickTianjiNavViewButtonBlock) {
        self.clickTianjiNavViewButtonBlock(tag);
    }
}
@end
