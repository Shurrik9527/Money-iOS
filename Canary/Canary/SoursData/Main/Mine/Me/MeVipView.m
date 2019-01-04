//
//  MeVipView.m
//  ixit
//
//  Created by litong on 2016/12/12.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "MeVipView.h"

#define  kMeOrangeColor     LTColorHex(0xFF7901)
#define  kMeGrayColor         LTSubTitleColor

#define kMe6WhiteColor      LTColorHexA(0xFFFFFF, 0.6)

@interface MeVipView()
{
    BOOL newTheme;
}
@property (nonatomic,strong) UILabel *lab1;//vip等级
@property (nonatomic,strong) UILabel *lab2;//vip等级
@property (nonatomic,strong) UILabel *lab3;//vip等级

@property (nonatomic,strong) UILabel *subLab1;//vip等级 相应的经验值
@property (nonatomic,strong) UILabel *subLab2;//vip等级 相应的经验值
@property (nonatomic,strong) UILabel *subLab3;//vip等级 相应的经验值

@property (nonatomic,strong) UIImageView *experienceIV;//vip橙色条
@property (nonatomic,strong) UIImageView *grayIV;//vip灰色条
@property (nonatomic,strong) UIImageView *pointIV;//当前经验 白色小圆点

@property (nonatomic,strong) UIImageView *IV1;//vip等级小竖条
@property (nonatomic,strong) UIImageView *IV2;//vip等级小竖条
@property (nonatomic,strong) UIImageView *IV3;//vip等级小竖条


@end

@implementation MeVipView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        newTheme = useNewYearTheme;
        [self createView];
    }
    return self;
}

static CGFloat tempPer = 0.136;
static CGFloat labH = 15;
static CGFloat subLabH = 12;
static CGFloat labW = 100;
static CGFloat ivW = 1;
static CGFloat ivH = 5;
static CGFloat pointIVWH = 12;

- (void)createView {
    
    CGFloat oneCenterX = ScreenW_Lit*tempPer;
    self.lab1 = [self labWithX:(oneCenterX - LTAutoW(labW)*0.5)];
    [self addSubview:_lab1];
    self.lab2 = [self labWithX:(ScreenW_Lit - LTAutoW(labW))*0.5];
    _lab2.textColor =  newTheme ? LTWhiteColor : kMeOrangeColor;
    [self addSubview:_lab2];
    self.lab3 = [self labWithX:(ScreenW_Lit*(1-tempPer) - LTAutoW(labW)*0.5)];
    [self addSubview:_lab3];
    
    self.subLab1 = [self subLabWithX:_lab1.x_];
    [self addSubview:_subLab1];
    self.subLab2 = [self subLabWithX:_lab2.x_];
    [self addSubview:_subLab2];
    self.subLab3 = [self subLabWithX:_lab3.x_];
    [self addSubview:_subLab3];
    
    self.experienceIV = [[UIImageView alloc] init];
    _experienceIV.frame = CGRectMake(0, _lab1.yh_ + LTAutoW(8), ScreenW_Lit, LTAutoW(2));
    [self addSubview:_experienceIV];
    
    self.grayIV = [[UIImageView alloc] init];
    [_experienceIV addSubview:_grayIV];
    
    if (useNewYearTheme) {
        _experienceIV.backgroundColor = LTWhiteColor;
        _grayIV.backgroundColor = LTColorHex(0xDD333B);
        
    } else {
        _experienceIV.image = [UIImage imageNamed:@"Me_pic_LvOrange"];
        _grayIV.image = [UIImage imageNamed:@"Me_pic_LvGrey"];
    }
    
    
    self.pointIV = [[UIImageView alloc] init];
    _pointIV.frame = CGRectMake(0, 0, LTAutoW(pointIVWH), LTAutoW(pointIVWH));
    _pointIV.image = [UIImage imageNamed:@"Me_pic_LvWhite"];
    [self addSubview:_pointIV];
    
    
    self.IV1 = [self ivWithCenterX:oneCenterX];
    [self addSubview:_IV1];
    self.IV2 = [self ivWithCenterX:ScreenW_Lit*0.5];
    _IV2.backgroundColor =  newTheme ? kMe6WhiteColor : kMeOrangeColor;
    [self addSubview:_IV2];
    self.IV3 = [self ivWithCenterX:ScreenW_Lit*(1-tempPer)];
    [self addSubview:_IV3];

}

- (NSAttributedString *)ABStr:(NSInteger)vip {
    NSString *vipStr = [NSString stringWithInteger:vip];
    NSString *str = [NSString stringWithFormat:@"V%@",vipStr];
    NSAttributedString *ABStr = [str ABStrFont:autoFontSiz(12) range:NSMakeRange(1, vipStr.length)];
    return ABStr;
}

#pragma mark - 外部

