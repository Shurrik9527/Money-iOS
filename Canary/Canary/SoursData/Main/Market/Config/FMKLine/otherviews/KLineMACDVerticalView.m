//
//  KLineMACDVerticalView.m
//  ixit
//
//  Created by Brain on 16/7/28.
//  Copyright © 2016年 ixit. All rights reserved.
//

#import "KLineMACDVerticalView.h"
@interface KLineMACDVerticalView ()
{
    NSArray *_indexs;
    UIView *_box;
    UILabel *select_MACD;//标记MACD选项
    NSInteger selectTag_MACD;//标记MACD 的tag
    
}

@end
@implementation KLineMACDVerticalView
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
    _box.backgroundColor=KLineBoxBG;
    [self addSubview:_box];
    CGFloat w = _box.frame.size.width/3.0;
    CGFloat h = _box.frame.size.height;
    CGFloat x = 0;
    CGFloat y = 0;
    for (int i=4; i<_indexs.count; i++)
    {
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(x+(i-4)*w, y, w, h)];
        NSDictionary *dic = [_indexs objectAtIndex:i];
        NSString *title = [dic objectForKey:@"code"];
        [bt setTitle:title forState:UIControlStateNormal];
        [bt setTitleColor:LTSubTitleRGB forState:UIControlStateNormal];
        bt.titleLabel.font = autoFontSiz(12);
        bt.tag=100+i;
        [bt addTarget:self action:@selector(clickButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        [_box addSubview:bt];
        dic = nil;
        title = nil;
        bt = nil;
    }
    //黑线分割
//    UIView *line=[[UIView alloc]init];
//    line.frame=CGRectMake(0, 3*h, w,0.5);
//    line.backgroundColor=KLineBoxBG;
//    [_box addSubview:line];
    UIView *line=[[UIView alloc]init];
    line.frame=CGRectMake(0, 1, Screen_width,0.5);
    line.backgroundColor=kStageLineColor;
    [self addSubview:line];
    
    UIView *line1=[[UIView alloc]init];
    line1.frame=CGRectMake(0, self.frame.size.height-0.5, Screen_width,0.5);
    line1.backgroundColor=kStageLineColor;
    [self addSubview:line1];

    select_MACD=[[UILabel alloc]init];
    select_MACD.frame=CGRectMake(0, h-3, w,3);
    select_MACD.backgroundColor=BlueFont;
    [_box addSubview:select_MACD];

    [self reloadSelectWithTag:104];
}
-(void)reloadSelectWithTag:(NSInteger)tag
{
    [self defaultAllViews];
    selectTag_MACD=tag;
    //移动lab
    [self moveSelectLabWithTag:selectTag_MACD];
    
    UIButton *bt2 =[_box viewWithTag:selectTag_MACD];
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
    
    //    [self defaultAllViews];
    
    if (bt.tag>103)
    {
        UIButton *oldbt =[_box viewWithTag:selectTag_MACD];
        [oldbt setTitleColor:LTSubTitleRGB forState:UIControlStateNormal];
    }
    [self moveSelectLabWithTag:bt.tag];
    
    [bt setTitleColor:LTWhiteColor
             forState:UIControlStateNormal];
    //[bt setBackgroundImage:[LTUtils imageWithColor:[UIColor whiteColor] size:bt.frame.size] forState:UIControlStateNormal];
    NSString *code = bt.titleLabel.text;

    if (self.MACDButtonBlock) {
        self.MACDButtonBlock(code);
    }
}
-(void)moveSelectLabWithTag:(NSInteger)tag
{
    CGFloat h = _box.frame.size.height;
    CGFloat w = self.frame.size.width/3;
    CGRect frame = CGRectMake((tag-100-4)*w,h-3, w, 3);
    //动画
    [UIView animateWithDuration:0.2 animations:^{
        if (tag>103)
        {
            select_MACD.frame=frame;
            selectTag_MACD=tag;
        }
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
