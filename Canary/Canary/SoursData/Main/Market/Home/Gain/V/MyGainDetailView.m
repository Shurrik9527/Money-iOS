//
//  MyGainDetailView.m
//  ixit
//
//  Created by litong on 2016/11/24.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "MyGainDetailView.h"

@interface MyGainDetailView ()

@property (nonatomic,strong)UIView *oneView;
@property (nonatomic,strong)UIView *colorView;//颜色
@property (nonatomic,strong)UILabel *upDownLab;//买涨  吉银1000g 1手

@property (nonatomic,strong)UIView *twoView;
@property (nonatomic,strong)UILabel *openPriceLab;//建仓价格
@property (nonatomic,strong)UILabel *closePriceLab;//平仓价格
@property (nonatomic,strong)UILabel *openTimeLab;//建仓时间
@property (nonatomic,strong)UILabel *closeTimeLab;//平仓时间

@property (nonatomic,strong)UIView *threeView;
@property (nonatomic,strong)UILabel *gainLab;//盈亏
@property (nonatomic,strong)UILabel *feeLab;//手续费

@property (nonatomic,strong)UIView *fourView;
@property (nonatomic,strong)UILabel *buyTpyeLab;//购买类型
@property (nonatomic,strong)UILabel *closeTpyeLab;//平仓类型

@end


@implementation MyGainDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = LTWhiteColor;
        [self createVeiw];
    }
    return self;
}

- (void)createVeiw {
    [self creaeOneView];
    [self creaeTwoView];
    [self creaeThreeView];
    [self creaeFourView];
}

static CGFloat leftMar = 21;
- (void)creaeOneView {
    self.oneView = [[UIView alloc] init];
    _oneView.frame = CGRectMake(0, 0, self.w_, LTAutoW(52));
    [self addSubview:_oneView];
    
    CGFloat topMar = 7;
    //颜色
    CGFloat colorViewH = LTAutoW(20);
    self.colorView = [[UIView alloc] init];
    _colorView.frame = CGRectMake(0, (_oneView.h_ - colorViewH)/2.0 + topMar-1, LTAutoW(4), colorViewH);
    [_oneView addSubview:_colorView];
    
    //买涨  吉银1000g 1手
    CGRect rect = CGRectMake(LTAutoW(leftMar), topMar, _oneView.w_-LTAutoW(leftMar), _oneView.h_-topMar);
    self.upDownLab = [self lab:rect fontSize:17];
    [_oneView addSubview:_upDownLab];
    
}

static CGFloat leftLabW = 150;

- (void)creaeTwoView {
    CGFloat twoViewH = LTAutoW(90);
    self.twoView = [[UIView alloc] init];
    _twoView.frame = CGRectMake(0, _oneView.yh_, self.w_, twoViewH);
    [self addSubview:_twoView];
    
    CGFloat labSize = 15.f;
    CGFloat priceW = LTAutoW(leftLabW);
    CGFloat labH = twoViewH/2.0;
    
    //建仓价格
    CGRect rect0 = CGRectMake(LTAutoW(leftMar), 0, priceW, labH);
    self.openPriceLab = [self lab:rect0 fontSize:labSize];
    [_twoView addSubview:_openPriceLab];
    
    //平仓价格
    CGRect rect1 = CGRectMake(LTAutoW(leftMar), _openPriceLab.yh_, priceW, labH);
    self.closePriceLab = [self lab:rect1 fontSize:labSize];
    [_twoView addSubview:_closePriceLab];
    
    CGFloat timeLeft = _openPriceLab.xw_;
    CGFloat timeLabW = _twoView.w_ - timeLeft - LTAutoW(10);
    //建仓时间
    CGRect rect2 = CGRectMake(timeLeft, 0, timeLabW, labH);
    self.openTimeLab = [self lab:rect2 fontSize:labSize];
    [_twoView addSubview:_openTimeLab];
    
    //平仓时间
    CGRect rect3 = CGRectMake(timeLeft, _openTimeLab.yh_, timeLabW, labH);
    self.closeTimeLab = [self lab:rect3 fontSize:labSize];
    [_twoView addSubview:_closeTimeLab];
    
    
    [self twoViewAddLine:labH];
    [self twoViewAddLine:twoViewH];
}

- (void)creaeThreeView {
    CGFloat threeViewH = LTAutoW(45);
    self.threeView = [[UIView alloc] init];
    _threeView.frame = CGRectMake(0, _twoView.yh_, self.w_, threeViewH);
    [self addSubview:_threeView];
    
    //盈亏
    CGRect rect0 = CGRectMake(LTAutoW(leftMar), 0, LTAutoW(leftLabW), threeViewH);
    self.gainLab = [self lab:rect0 fontSize:15];
    [_threeView addSubview:_gainLab];
    
    //手续费
    CGFloat feeLabX = _gainLab.xw_;
    CGFloat feeLabW = _threeView.w_ - feeLabX - LTAutoW(10);
    CGRect rect1 = CGRectMake(feeLabX, 0, feeLabW, threeViewH);
    self.feeLab = [self lab:rect1 fontSize:15];
    [_threeView addSubview:_feeLab];
}

