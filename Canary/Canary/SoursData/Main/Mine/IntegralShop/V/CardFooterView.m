//
//  CardFooterView.m
//  ixit
//
//  Created by Brain on 2017/4/6.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "CardFooterView.h"
@interface CardFooterView()
@property (nonatomic,strong) UIButton * exchangeBtn;/** 兑换按钮*/
@property (nonatomic,strong) UILabel * amountLab;/** 总计lab*/
@property (nonatomic,strong) UILabel * balanceLab;/** 余额lab*/
@property(assign,nonatomic)NSInteger points;/*< 需要消耗的积分*/
@property(assign,nonatomic)BOOL notEnableBtn;/*< 能否点击 YES =不能*/

@end

@implementation CardFooterView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=LTWhiteColor;
        [self createView];
    }
    return self;
}
#pragma mark - init view
-(void)createView {
    self.layer.masksToBounds=NO;
    self.layer.shadowColor=LTTitleColor.CGColor;
    self.layer.shadowOpacity = 0.12;//阴影透明度，默认0
    self.layer.shadowOffset=CGSizeMake(0, -2.5);
    //兑换按钮
    if(!_exchangeBtn){
        _exchangeBtn=[self createBtnWithFrame:CGRectMake(ScreenW_Lit-LTAutoW(112), 0, LTAutoW(112), self.h_) title:@"已抢光" fontsize:LTAutoW(17)];
        _exchangeBtn.backgroundColor=LTColorHexA(0x848999, 0.3);
        [_exchangeBtn addTarget:self action:@selector(reqUserGiftChange) forControlEvents:UIControlEventTouchUpInside];
        _exchangeBtn.enabled=NO;
        [self addSubview:_exchangeBtn];
    }
    //总计
    CGFloat left = LTAutoW(16);
    UILabel *aL=[self createLabWithFrame:CGRectMake(left, LTAutoW(11), 0.5*ScreenW_Lit, 20) text:@"总计" fontsize:LTAutoW(15)];
    aL.textColor=LTSubTitleColor;
    [self addSubview:aL];
    [aL sizeToFit];
    aL.frame=CGRectMake(left, LTAutoW(11), aL.w_, aL.h_);
    
    if (!_amountLab) {
        _amountLab=[self createLabWithFrame:CGRectMake(aL.xw_+LTAutoW(10), LTAutoW(10), 0.5*ScreenW_Lit, 20) text:@"----" fontsize:LTAutoW(12)];
        _amountLab.textColor=LTKLineRed;
        [self addSubview:_amountLab];
    }
    
    if (!_balanceLab) {
        _balanceLab=[self createLabWithFrame:CGRectMake(left, _amountLab.yh_+5, 0.5*ScreenW_Lit, 16) text:@"积分余额:" fontsize:LTAutoW(12)];
        _balanceLab.textColor=LTSubTitleColor;
        [self addSubview:_balanceLab];
        [_balanceLab sizeToFit];
        _balanceLab.frame=CGRectMake(left, self.h_-_balanceLab.h_-LTAutoW(11), 0.5*ScreenW_Lit, 16);
    }
}
#pragma mark - set data
-(void)setBuyStatus:(NSInteger)buyStatus {
    _buyStatus=buyStatus;
    NSString *exTitle = @"已抢光";
    BOOL enableBtn=NO;
    UIColor *color=LTSubTitleColor;
    switch (buyStatus) {
        case 0: {
            //判断积分是否足够
            enableBtn=YES;
            exTitle=@"马上抢";
            
            enableBtn = enableBtn && !_notEnableBtn;
            color=enableBtn?LTKLineRed:LTColorHexA(0x848999, 0.3);
            
        }
            break;
        case 1:{
            exTitle=@"已兑换";
        }
            break;
        case 2:{
            exTitle=@"已抢光";
        }
            break;
        default:
            break;
    }
    [_exchangeBtn setNorTitle:exTitle];
    [_exchangeBtn setBackgroundColor:color];
    _exchangeBtn.enabled=enableBtn;
}
-(void)setValidPoints:(NSInteger)validPoints{
    if (validPoints>=0) {
        _validPoints=validPoints;
        NSString *validStr = [[NSNumber numberWithInteger:_validPoints] numberDecimalFmt];//积分转换格式化字符串
        NSString *balanceStr =[NSString stringWithFormat:@"积分余额：%@",validStr];
        NSRange range = [balanceStr rangeOfString:validStr];
        NSMutableAttributedString *balanceAttr=[[NSMutableAttributedString alloc]initWithString:balanceStr];
        [balanceAttr addAttribute:NSFontAttributeName value:DINProAutoFontSiz(LTAutoW(12)) range:range];
        _balanceLab.attributedText=balanceAttr;
        balanceAttr=nil;
    }
}
-(void)setNotEnableBtn:(BOOL)notEnableBtn{
    _notEnableBtn=notEnableBtn;
    if (_notEnableBtn) {
        [_exchangeBtn setBackgroundColor:LTSubTitleColor];
        _exchangeBtn.enabled=NO;
    }
}
#pragma mark - private method
-(void)reqUserGiftChange {
    _reqGiftChangeBlock?_reqGiftChangeBlock():nil;
}
#pragma mark - utils
-(UIView *)createV{
    UIView *v=[[UIView alloc]init];
    v.backgroundColor=LTClearColor;
    return v;
}
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
    label.textAlignment=NSTextAlignmentLeft;
    label.numberOfLines=0;
    label.textColor=LTSubTitleColor;
    label.font=[UIFont systemFontOfSize:fsize];
    return label;
}
-(UIImageView *)createImgViewWithFrame:(CGRect)frame imageName:(NSString *)image{
    UIImageView *imgv=[[UIImageView alloc]initWithImage:[UIImage imageNamed:image]];
    imgv.frame=frame;
    return imgv;
}

#pragma mark - 外部


- (void)refreshWithMo:(GiftMO *)giftmo integralMo:(IntegralMo *) integralMo {
    
//    self.validPoints= [integralMo.validPoints isNotNull] ? [integralMo.validPoints integerValue] : -1;
//    CGFloat rate = [integralMo.rebateRate isNotNull] ? [integralMo.rebateRate floatValue]:1;
//    _points=[integralMo.rebateRate floatValue] *[giftmo.poins integerValue];//计算折扣后的积分值
//    NSNumber *jf = @(_points);
//    self.buyStatus=giftmo.buyStatus;
//    NSString *rateStr = rate<1?[NSString stringWithFormat:@"%g",rate*10]:@"";//折扣值
//    NSString *pointsStr=[jf numberDecimalFmt];
//    [self amountAttr:rateStr pointsStr:pointsStr];
//    
//    self.notEnableBtn=giftmo.btnNotEnable;
}
-(void)amountAttr:(NSString *)rateStr pointsStr:(NSString *)pointsStr {
    NSString *amountStr=[NSString stringWithFormat:@"%@（已打%@折）",pointsStr,rateStr];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:amountStr];
    NSRange range = [amountStr rangeOfString:pointsStr];
    NSRange range1 = NSMakeRange(pointsStr.length, (amountStr.length-pointsStr.length));
    
    [attr addAttribute:NSFontAttributeName value:DINProAutoBoldFontSiz(LTAutoW(20))range:range];
    [attr addAttribute:NSBaselineOffsetAttributeName value:@(LTAutoW(2)) range:range1];
    _amountLab.attributedText=attr;
    [_amountLab sizeToFit];
    CGRect frame = _amountLab.frame;
    frame.origin.y=LTAutoW(6);
    _amountLab.frame=frame;
    attr=nil;
}
@end
