//
//  CardHeadView.m
//  ixit
//
//  Created by Brain on 2017/4/5.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "CardHeadView.h"
#import "GiftCountDownView.h"
#import "UIImageView+LTWebCache.h"
#import "LTArcProgressView.h"
@interface CardHeadView()
@property (nonatomic,strong) IntegralMo * integralMo;
@property (nonatomic,strong) GiftMO * giftmo;

@property (nonatomic,strong) UIImageView * cardBG;//卡片背景
@property (nonatomic,strong) UILabel * surplusNumLab;//剩余lab
@property (nonatomic,strong) UILabel * nameLab;//名称lab
@property (nonatomic,strong) UILabel * integralLab;//积分lab
@property (nonatomic,strong) UILabel * redIntegralLab;//红色积分lab
@property (nonatomic,strong) UILabel * delIntegralLab;//删除积分lab

@property (nonatomic,strong) UILabel * vipLab;//vip打折view
@property (nonatomic,strong) GiftCountDownView * countDownView;//倒计时view

@property (nonatomic,strong) UIView * exchangeNumView;
@property (nonatomic,strong) UILabel * exchangeNumLab;//剩余lab黄

@end
@implementation CardHeadView

- (instancetype)initWithMo:(GiftMO *)giftmo integralMo:(IntegralMo *) integralMo {
    self = [super init];
    if (self) {
        _giftmo=giftmo;
        _integralMo=integralMo;
        self.frame=CGRectMake(0, 0, ScreenW_Lit, ContainH);
        [self createView];
    }
    return self;
}
#pragma mark - init view
-(void)createView{
    self.backgroundColor=LTWhiteColor;
    //card背景
    CGFloat left = (ScreenW_Lit-CardW)/2.0;
    _cardBG=[self createImgViewWithFrame:CGRectMake(left, LTAutoW(6), CardW, CardH) imageName:@"cardBG"];
    [self addSubview:_cardBG];

    //特权卡lab
    UILabel *tqlab = [self createLabWithFrame:CGRectMake(0, 0, 100, 44) text:@"特权卡" fontsize:LTAutoW(12)];
    tqlab.textColor=LTRGBA(255, 255, 255, 0.5);
    [tqlab sizeToFit];
    CGRect frame = tqlab.frame;
    frame.origin.y=LTAutoW(61);
    frame.origin.x=(ScreenW_Lit-tqlab.w_)/2.0;
    tqlab.frame=frame;
    [self addSubview:tqlab];
    
    //特权卡名称
    NSString *nameStr=@"--特权卡";
    _nameLab = [self createLabWithFrame:CGRectMake(0, tqlab.yh_+4, ScreenW_Lit, LTAutoW(32)) text:nameStr fontsize:LTAutoW(27)];
    _nameLab.font=autoBoldFontSiz(27);
    _nameLab.textColor=LTRGBA(255, 255, 255, 1);
    [self addSubview:_nameLab];
    [_nameLab sizeToFit];
    _nameLab.frame=CGRectMake(0, tqlab.yh_+4, ScreenW_Lit, _nameLab.h_);

    NSInteger newPoints = [_giftmo.poins integerValue] *[_integralMo.rebateRate floatValue];
    NSNumber *newP=[NSNumber numberWithInteger:newPoints];
    _integral=[NSString stringWithFormat:@"%@",[newP numberDecimalFmt]];
    
    //特权卡积分
    NSString *integralStr=[NSString stringWithFormat:@"%@积分",_integral];
    _integralLab = [self createLabWithFrame:CGRectMake(0, _nameLab.yh_+LTAutoW(23), ScreenW_Lit, LTAutoW(15)) text:integralStr fontsize:LTAutoW(15)];
    _integralLab.textColor=LTRGBA(255, 255, 255, 0.5);
    NSMutableAttributedString *inteAttr=[[NSMutableAttributedString alloc]initWithString:integralStr];
    [inteAttr addAttribute:NSFontAttributeName value:DINProAutoBoldFontSiz(LTAutoW(15)) range:NSMakeRange(0, _integral.length)];
    _integralLab.attributedText=inteAttr;
    [self addSubview:_integralLab];
    [_integralLab sizeToFit];
    _integralLab.frame=CGRectMake(0, _nameLab.yh_+LTAutoW(23), ScreenW_Lit, _integralLab.h_);
    inteAttr=nil;
    
    //仅剩
    UIImageView *surpImg=[self createImgViewWithFrame:CGRectMake(ScreenW_Lit-LTAutoW(65), LTAutoW(32), LTAutoW(65), 26) imageName:@"shopDetailBG"];
    surpImg.tag=1000;
    [self addSubview:surpImg];
    
    NSString *surpStr=_giftmo.giftLimitNum_fmt;
    _surplusNum=[_giftmo.giftLimitNum integerValue];
    surpStr=emptyStr(surpStr)?@"仅剩 --份":_giftmo.giftLimitNum_fmt;
    _surplusNumLab = [self createLabWithFrame:CGRectMake(ScreenW_Lit-LTAutoW(58), LTAutoW(32), LTAutoW(120), 26) text:surpStr fontsize:LTAutoW(12)];
    _surplusNumLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_surplusNumLab];
    [_surplusNumLab sizeToFit];
    _surplusNumLab.frame=CGRectMake(ScreenW_Lit-_surplusNumLab.w_-LTAutoW(22), surpImg.y_, _surplusNumLab.w_, 26);
    surpImg.frame=CGRectMake(ScreenW_Lit-_surplusNumLab.w_-LTAutoW(30), surpImg.y_, _surplusNumLab.w_+LTAutoW(30), 26);
    
    CGFloat leftP=LTAutoW(16);
    NSString *validPoints_fmt1=[NSString stringWithFormat:@"%@ 积分 %@",_integralMo.validPoints_fmt1,_giftmo.poins];
    if (emptyStr(validPoints_fmt1)) {
        validPoints_fmt1=@" ";
    }
    //red积分
    _redIntegralLab = [self createLabWithFrame:CGRectMake(leftP, LTAutoW(220), 0.5*ScreenW_Lit, LTAutoW(20)) text:validPoints_fmt1 fontsize:LTAutoW(24)];
    _redIntegralLab.textColor=LTKLineRed;
    _redIntegralLab.textAlignment=NSTextAlignmentLeft;
    [self addSubview:_redIntegralLab];
    NSString *poins=[NSString stringWithFormat:@"%@",[_giftmo.poins numberDecimalFmt]];
    _redIntegralLab.attributedText=[self pointsAttrWithPoints:_integral];
    [_redIntegralLab sizeToFit];
    float width = _redIntegralLab.w_;
    _redIntegralLab.frame=CGRectMake(leftP, LTAutoW((220)), width+2, _redIntegralLab.h_);
    
    //删除线
    _delIntegralLab=[self createLabWithFrame:CGRectMake(_redIntegralLab.xw_, _redIntegralLab.y_+LTAutoW(4), 0.5*ScreenW_Lit, _redIntegralLab.h_) text:validPoints_fmt1 fontsize:LTAutoW(12)];
    _delIntegralLab.textColor=LTSubTitleColor;
    _delIntegralLab.textAlignment=NSTextAlignmentLeft;
    [self addSubview:_delIntegralLab];
    NSMutableAttributedString *subAttr=[[NSMutableAttributedString alloc] initWithString:poins];
    NSRange range = NSMakeRange(0, poins.length);
    NSDictionary *attrDic=@{NSFontAttributeName :DINProAutoFontSiz(LTAutoW(12)),
                            NSStrikethroughColorAttributeName:LTSubTitleColor,
                            NSStrikethroughStyleAttributeName:@(1),
                            NSForegroundColorAttributeName:LTSubTitleColor
                            };
    [subAttr setAttributes:attrDic range:range];
    _delIntegralLab.attributedText=subAttr;
    subAttr=nil;

    //vip折扣
    NSString *vip=_integralMo.vipLevelName_fmt;
    _vipColor = _vipColor?_vipColor:[LTUtils vipColor:([_integralMo.levelNum integerValue])];
     _vipLab = [self createLabWithFrame:CGRectMake(_redIntegralLab.x_, LTAutoW(252), LTAutoW(100), LTAutoW(16)) text:vip fontsize:LTAutoW(11)];
     _vipLab.font = autoFontSiz(11);
     _vipLab.textColor = _vipColor;
     _vipLab.textAlignment = NSTextAlignmentCenter;
    [ _vipLab layerRadius:3 borderColor:_vipColor borderWidth:0.5];
    [self addSubview: _vipLab];
    [_vipLab sizeToFit];
    _vipLab.frame=CGRectMake(_redIntegralLab.x_, LTAutoW(252), _vipLab.w_+8, LTAutoW(16));
    
    //倒计时
    UILabel *endLab=[self createLabWithFrame:CGRectMake(ScreenW_Lit-LTAutoW(16), LTAutoW(216), 100, 33) text:@"距离结束仅剩" fontsize:LTAutoW(12)];
    endLab.textColor=LTSubTitleColor;
    [self addSubview:endLab];
    [endLab sizeToFit];
    endLab.frame=CGRectMake(ScreenW_Lit-LTAutoW(16)-endLab.w_, LTAutoW(216), endLab.w_, endLab.h_);
    
    //倒计时view
    CGFloat countDownViewW = kGiftCountDownLabW *3 + kGiftCountDownMar*2;
    _countDownView=[[GiftCountDownView alloc]init];
    _countDownView.frame = CGRectMake(ScreenW_Lit - LTAutoW(16) - countDownViewW, self.h_-LTAutoW(44)-kGiftCountDownH, countDownViewW, kGiftCountDownH);
    [self addSubview:_countDownView];
    
    //兑换view
    _exchangeNumView=[[UIView alloc]init];
    _exchangeNumView.frame=CGRectMake(0, LTAutoW(280), ScreenW_Lit, LTAutoW(32));
    _exchangeNumView.backgroundColor=LTBgColor;
    [self addSubview:_exchangeNumView];
    
    UIColor *discountColor = LTColorHex(0xFF7901);
    NSString *exchangeNumStr=[NSString stringWithFormat:@"%@  %@",_giftmo.takeNum_fmt,_giftmo.giftLimitNum_fmt];
    _exchangeNum=[_giftmo.takeNum integerValue];
    _exchangeNumLab = [self createLabWithFrame:CGRectMake(0, LTAutoW(12), ScreenW_Lit, 26) text:exchangeNumStr fontsize:LTAutoW(12)];
    _exchangeNumLab.textColor=LTSubTitleColor;
    _exchangeNumLab.textAlignment = NSTextAlignmentRight;
    _exchangeNumLab.attributedText=[self attrWithStr:_exchangeNumLab.text subStr:_giftmo.giftLimitNum_fmt subColor:discountColor];
    [_exchangeNumView addSubview:_exchangeNumLab];
    [_exchangeNumLab sizeToFit];
    _exchangeNumLab.frame=CGRectMake(0, LTAutoW(12), ScreenW_Lit-LTAutoW(16), _exchangeNumLab.h_);
}
#pragma mark - set data