- (void)creaeFourView {
    CGFloat fourViewH = LTAutoW(36);
    self.fourView = [[UIView alloc] init];
    _fourView.frame = CGRectMake(0, _threeView.yh_, self.w_, fourViewH);
    _fourView.backgroundColor = LTColorHexA(0xF0F2F5, 0.5);
    [self addSubview:_fourView];
    
    //购买类型
    CGRect rect0 = CGRectMake(LTAutoW(leftMar), 0, LTAutoW(leftLabW), fourViewH);
    self.buyTpyeLab = [self lab:rect0];
    [_fourView addSubview:_buyTpyeLab];
    
    //平仓类型
    CGFloat closeLabX = _openPriceLab.xw_;
    CGFloat closeLabW = _fourView.w_ - closeLabX - LTAutoW(10);
    CGRect rect1 = CGRectMake(closeLabX, 0, closeLabW, fourViewH);
    self.closeTpyeLab = [self lab:rect1];
    [_fourView addSubview:_closeTpyeLab];
}


- (UILabel *)lab:(CGRect)r {
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = r;
    lab.font = autoFontSiz(12);
    lab.textColor = LTSubTitleColor;
    return lab;
}

- (UILabel *)lab:(CGRect)r fontSize:(CGFloat)fontSize {
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = r;
    lab.font = autoFontSiz(fontSize);
    lab.textColor = LTTitleColor;
    return lab;
}


- (void)twoViewAddLine:(CGFloat)y {
        [_twoView addLine:LTLineColor frame:CGRectMake(0, y-.05, _twoView.w_, 0.5)];
}

- (NSString *)mdHmsStr:(NSString *)time {
    return [time stringFMD:@"MM-dd HH:mm:ss"];
}

#pragma mark - 外部

- (void)refData:(MyGainModel *)mo {
    NSString *upDownTypeStr = mo.type;
    UIColor *color = ([upDownTypeStr isEqualToString:@"买涨"]) ? LTKLineRed :  LTKLineGreen;
    self.colorView.backgroundColor = color;//1颜色
    
    NSString *upDownStr = [NSString stringWithFormat:
                           @"%@  %@%g%@ %ld手",
                           upDownTypeStr,
                           mo.productName,
                           mo.weight,
                           mo.unit,
                           (long)mo.orderNumber];
    NSAttributedString *ABStr = [upDownStr ABStrColor:color range:NSMakeRange(0, 2)];
    self.upDownLab.attributedText = ABStr;;//1买涨  吉银1000g 1手
    
    
    
    UIColor *gColor = LTSubTitleColor;
    NSString *openPrice = [NSString stringWithFormat:@"建仓价：%@",mo.createPrice];
    NSAttributedString *openPriceABStr = [openPrice ABStrColor:gColor range:NSMakeRange(0, 4)];
    
    NSString *closePrice = [NSString stringWithFormat:@"平仓价：%@",mo.closePrice];
    NSAttributedString *closePriceABStr = [closePrice ABStrColor:gColor range:NSMakeRange(0, 4)];
    
    NSString *openTime = [NSString stringWithFormat:@"建仓时间：%@",[self mdHmsStr:mo.createTime]];
    NSAttributedString *openTimeABStr = [openTime ABStrColor:gColor range:NSMakeRange(0, 5)];
    
    NSString *closeTime = [NSString stringWithFormat:@"平仓时间：%@",[self mdHmsStr:mo.closeTime]];
    NSAttributedString *closeTimeABStr = [closeTime ABStrColor:gColor range:NSMakeRange(0, 5)];
    
    self.openPriceLab.attributedText = openPriceABStr;//建仓价格
    self.closePriceLab.attributedText = closePriceABStr;//平仓价格
    self.openTimeLab.attributedText = openTimeABStr;//建仓时间
    self.closeTimeLab.attributedText = closeTimeABStr;//平仓时间
    

    NSString *gianTemp = @"盈    亏：";
    NSString *gainStr = mo.profitLoss;
    NSString *gain = [NSString stringWithFormat:@"%@%@元",gianTemp,gainStr];
    NSMutableAttributedString *gainABStr = [[NSMutableAttributedString alloc]initWithString:gain];
    [gainABStr setAttributes:@{NSForegroundColorAttributeName:gColor} range:NSMakeRange(0, gianTemp.length)];
    if (notemptyStr(gainStr)) {
        [gainABStr setAttributes:@{NSForegroundColorAttributeName:LTKLineRed} range:NSMakeRange(gianTemp.length, gainStr.length)];
    }
    _gainLab.attributedText = gainABStr;
    
    
    NSString *feeTemp = @"手  续  费：";
    NSString *feeStr = [NSString stringWithFormat:@"%@%@",feeTemp,mo.fee];
    NSAttributedString *feeABStr = [feeStr ABStrColor:gColor range:NSMakeRange(0, feeTemp.length)];
    _feeLab.attributedText = feeABStr;
    
    
    NSString *buy = @"账户余额";
    if(![mo.isJuan isEqualToString:@"未使用"]) {
        buy = @"代金券";
    }
    NSString *buyTpye = [NSString stringWithFormat:@"购买方式：%@",buy];
    _buyTpyeLab.text = buyTpye;
    NSString *closeTpye = [NSString stringWithFormat:@"平仓类型：%@",mo.closeType];
    _closeTpyeLab.text = closeTpye;
}



@end
