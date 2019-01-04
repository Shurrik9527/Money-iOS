//
//  DealHeadV.m
//  Canary
//
//  Created by Brain on 2017/5/18.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "DealHeadV.h"
#import "Masonry.h"
@interface DealHeadV() {
    CGFloat fs;
}
@property (nonatomic,strong) UILabel * netValueLab;//净值
@property (nonatomic,strong) UIButton * rechargeBtn;//入金按钮

@property (nonatomic,strong) UILabel * prePayLab;//可用预付款
@property (nonatomic,strong) UILabel * profitLab;//浮动盈亏
@property (nonatomic,strong) UILabel * paiedLab;//已用预付款
@property (nonatomic,strong) UILabel * prePayRateLab;//预付款比例

@end

@implementation DealHeadV


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init{
    self=[super init];
    if (self) {
        fs=LTAutoW(15);
        self.backgroundColor=NavHeadBgCoror;
        self.frame=CGRectMake(0, 64, ScreenW_Lit, DealHeadVH);
        [self createView];
    }
    return self;
}

- (void)createView{
    CGFloat tm=12;
    CGFloat lm=10;
    CGFloat labW=0.5*ScreenW_Lit;
    CGFloat labH=[LTUtils labHeightWithFontsize:fs text:@"净值(美元)"];
    //净值lab
    CGRect frame = CGRectMake(lm, tm, labW, labH);
    UILabel *jz=[self createLabWithF:frame text:@"净值(美元)" fsize:fs ];
    [self addSubview:jz];
    
    //入金
    CGFloat x=[LTUtils labelWithFontsize:fs text:jz.text]+8+jz.x_;
    CGRect frm = CGRectMake(x, tm, 50, 20);
    frm.origin.y=jz.center.y-10;
    _rechargeBtn=[UIButton btnWithTarget:self action:@selector(btnAction) frame:frm];
    _rechargeBtn.titleLabel.font=autoFontSiz(15);
    [_rechargeBtn setTitle:@"入金" forState:UIControlStateNormal];
    [_rechargeBtn layerRadius:10 bgColor:BlueLineColor];
    [self addSubview:_rechargeBtn];
    
    //可用预付款
    frame.origin.y=self.h_-tm-labH;
    UILabel *ky=[self createLabWithF:frame text:@"可用预付款：" fsize:fs ];
    [self addSubview:ky];
    [ky sizeToFit];
    ky.frame=CGRectMake(lm, ky.y_, ky.w_, ky.h_);

    CGRect frame1=CGRectMake(ky.xw_, ky.y_, labW-ky.xw_, ky.h_);
    _prePayLab=[self createLabWithF:frame1 text:@"-" fsize:fs ];
    [self addSubview:_prePayLab];

    //净值value lab
    CGRect frame2=CGRectMake(lm, jz.yh_, labW, ky.y_-jz.yh_);
    _netValueLab=[self createLabWithF:frame2 text:@"-" fsize:36 ];
    _netValueLab.font=[UIFont boldFontOfSize:30];
    [self addSubview:_netValueLab];
    
   
    //浮动盈亏
    CGFloat rm=[LTUtils labelWithFontsize:fs text:@"已用预付款：1000000.00"]+8;
    lm=self.w_-rm;
    UILabel *fdLab=[self createLabWithF:CGRectMake(lm, jz.yh_, rm, labH) text:@"浮动盈亏：" fsize:fs ];
    fdLab.textColor=LTSubTitleColor;
    [self addSubview:fdLab];
    [fdLab sizeToFit];
    fdLab.frame=CGRectMake(lm, fdLab.y_, fdLab.w_, labH);
    _profitLab=[self createLabWithF:CGRectMake(fdLab.xw_, fdLab.y_, rm, labH) text:@"-" fsize:fs ];
    [self addSubview:_profitLab];
    
    //已用预付款
    UILabel *yyLab=[self createLabWithF:CGRectMake(lm, fdLab.yh_+8, rm, labH) text:@"已用预付款：" fsize:fs ];
    yyLab.textColor=LTSubTitleColor;
    [self addSubview:yyLab];
    [yyLab sizeToFit];
    yyLab.frame=CGRectMake(lm, yyLab.y_, yyLab.w_, labH);
    _paiedLab=[self createLabWithF:CGRectMake(yyLab.xw_, yyLab.y_, rm, labH) text:@"-" fsize:fs ];
    [self addSubview:_paiedLab];

    UILabel *rateLab=[self createLabWithF:CGRectMake(lm, yyLab.yh_+8, rm, labH) text:@"预付款比例：" fsize:fs ];
    rateLab.textColor=LTSubTitleColor;
    [self addSubview:rateLab];
    [rateLab sizeToFit];
    rateLab.frame=CGRectMake(lm, rateLab.y_, rateLab.w_, labH);
    _prePayRateLab=[self createLabWithF:CGRectMake(rateLab.xw_, rateLab.y_, rm, labH) text:@"-" fsize:fs ];
    [self addSubview:_prePayRateLab];

}
#pragma mark - action
- (void)configViewWithData:(NSDictionary *)data {
    //净值
    NSString *equity=[data objectForKey:@"equity"];
    equity=!emptyStr(equity)?[LTUtils decimal2PWithFormat:equity.floatValue]:@"-";
    _netValueLab.text=equity;
    //预付款
    NSString *freeMargin=[data objectForKey:@"freeMargin"];
    freeMargin=!emptyStr(freeMargin)?[LTUtils decimal2PWithFormat:freeMargin.floatValue]:@"-";
    _prePayLab.text=freeMargin;
    //已用预付款
    NSString *margin=[data objectForKey:@"margin"];
    margin=!emptyStr(margin)?[LTUtils decimal2PWithFormat:margin.floatValue]:@"-";
    _paiedLab.text=margin;
    //预付款比例
    NSString *marginLevel=[data objectForKey:@"marginLevel"];
    marginLevel=!emptyStr(marginLevel)?[marginLevel stringByAppendingString:@"%"]:@"-";
    _prePayRateLab.text=marginLevel;

    //浮动盈亏
    NSString *profitLoss=[data objectForKey:@"profitLoss"];
    profitLoss=!emptyStr(profitLoss)?[LTUtils decimal2PWithFormat:profitLoss.floatValue]:@"-";
    UIColor *color=LTKLineGreen;
    if ([profitLoss floatValue]>0) {
        profitLoss=[NSString stringWithFormat:@"+%@",profitLoss];
        color=LTKLineRed;
    }
    _profitLab.text=profitLoss;
    _profitLab.textColor=color;

}

//入金事件
-(void)btnAction {
    NFC_PostName(NFC_PushRecharge);
}
#pragma mark - utils
-(UILabel *)createLabWithF:(CGRect)frame text:(NSString *)text fsize:(CGFloat)fsize{
    UILabel *label=[[UILabel alloc]init];
    label.frame=frame;
    label.backgroundColor=[UIColor clearColor];
    label.text=text;
    label.textAlignment=NSTextAlignmentLeft;
    label.numberOfLines=0;
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:fsize];
    return label;
}
@end