-(void)setName:(NSString *)name{
    _name=name;
    _nameLab.text=_name;
}
-(void)setTime:(NSTimeInterval)time{
    _time=time;
    [_countDownView refTimeInterval:_time];
}
-(void)setCardBGUrl:(NSString *)cardBGUrl {
    if (!emptyStr(cardBGUrl)) {
        _cardBGUrl=cardBGUrl;
        [_cardBG lt_setImageWithURL:_cardBGUrl placeholderImage:[UIImage imageNamed:@"cardBG"]];
    }
}
-(void)setSurplusNum:(NSInteger)surplusNum {
    _surplusNum=surplusNum;
    _surplusNumLab.text=[NSString stringWithFormat:@"仅剩%li份",_surplusNum];
}
-(void)setExchangeNum:(NSInteger)exchangeNum {
    _exchangeNum=exchangeNum;
    UIColor *discountColor = LTColorHex(0xFF7901);
    NSString *exchangeNumStr=[NSString stringWithFormat:@"%li人已兑换  %@",exchangeNum ,_surplusNumLab.text];
    _exchangeNumLab.attributedText=[self attrWithStr:exchangeNumStr subStr:_surplusNumLab.text subColor:discountColor];
}
#pragma mark - private
-(NSAttributedString *)attrWithStr:(NSString *)str subStr:(NSString *)subStr subColor:(UIColor *)color {
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range = [str rangeOfString:subStr];
    // 设置颜色
    [attrStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    return attrStr;
}

-(NSAttributedString *)pointsAttrWithPoints:(NSString *)points {
    
    NSString *str=[NSString stringWithFormat:@"%@ 积分",points];
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range1 = [str rangeOfString:@"积分"];
    [attrStr addAttribute:NSForegroundColorAttributeName value:LTTitleColor range:range1];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:LTAutoW(12)] range:range1];
    [attrStr addAttribute:NSFontAttributeName value:DINProAutoBoldFontSiz(LTAutoW(24)) range:NSMakeRange(0, points.length)];
    return attrStr;
}