- (void)refView:(IntegralMo *)obj {
    
    
    NSInteger vip = [obj.levelNum integerValue];

    
    //1：白点显示在第一等级区间，0：白点显示在第二等级区间
    NSInteger hasSecPer = 0;
    
    NSInteger vip1 = 1;
    if (vip == 1) {
        hasSecPer = 1;
        _lab1.text = [NSString stringWithFormat:@"V%@",@(vip1)];
        _lab2.attributedText = [self ABStr:(vip1+1)];
        _lab3.attributedText = [self ABStr:(vip1+2)];
        
        _lab1.textColor =  newTheme ? LTWhiteColor : kMeOrangeColor;
        _lab2.textColor =  newTheme ? kMe6WhiteColor : kMeGrayColor;
        
        _IV1.backgroundColor =  newTheme ? LTWhiteColor : kMeOrangeColor;
        _IV2.backgroundColor =  newTheme ? kMe6WhiteColor : kMeGrayColor;
        
        
        if (newTheme) {
            _lab1.font = autoBoldFontSiz(15);
        }
        
    } else if (vip >= 7) {
        
        vip1 = vip-1;
        _lab1.attributedText = [self ABStr:(vip1)];
        _lab2.text = [NSString stringWithFormat:@"V%@",@(vip1+1)];
//        _lab3.attributedText = [self ABStr:(vip1+2)];
        _lab3.text = @"敬请期待";
        _lab3.font = autoFontSiz(12);
        
        _lab1.textColor =  newTheme ? kMe6WhiteColor : kMeGrayColor;
        _lab2.textColor =  newTheme ? LTWhiteColor : kMeOrangeColor;
        
        _IV1.backgroundColor =  newTheme ? kMe6WhiteColor : kMeGrayColor;
        _IV2.backgroundColor =  newTheme ? LTWhiteColor : kMeOrangeColor;
        
        if (newTheme) {
            _lab2.font = autoBoldFontSiz(15);
        }
        
    } else {
        if (vip > 1) {
            vip1 = vip-1;
            _lab1.attributedText = [self ABStr:(vip1)];
            _lab2.text = [NSString stringWithFormat:@"V%@",@(vip1+1)];
            _lab3.attributedText = [self ABStr:(vip1+2)];
            
            _lab1.textColor =  newTheme ? kMe6WhiteColor : kMeGrayColor;
            _lab2.textColor =  newTheme ? LTWhiteColor : kMeOrangeColor;
            
            _IV1.backgroundColor =  newTheme ? kMe6WhiteColor : kMeGrayColor;
            _IV2.backgroundColor =  newTheme ? LTWhiteColor : kMeOrangeColor;
            
            if (newTheme) {
                _lab2.font = autoBoldFontSiz(15);
            }
        }
    }
    
    
    
    
    NSArray *vipValueArr = [IntegralMo vipLvList];
    _subLab1.text = vipValueArr[vip1-1];
    _subLab2.text = vipValueArr[(vip1)];
    _subLab3.text = vipValueArr[(vip1+1)];
    
    
    long long int minExp = [obj.minExp longLongValue];
    long long int maxExp = [obj.maxExp longLongValue];
    long long int totalExp = [obj.totalExp longLongValue];
    long long int curExp = totalExp-minExp;
//    CGFloat curPer = obj.nextLevelRate;//当前等级的经验百分比
    CGFloat curPer = 1.0*curExp/(maxExp-minExp);//当前等级的经验百分比
    
    
    
    CGFloat vipPer = (1-2*tempPer)*0.5;
    CGFloat gPer = 1 - tempPer - (1-curPer)*vipPer - hasSecPer*vipPer;
    CGFloat pointX = gPer*ScreenW_Lit;
    _grayIV.frame = CGRectMake(pointX, 0, ScreenW_Lit-pointX, _experienceIV.h_);
    
    _pointIV.center = CGPointMake(pointX, _experienceIV.center.y);
    
    
}




#pragma mark - utils

- (UIImageView *)ivWithCenterX:(CGFloat)x {
    UIImageView *iv = [[UIImageView alloc] init];
    iv.frame = CGRectMake(0, 0, LTAutoW(ivW), LTAutoW(ivH));
    iv.center = CGPointMake(x, _experienceIV.center.y);
    iv.backgroundColor =  newTheme ? kMe6WhiteColor : kMeGrayColor;
    return iv;
}

- (UILabel *)labWithX:(CGFloat)x {
    CGRect r = CGRectMake(x, 0, LTAutoW(labW), LTAutoW(labH));
    return [self lab:r fontSize:labH];
}

- (UILabel *)subLabWithX:(CGFloat)x {
    CGRect r = CGRectMake(x, LTAutoW(kMeVipViewH)-LTAutoW(subLabH), LTAutoW(labW), LTAutoW(subLabH));
    return [self lab:r fontSize:subLabH];
}

- (UILabel *)lab:(CGRect)r fontSize:(CGFloat)fontSize {
    UILabel *lab = [[UILabel alloc] initWithFrame:r];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor =  newTheme ? kMe6WhiteColor : kMeGrayColor;
    lab.font = autoFontSiz(fontSize);
    return lab;
}





@end
