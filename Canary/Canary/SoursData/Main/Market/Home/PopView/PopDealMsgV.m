//
//  PopDealMsgV.m
//  Canary
//
//  Created by Brain on 2017/6/3.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "PopDealMsgV.h"
#import "Masonry.h"
@interface PopDealMsgV()
{
    CGFloat fs;
}
@property(strong,nonatomic)UILabel * title;//标题
@property(strong,nonatomic)UIButton * closeBtn;//关闭按钮

//head
@property (strong, nonatomic) UILabel *productLab;//产品名
@property (strong, nonatomic) UILabel *typeNumLab;//类型&手数
@property (strong, nonatomic) UILabel *closeTimeLab;//平仓时间
//mid
@property (strong, nonatomic) UILabel *profitLab;//盈利lab
@property (strong, nonatomic) UILabel *createPriceLab;//建仓价
@property (strong, nonatomic) UILabel *closePriceLab;//平仓价

@property (strong, nonatomic) UILabel *stopLoseLab;//止损
@property (strong, nonatomic) UILabel *stopProfitLab;//止盈
@property (strong, nonatomic) UILabel *nightFeeLab;//过夜费
@property (strong, nonatomic) UILabel *feeLab;//手续费

@property (strong, nonatomic) UILabel *advanceLab;//占用预付款
@property (strong, nonatomic) UILabel *createTimeLab;//建仓时间
@property (strong, nonatomic) UILabel *closeTypeLab;//平仓类型



@end

@implementation PopDealMsgV

