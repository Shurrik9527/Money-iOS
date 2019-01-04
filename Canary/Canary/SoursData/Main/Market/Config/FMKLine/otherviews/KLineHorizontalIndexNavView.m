//
//  KLineHorizontalIndexNavView.m
//  golden_iphone
//
//  Created by dangfm on 15/7/10.
//  Copyright (c) 2015年 golden. All rights reserved.
//

#import "KLineHorizontalIndexNavView.h"


@interface KLineHorizontalIndexNavView ()
{
    UILabel *select_SMA;//标记SMA选项
    UILabel *select_MACD;//标记MACD选项
    NSInteger selectTag_SMA;//标记SMA 的tag
    NSInteger selectTag_MACD;//标记MACD 的tag

}
@property(strong,nonatomic)NSArray * indexs;
@property(strong,nonatomic)UIView * box;

@end

@implementation KLineHorizontalIndexNavView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self==[super initWithFrame:frame]) {
        self.backgroundColor=KLineBoxBG;
        [self initParams];
        [self createViews];
        
    }
    return self;
}

-(void)initParams{
    _indexs = kPublicData.json_stockindexs;
}

-(void)createViews
{
    self.backgroundColor = KLineBoxBG;
    //SMA等指标的父视图
    _box = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    //    _box.layer.borderColor = ThemeColor(@"font_grey_color").CGColor;
    //    _box.layer.borderWidth = 0.5;
    //    _box.backgroundColor = LTClearColor;
    _box.backgroundColor=LTTitleRGB;
    [self addSubview:_box];
    CGFloat w = _box.frame.size.width;
    CGFloat h = _box.frame.size.height/(_indexs.count-1);
    CGFloat x = 0;
    CGFloat y = 0;
    for (int i=1; i<_indexs.count; i++) {
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
        NSDictionary *dic = [_indexs objectAtIndex:i];
        NSString *title = [dic objectForKey:@"code"];
        [bt setTitle:title forState:UIControlStateNormal];
        [bt setTitleColor:LTSubTitleRGB forState:UIControlStateNormal];
        //        [bt setBackgroundColor:KLineBoxBG];
        //        [bt setBackgroundImage:[CommonOperation imageWithColor:self.backgroundColor andSize:bt.frame.size] forState:UIControlStateHighlighted];
        bt.titleLabel.font = kFontNumber(10);
        bt.tag=100+i;
        [bt addTarget:self action:@selector(clickButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        [_box addSubview:bt];
        y += h;
        
        dic = nil;
        title = nil;
        bt = nil;
    }
    //黑线分割
    UIView *line=[[UIView alloc]init];
    line.frame=CGRectMake(0, 3*h, w,0.5);
    line.backgroundColor=KLineBoxBG;
    [_box addSubview:line];
    
    select_SMA=[[UILabel alloc]init];
    select_SMA.frame=CGRectMake(0, 0, 3,h);
    select_SMA.backgroundColor=BlueFont;
    [_box addSubview:select_SMA];
    
    select_MACD=[[UILabel alloc]init];
    select_MACD.frame=CGRectMake(0, 3*h, 3,h);
    select_MACD.backgroundColor=BlueFont;
    [_box addSubview:select_MACD];
    
    [self reloadSelect];
}
-(void)reloadSelect
{
    [self defaultAllViews];
    selectTag_SMA=101;
    selectTag_MACD=104;
    //移动lab
    [self moveSelectLabWithTag:selectTag_SMA];
    [self moveSelectLabWithTag:selectTag_MACD];
    
    UIButton *bt1 =[_box viewWithTag:selectTag_SMA];
    UIButton *bt2 =[_box viewWithTag:selectTag_MACD];
    [bt1 setTitleColor:LTWhiteColor forState:UIControlStateNormal];
    [bt2 setTitleColor:LTWhiteColor forState:UIControlStateNormal];
}
-(void)reloadSelectWithTag:(NSInteger)smatag
                   macdTag:(NSInteger)macdTag
{
    [self defaultAllViews];
    selectTag_SMA=smatag;
    selectTag_MACD=macdTag;
    //移动lab
    [self moveSelectLabWithTag:selectTag_SMA];
    [self moveSelectLabWithTag:selectTag_MACD];
    
    UIButton *bt1 =[_box viewWithTag:selectTag_SMA];
    UIButton *bt2 =[_box viewWithTag:selectTag_MACD];
    [bt1 setTitleColor:LTWhiteColor forState:UIControlStateNormal];
    [bt2 setTitleColor:LTWhiteColor forState:UIControlStateNormal];
}

-(void)defaultAllViews
{
    for (UIButton *bt in _box.subviews)
    {
        if ([[bt class] isSubclassOfClass:[UIButton class]])
        {
            [bt setTitleColor:LTSubTitleRGB forState:UIControlStateNormal];
        }
    }
}

-(void)clickButtonHandle:(UIButton*)bt{
    NSString *code = bt.titleLabel.text;
    
    //    [self defaultAllViews];
    
    if (bt.tag>103)
    {
        UIButton *oldbt =[_box viewWithTag:selectTag_MACD];
        [oldbt setTitleColor:LTSubTitleRGB forState:UIControlStateNormal];
    }
    else
    {
        UIButton *oldbt =[_box viewWithTag:selectTag_SMA];
        [oldbt setTitleColor:LTSubTitleRGB forState:UIControlStateNormal];
    }
    [self moveSelectLabWithTag:bt.tag];
    
    [bt setTitleColor:LTWhiteColor
             forState:UIControlStateNormal];
    //[bt setBackgroundImage:[CommonOperation imageWithColor:[UIColor whiteColor] andSize:bt.frame.size] forState:UIControlStateNormal];
    if (self.clickKLineHorizontalNavButtonBlock) {
        self.clickKLineHorizontalNavButtonBlock(code);
    }
}
-(void)moveSelectLabWithTag:(NSInteger)tag
{
    CGFloat h = _box.frame.size.height/(_indexs.count-1);
    CGRect frame = CGRectMake(0, (tag-100-1) *h, 3, h);
    //动画
    [UIView animateWithDuration:0.2 animations:^{
        if (tag>103)
        {
            select_MACD.frame=frame;
            selectTag_MACD=tag;
        }
        else
        {
            select_SMA.frame=frame;
            selectTag_SMA=tag;
        }
    }];
}
@end