-(NSAttributedString *)pointsAttrWithPoints:(NSString *)points subStr:(NSString *)subStr {
    
    NSString *str=[NSString stringWithFormat:@"%@ 积分",points];
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range1 = [str rangeOfString:@"积分"];
    [attrStr addAttribute:NSForegroundColorAttributeName value:LTTitleColor range:range1];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:LTAutoW(12)] range:range1];
    [attrStr addAttribute:NSFontAttributeName value:DINProAutoBoldFontSiz(LTAutoW(20)) range:NSMakeRange(0, points.length)];

    NSMutableAttributedString *subAttr=[[NSMutableAttributedString alloc] initWithString:subStr];
    NSRange range = NSMakeRange(0, subStr.length);
    //删除线
    
    NSDictionary *attrDic=@{NSFontAttributeName :DINProAutoFontSiz(LTAutoW(12)),
                                        NSStrikethroughColorAttributeName:LTSubTitleColor,
                                        NSStrikethroughStyleAttributeName:@(1),
                                        NSForegroundColorAttributeName:LTSubTitleColor
                                                  };
    [subAttr setAttributes:attrDic range:range];
    [attrStr appendAttributedString:subAttr];
    subAttr=nil;
    return attrStr;
}

#pragma mark - utils
-(UIButton *)createBtnWithFrame:(CGRect)frame title:(NSString *)title fontsize:(CGFloat)fsize{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:fsize];
    return btn;
}
-(UILabel *)createLabWithFrame:(CGRect)frame text:(NSString *)text fontsize:(CGFloat)fsize{
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
-(UIImageView *)createImgViewWithFrame:(CGRect)frame imageName:(NSString *)image{
    UIEdgeInsets insets = UIEdgeInsetsMake(2, 13, 2, 2);
    UIImage *img =[UIImage imageNamed:image];
    img = [img resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    UIImageView *imgv=[[UIImageView alloc]initWithImage:img];
    imgv.frame=frame;
    return imgv;
}

@end