#define DealMsgH 264
#pragma mark - init
-(instancetype)init {
    self=[super init];
    if (self) {
        [self configContentH:DealMsgH];
        [self initView];
    }
    return self;
}
#pragma mark - create view
-(void)initView{
    NSLog(@"self.contentView.h = %.2f y=%.2f",self.contentView.h_,self.contentView.y_);
    self.contentViewY=20;
    self.contentView.frame=CGRectMake(8, 20, self.w_-LTAutoW(16), DealMsgH);
    [self.contentView layerRadius:3 bgColor:LTWhiteColor];
    fs = 15;
    if (ScreenW_Lit==320) {
        fs = 13;
    }
    [self createTitleView];//title view
    [self createDealMsgV];
}
-(void)createTitleView {
    _title=[self createLabWithF:CGRectMake(0, 0, self.contentView.w_, 44) text:@"交易消息" fsize:fs];
    _title.backgroundColor=LTBgColor;
    _title.textAlignment=NSTextAlignmentCenter;
    _title.font=boldFontSiz(fs);
    [self.contentView addSubview:_title];
    
    _closeBtn=[self btn:CGRectMake(self.contentView.w_-44, 0, 44, 44) title:@"" action:@selector(hideV)];
    [_closeBtn setImage:[UIImage imageNamed:@"closeIcon"] forState:UIControlStateNormal];
    [self.contentView addSubview:_closeBtn];
    
    UIView *line=[[UIView alloc]init];
    line.frame=CGRectMake(0, _title.yh_, _title.w_,0.5);
    line.backgroundColor=LTLineColor;
    [self.contentView addSubview:line];
}
-(void)createDealMsgV{
    CGFloat lm=LTAutoW(16);
    CGFloat ty=44;
    _productLab=[self createLabWithF:CGRectMake(lm, ty, 120, 44) text:@"----" fsize:fs];
    _productLab.font=boldFontSiz(fs);
    [self.contentView addSubview:_productLab];
    [_productLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(lm);//使左边等于self.view的左边，间距为0
        make.top.equalTo(self.mas_top).offset(64);//使顶部与self.view的间距为
        make.height.equalTo(@(44));
    }];

    
    _typeNumLab=[self createLabWithF:CGRectMake(_productLab.xw_+8, _productLab.y_, 0.5*self.w_, _productLab.h_) text:@"买涨 ---手" fsize:fs];
    _typeNumLab.font=boldFontSiz(fs);
    [self.contentView addSubview:_typeNumLab];

    [_typeNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_productLab.mas_right).offset(6);
        make.top.equalTo(self.mas_top).offset(64);//使顶部与self.view的间距为
        make.height.equalTo(@(44));
    }];

    
    _closeTimeLab=[self createLabWithF:CGRectMake(0.5*self.w_, _productLab.y_, 0.5*self.w_, _productLab.h_) text:@"平仓时间：00-00 00:00" fsize:fs];
    _closeTimeLab.numberOfLines=1;
    [self.contentView addSubview:_closeTimeLab];
    [_closeTimeLab sizeToFit];
    _closeTimeLab.frame=CGRectMake(self.contentView.w_-lm-_closeTimeLab.w_, _typeNumLab.y_, _closeTimeLab.w_, 44);
    
    UIView *line=[[UIView alloc]init];
    line.frame=CGRectMake(0, _productLab.yh_, _title.w_,0.5);
    line.backgroundColor=LTLineColor;
    [self.contentView addSubview:line];
    
    CGFloat leftW=[LTUtils labelWithFontsize:LTAutoW(30) text:@"+00000.00"];
    leftW = 0.3*_title.w_<leftW?leftW:0.3*_title.w_;
    
    CGFloat h = DealMsgH-line.yh_;
    UIView *vline=[[UIView alloc]init];
    vline.frame=CGRectMake(leftW, line.yh_+8, 0.5,h-16);
    vline.backgroundColor=LTLineColor;
    [self.contentView addSubview:vline];

    _profitLab=[self createLabWithF:CGRectMake(0, line.yh_+44, leftW, 24) text:@"+00000.00" fsize:30];
    _profitLab.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:_profitLab];

    _createPriceLab=[self createLabWithF:CGRectMake(0, _profitLab.yh_+16, leftW, 16) text:@"建仓价 --.--" fsize:fs];
    _createPriceLab.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:_createPriceLab];
    
    UIImageView *img=[[UIImageView alloc]init];
    img.image=[UIImage imageNamed:@"downIcon"];
    CGFloat imgx = _createPriceLab.center.x-2.5;
    img.frame=CGRectMake(imgx, _createPriceLab.yh_+3, 5, 9);
    [self.contentView addSubview:img];
    
    _closePriceLab=[self createLabWithF:CGRectMake(0, _createPriceLab.yh_+16, leftW, 16) text:@"平仓价 --.--" fsize:fs];
    _closePriceLab.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:_closePriceLab];

    NSArray *arr=@[@"止损:",@"止盈:",@"过夜费:",@"手续费:",@"占用预付款:",@"建仓时间:",@"平仓类型:"];
    CGFloat y=line.yh_+8;
    
    for (int i = 0; i<arr.count; i++) {
        NSString *str=arr[i];
        CGFloat lw=[LTUtils labelWithFontsize:fs text:str]+LTAutoW(8);
        CGRect frame = CGRectMake(leftW+LTAutoW(16), y, lw, 16);
        UILabel *lab = [self createLabWithF:frame text:str fsize:fs];
        lab.textColor=LTSubTitleColor;
        
        CGRect frame1 = CGRectMake(lab.xw_, y, 0.66*_title.w_, 16);
        UILabel *lab1 = [self createLabWithF:frame1 text:@"------" fsize:fs];
        lab1.tag=100+i;
        [self.contentView addSubview:lab];
        [self.contentView addSubview:lab1];
        y+=24;
    }
    _stopLoseLab=[self.contentView viewWithTag:100];
    _stopProfitLab=[self.contentView viewWithTag:101];
    _nightFeeLab=[self.contentView viewWithTag:102];
    _feeLab=[self.contentView viewWithTag:103];
    _advanceLab=[self.contentView viewWithTag:104];
    _createTimeLab=[self.contentView viewWithTag:105];
    _closeTypeLab=[self.contentView viewWithTag:106];

}
#pragma mark - action
-(void)configWithData:(NSDictionary *)data {
    UIColor *color=LTKLineRed;
    NSString *title=[self strValue:@"title" dic:data];
    _title.text=title;
    
    NSDictionary *dic = [data dictionaryFoKey:@"data"];
    NSString *profitLoss=[self strValue:@"profitLoss" dic:dic];
    NSString *closePrice=[self strValue:@"closePrice" dic:dic];
    NSString *createPrice=[self strValue:@"createPrice" dic:dic];
    NSString *type = [self strValue:@"type" dic:dic];
    NSString *closeTime=[self strValue:@"closeTime" dic:dic];
    NSString *orderNumber=[self strValue:@"orderNumber" dic:dic];
    NSString *closeType=[self strValue:@"closeType" dic:dic];
    NSString *productName=[self strValue:@"productName" dic:dic];
    NSString *stopLoss=[self strValue:@"stopLoss" dic:dic];
    stopLoss=[stopLoss isEqualToString:@"0"]?@"-":stopLoss;
    NSString *stopProfit=[self strValue:@"stopProfit" dic:dic];
    stopProfit=[stopProfit isEqualToString:@"0"]?@"-":stopProfit;
    NSString *deferred=[self strValue:@"deferred" dic:dic];
    NSString *fee=[self strValue:@"fee" dic:dic];
    
    NSString *advance=[self strValue:@"amount" dic:dic];//预付款
    NSString *createTime=[self strValue:@"createTime" dic:dic];

    if (closeTime.length>=19) {
        closeTime=[closeTime substringFromIndex:5];
        if (ScreenW_Lit==320) {
            closeTime=[closeTime substringToIndex:closeTime.length-3];
        }
    }
    if (createTime.length>=19) {
        createTime=[createTime substringFromIndex:5];
        if (ScreenW_Lit==320) {
            createTime=[createTime substringToIndex:createTime.length-3];
        }
    }


    if (profitLoss.floatValue<0) {//1空2多
        _profitLab.textColor=LTKLineGreen;
    }else{
        _profitLab.textColor=LTKLineRed;
    }
    NSString *typeStr=@"买涨";
    if ([type isEqualToString:@"1"]) {
        color=LTKLineGreen;
        typeStr=@"买跌";
    }

    _productLab.text=productName;
    [_productLab sizeToFit];
    _productLab.frame=CGRectMake(LTAutoW(16), _productLab.y_, _productLab.w_, 44);

    _typeNumLab.text=[NSString stringWithFormat:@"%@%@手",typeStr,orderNumber];
    [_typeNumLab sizeToFit];
    _typeNumLab.frame=CGRectMake(_typeNumLab.xw_+8, _typeNumLab.y_, _typeNumLab.w_, 44);

    NSString *closeStr = [NSString stringWithFormat:@"平仓时间:%@",closeTime];
    NSRange range=[closeStr rangeOfString:@"平仓时间:"];
    NSAttributedString *abstr = [closeStr ABStrColor:LTSubTitleColor range:range];
    CGFloat w = [LTUtils labelWithFontsize:fs text:closeStr];
    _closeTimeLab.attributedText=abstr;
    [_closeTimeLab sizeToFit];
    _closeTimeLab.frame=CGRectMake(self.contentView.w_-LTAutoW(8)-w, _typeNumLab.y_, w, 44);
    
    _profitLab.text=profitLoss;
    _createPriceLab.text=[NSString stringWithFormat:@"建仓价 %@",createPrice];
    _closePriceLab.text=[NSString stringWithFormat:@"平仓价 %@",closePrice];

    _stopLoseLab.text=stopLoss;
    _stopProfitLab.text=stopProfit;
    _nightFeeLab.text=deferred;
    _feeLab.text=fee;
    //预付款
    _advanceLab.text=advance;
    _createTimeLab.text=createTime;
    
    _closeTypeLab.text=[self closeTypeStr:closeType];
    _stopLoseLab.text=stopLoss;
    _typeNumLab.textColor=color;
}
-(void)hideV{
    [self showView:NO];
}
#pragma mark - utils
-(NSString *)strValue:(NSString *)key dic:(NSDictionary *)dic{
    NSString * value = [dic stringFoKey:key];
    value=notemptyStr(value)?value:@"-";
    return value;
}
-(NSString *)closeTypeStr:(NSString *)type{
    NSInteger typeNum=[type integerValue];
    NSString *typeStr = @"止盈平仓";
    switch (typeNum) {
        case 4:
            typeStr = @"止盈平仓";
            break;
        case 5:
            typeStr = @"止损平仓";
            break;
        case 6:
            typeStr = @"爆仓";
            break;
        case 7:
            typeStr = @"休市平仓";
            break;
        case 8:
            typeStr = @"强制平仓";
            break;
        default:
            typeStr = @"系统平仓";
            break;
    }
    return typeStr;
}
-(UILabel *)createLabWithF:(CGRect)frame text:(NSString *)text fsize:(CGFloat)fsize{
    UILabel *label=[[UILabel alloc]init];
    label.frame=frame;
    label.backgroundColor=[UIColor clearColor];
    label.text=text;
    label.textAlignment=NSTextAlignmentLeft;
    label.numberOfLines=0;
    label.textColor=LTTitleColor;
    label.font=[UIFont systemFontOfSize:fsize];
    return label;
}
-(UIButton *)btn:(CGRect)frame title:(NSString *)title action:(SEL)action {
    UIButton *btn = [UIButton btnWithTarget:self action:action frame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:LTWhiteColor forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:fs];
    btn.layer.masksToBounds=YES;
    btn.layer.cornerRadius=3;
    return btn;
}

@end
