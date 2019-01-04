//
//  WeiPanKChartFooterView.m
//  ixit
//
//  Created by yu on 15/8/30.
//  Copyright (c) 2015年 ixit. All rights reserved.
//

#import "WeiPanKChartFooterView.h"

@interface WeiPanKChartFooterView()
@property(strong,nonatomic)NSArray * titles;
@property(strong,nonatomic)UIButton * otherBtn;//跳转交易大厅
@property(strong,nonatomic)NSMutableArray * subs;//子按钮

@end

@implementation WeiPanKChartFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self==[super initWithFrame:frame]) {
        [self initViews];
    }
    return self;
}

-(void)initViews
{
    self.backgroundColor = LTTitleRGB;
    if (usePushRemind) {
        _titles=@[@"买涨",@"买跌",@"平仓",@"前往交易大厅"];
    }else{
        _titles=@[@"买涨",@"买跌",@"前往交易大厅"];
    }
    _subs=[[NSMutableArray alloc]init];
    CGFloat x;
    CGFloat pading = 8;
    CGFloat y = 8;
    CGFloat w = (Screen_width-8*_titles.count)/(_titles.count-1);//买涨买跌按钮的宽度
    CGFloat h = 36;
    UIColor *bgColor = LTColorHex(0xF2302C);
    for (int i=0;i<_titles.count;i++) {
        x = pading+i*(w+pading);
        if (i==1) {
            bgColor=LTColorHex(0x1AAF27);
        }else if (i==2){
            bgColor=BlueLineColor;
        }
        NSString *str = [_titles objectAtIndex:i];
        UIButton *bt = [self createBtnWithFrame:CGRectMake(x, y, w, h) title:str];
        bt.backgroundColor = bgColor;
        bt.tag = i+1000;
//        [bt addTarget:self action:@selector(clickButtons:) forControlEvents:UIControlEventTouchUpInside];
        bt.hidden=YES;
        if(i==_titles.count-1) {
            w=290;
            bt.frame=CGRectMake((self.frame.size.width-w)/2, y, w, h);
            [bt setTitleColor:LTSubTitleRGB forState:UIControlStateNormal];
            bt.backgroundColor=LTClearColor;
            bt.layer.borderColor=LTSubTitleRGB.CGColor;
            bt.layer.borderWidth=1;
            bt.hidden=NO;
            _otherBtn=bt;
        }
        [self addSubview:bt];
        [_subs addObject:bt];
        bt = nil;
        str = nil;
    }
}
#pragma mark - action
-(void)updateAllViews{
    for (int i=0; i<_titles.count; i++) {
        UIButton *bt = [self.subviews objectAtIndex:i];
        [bt setBackgroundColor:LTClearColor];
        [bt setTitleColor:LTHEX(0x343c48) forState:UIControlStateNormal];
    }
}
//是否显示跳转订单的btn
-(void)showCreateOrderBtnWithBool:(BOOL)isShow {
    for (int i = 0; i<_subs.count; i++) {
        UIButton *btn=[self viewWithTag:1000+i];
        if (btn.tag==1000+_subs.count-1) {
            btn.hidden=isShow;
        }else{
            btn.hidden=!isShow;
        }
    }
}
-(void)clickButtons:(UIButton*)bt{
    if (self.clickFooterButtonsBlock) {
        self.clickFooterButtonsBlock(bt);
    }
}
#pragma mark - utils
-(UIButton *)createBtnWithFrame:(CGRect)frame
                          title:(NSString *)title {
    UIFont *font = [UIFont fontWithName:kFontName size:15];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    btn.titleLabel.font = font;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.masksToBounds=YES;
    btn.layer.cornerRadius=3;
    [btn addTarget:self action:@selector(clickButtons:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
@end

