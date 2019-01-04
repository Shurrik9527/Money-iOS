//
//  KLineSMAVerticalView.m
//  ixit
//
//  Created by Brain on 16/7/28.
//  Copyright © 2016年 ixit. All rights reserved.
//

#import "KLineSMAVerticalView.h"
@interface KLineSMAVerticalView ()
{
    NSArray *_indexs;
    UIView *_box;
    UILabel *select_SMA;//标记SMA选项
    NSInteger selectTag_SMA;//标记SMA 的tag
    
}

@end
@implementation KLineSMAVerticalView
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
    _box = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, SMAHeight)];
    _box.backgroundColor=KLineBoxBG;
    [self addSubview:_box];
    CGFloat w = _box.frame.size.width/3;
    CGFloat h = SMAHeight;
    CGFloat x = 0;
    CGFloat y = 0;
    for (int i=1; i<4; i++) {
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(x+(i-1)*w, y, w, h)];
        NSDictionary *dic = [_indexs objectAtIndex:i];
        NSString *title = [dic objectForKey:@"code"];
        [bt setTitle:title forState:UIControlStateNormal];
        [bt setTitleColor:LTSubTitleRGB forState:UIControlStateNormal];
        bt.titleLabel.font = autoFontSiz(12);
        bt.tag=100+i;
        [bt addTarget:self action:@selector(clickButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        [_box addSubview:bt];
//        y += h;
        
        dic = nil;
        title = nil;
        bt = nil;
    }
    UIView *line=[[UIView alloc]init];
    line.frame=CGRectMake(0, 0, Screen_width,0.5);
    line.backgroundColor=kStageLineColor;
    [self addSubview:line];
    
    UIView *line1=[[UIView alloc]init];
    line1.frame=CGRectMake(0, self.frame.size.height-0.5, Screen_width,0.5);
    line1.backgroundColor=kStageLineColor;
    [self addSubview:line1];
    
    select_SMA=[[UILabel alloc]init];
    select_SMA.frame=CGRectMake(0, h-3, w,3);
    select_SMA.backgroundColor=BlueFont;
    [_box addSubview:select_SMA];
    
    [self reloadSelectWithTag:101];
}
-(void)reloadSelectWithTag:(NSInteger)tag
{
    [self defaultAllViews];
    selectTag_SMA=tag;
    //移动lab
    [self moveSelectLabWithTag:selectTag_SMA];
    
    UIButton *bt1 =[_box viewWithTag:selectTag_SMA];
    [bt1 setTitleColor:LTWhiteColor forState:UIControlStateNormal];
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
//    NSString *code = bt.titleLabel.text;
    
    //    [self defaultAllViews];
    
    if (bt.tag<=103)
    {
        UIButton *oldbt =[_box viewWithTag:selectTag_SMA];
        [oldbt setTitleColor:LTSubTitleRGB forState:UIControlStateNormal];
    }
    [self moveSelectLabWithTag:bt.tag];
    
    [bt setTitleColor:LTWhiteColor
             forState:UIControlStateNormal];
    
    NSString *code = bt.titleLabel.text;
    if (self.SMAButtonBlock) {
        self.SMAButtonBlock(code);
    }
}
-(void)moveSelectLabWithTag:(NSInteger)tag
{
    CGFloat w = _box.frame.size.width/3;
    CGFloat h = _box.frame.size.height;
    CGRect frame = CGRectMake((tag-100-1)*w,  h-3, w, 3);
    //动画
    [UIView animateWithDuration:0.2 animations:^{
        select_SMA.frame=frame;
        selectTag_SMA=tag;
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
