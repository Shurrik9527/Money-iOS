//
//  DealHeadShortV.m
//  Canary
//
//  Created by Brain on 2017/6/2.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "DealHeadShortV.h"
@interface DealHeadShortV()
@property (nonatomic,strong) UILabel * netValueLab;//净值
@property (nonatomic,strong) UILabel * balanceLab;//可用预付款
@property (nonatomic,strong) UILabel * profitLab;//浮动盈亏

@end

@implementation DealHeadShortV

-(instancetype)init{
    self=[super init];
    if (self) {
        self.backgroundColor=NavHeadBgCoror;
        self.frame=CGRectMake(0, 64, ScreenW_Lit, DealHeadShortH);
        [self createV];
    }
    return self;
}
-(void)createV{
    NSArray *titles=@[@"净值",@"可用预付款",@"浮动盈亏"];
    CGFloat x=0;
    CGFloat w=self.w_/titles.count;
    CGFloat tm=12;
    for (int i = 0; i<3 ; i++) {
        CGRect frame = CGRectMake(x, tm, w, 15);
        CGRect frame1 = CGRectMake(x, tm+15, w, 28);

        UILabel *lab=[self createLabWithF:frame text:titles[i] fsize:15];
        [self addSubview:lab];
        
        UILabel *lab1=[self createLabWithF:frame1 text:@"-" fsize:18];
        lab1.tag=100+i;
        [self addSubview:lab1];
        x+=w;
    }
    
    _netValueLab=[self viewWithTag:100];//净值
    _balanceLab=[self viewWithTag:101];//预付款
    _profitLab=[self viewWithTag:102];//盈亏
    _profitLab.textColor=LTKLineRed;
}
#pragma mark - action
- (void)configViewWithData:(NSDictionary *)data{
    NSString *equity=!emptyStr([data stringFoKey:@"equity"])?[data stringFoKey:@"equity"]:@"-";
    NSString *freeMargin=!emptyStr([data stringFoKey:@"freeMargin"])?[data stringFoKey:@"freeMargin"]:@"-";
    NSString *profitLoss=!emptyStr([data stringFoKey:@"profitLoss"])?[data stringFoKey:@"profitLoss"]:@"-";
    UIColor *color=LTKLineGreen;
    if ([profitLoss floatValue]>0) {
        profitLoss=[NSString stringWithFormat:@"+%@",profitLoss];
        color=LTKLineRed;
    }
    _netValueLab.text=equity;
    _balanceLab.text=freeMargin;
    _profitLab.text=profitLoss;
    _profitLab.textColor=color;
}
#pragma mark - utils
-(UILabel *)createLabWithF:(CGRect)frame text:(NSString *)text fsize:(CGFloat)fsize{
    UILabel *label=[[UILabel alloc]init];
    label.frame=frame;
    label.backgroundColor=[UIColor clearColor];
    label.text=text;
    label.textAlignment=NSTextAlignmentCenter;
    label.numberOfLines=0;
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:fsize];
    return label;
}
@end
