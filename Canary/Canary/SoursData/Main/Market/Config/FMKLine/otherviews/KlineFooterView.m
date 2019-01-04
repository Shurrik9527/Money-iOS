//
//  KlineFooterView.m
//  FMStock
//
//  Created by dangfm on 15/5/3.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

#import "KlineFooterView.h"

@interface KlineFooterView(){
    NSArray *_titles;
}

@end

@implementation KlineFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self==[super initWithFrame:frame]) {
        [self initViews];
    }
    return self;
}

-(void)initViews{
    self.backgroundColor = KLineBoxBG;
    if (UD_AppIsNormal) {
        _titles = @[@"指标",@"下单",@"横竖"];
    }else{
        _titles = @[@"指标",@"横竖"];
        
    }
    //NSArray *imgs = @[@"zhibiao",@"hengshu"];
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = self.frame.size.width / _titles.count - 0.5;
    CGFloat h = self.frame.size.height;
       UIFont *font = [UIFont fontWithName:kFontName size:14];
    for (int i=0;i<_titles.count;i++) {
        x = i*w;
        NSString *str = [_titles objectAtIndex:i];
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
        bt.backgroundColor = LTClearColor;
        [bt setTitle:str forState:UIControlStateNormal];
        [bt setTitleColor:LTWhiteColor forState:UIControlStateNormal];
        //[bt setImage:img forState:UIControlStateNormal];
        bt.titleLabel.font = font;
        bt.tag = i;
        [bt addTarget:self action:@selector(clickButtons:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bt];
        
        
        
        
        bt = nil;
        str = nil;
        //img = nil;
    }

}

-(void)updateAllViews{
    for (int i=0; i<_titles.count; i++) {
        UIButton *bt = [self.subviews objectAtIndex:i];
        [bt setBackgroundColor:LTClearColor];
        [bt setTitleColor:LTWhiteColor forState:UIControlStateNormal];
    }
}

-(void)clickButtons:(UIButton*)bt{
    
    if (self.clickFooterButtonsBlock) {
        self.clickFooterButtonsBlock(bt);
    }
}

@end
