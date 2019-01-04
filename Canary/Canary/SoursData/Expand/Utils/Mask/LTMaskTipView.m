//
//  LTMaskTipView.m
//  ixit
//
//  Created by litong on 2016/12/27.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "LTMaskTipView.h"

typedef NS_ENUM(NSUInteger, MaskTipTag) {
    MaskTipTag_Nor=50001,
    MaskTipTag_Lv=50002,
};

typedef NS_ENUM(NSUInteger, MaskTipType) {
    MaskTipType_Integral,//积分
    MaskTipType_Vip,//VIP等级
    MaskTipType_Task,//任务中心
    MaskTipType_TaskFinish,//任务完成，获得积分提示
};


@interface LTMaskTipView ()

@property (nonatomic,assign) MaskTipType maskTipType;

@property (nonatomic,copy) LTMaskTipBlock cancleBlock;
@property (nonatomic,copy) LTMaskTipBlock sureBlock;

@property (nonatomic,strong) UIImageView *tipView;
@property (nonatomic,strong) UILabel *lvLab;//vip等级
@property (nonatomic,strong) UILabel *discountLab;//折扣

@property (nonatomic,strong) UILabel *tipLab;

@end

@implementation LTMaskTipView


- (instancetype)initWithFrame:(CGRect)frame maskTipType:(MaskTipType)maskTipType{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = LTMaskColor;
        self.maskTipType = maskTipType;
        [self createView];
    }
    return self;
}

- (CGFloat)tipViewW {
    //积分 、VIP等级  、任务中心
    return 266;
}

- (CGFloat)tipViewH {
    
    if (_maskTipType == MaskTipType_Task) {
        //任务中心
        return 308;
    } else if (_maskTipType == MaskTipType_TaskFinish) {
        //任务完成，获得积分提示
        return 288;
    } else {
        //    MaskTipType_Integral,//积分  MaskTipType_Vip,//VIP等级
        return 339;
    }
}


- (void)createView {
    self.tipView = [[UIImageView alloc] init];
    self.tipView.frame = CGRectMake((self.w_ - LTAutoW(self.tipViewW))*0.5, (self.h_ - LTAutoW(self.tipViewH))*0.5, LTAutoW(self.tipViewW), LTAutoW(self.tipViewH));
    self.tipView.userInteractionEnabled = YES;
    [self addSubview:self.tipView];

    
    CGFloat lrBtnW = LTAutoW(112);
    CGFloat lrBtnH = LTAutoW(36);
    UIButton *leftBtn = [UIButton btnWithTarget:self action:@selector(leftBtnAction) frame:CGRectMake(LTAutoW(16), _tipView.h_ - LTAutoW(24) - lrBtnH, lrBtnW, lrBtnH)];
    leftBtn.backgroundColor = LTClearColor;
    [_tipView addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton btnWithTarget:self action:@selector(rightBtnAction) frame:CGRectMake(leftBtn.xw_ + LTAutoW(10), leftBtn.y_, lrBtnW, lrBtnH)];
    rightBtn.backgroundColor = LTClearColor;
    [_tipView addSubview:rightBtn];
    
    
    if (self.maskTipType == MaskTipType_Integral ||
        self.maskTipType == MaskTipType_Vip) {
        CGFloat cancleBtnWH = LTAutoW(43);
        UIButton *cancleBtn = [UIButton btnWithTarget:self action:@selector(cancleAction) frame:CGRectMake(_tipView.w_ - cancleBtnWH, 0, cancleBtnWH, cancleBtnWH)];
        cancleBtn.backgroundColor = LTClearColor;
        [_tipView addSubview:cancleBtn];
    }
    
    
    if (self.maskTipType == MaskTipType_Vip) {
        self.lvLab = [[UILabel alloc] init];
        _lvLab.frame = LTRectAutoW(135.25, 165, 23, 35);
        _lvLab.font = autoFontSiz(32);
        _lvLab.textColor = LTWhiteColor;
        [_tipView addSubview:_lvLab];
        _lvLab.hidden = YES;
        
        self.discountLab = [[UILabel alloc] init];
        _discountLab.frame = LTRectAutoW(0, 218, self.tipViewW, 40);
        _discountLab.font = autoFontSiz(15);
        _discountLab.textColor = LTSubTitleColor;
        _discountLab.textAlignment = NSTextAlignmentCenter;
        [_tipView addSubview:_discountLab];
        _discountLab.hidden = YES;
    } else if (self.maskTipType == MaskTipType_TaskFinish) {
        self.tipLab = [[UILabel alloc] init];
        _tipLab.frame = LTRectAutoW(0, 32, self.tipViewW, 33.5);
        _tipLab.font = autoFontSiz(24);
        _tipLab.textColor = LTTitleColor;
        _tipLab.textAlignment = NSTextAlignmentCenter;
        [_tipView addSubview:_tipLab];
    }
    
    
    self.hidden = YES;
    
    
}

- (void)setTipImg:(NSString *)imgName {
    _tipView.image = [UIImage imageNamed:imgName];
}


- (void)cancleAction {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    for (id obj in keyWindow.subviews) {
        if ([obj isKindOfClass:[LTMaskTipView class]]) {
            LTMaskTipView *mtv = (LTMaskTipView *)obj;
            [mtv removeFromSuperview];
        }
    }
}

- (void)leftBtnAction {
    _cancleBlock ? _cancleBlock() : nil;
    
    [self cancleAction];
}

- (void)rightBtnAction {
    _sureBlock ? _sureBlock() : nil;
    
    [self cancleAction];
}


#pragma mark 外部

+ (void)showIntegralOnline:(LTMaskTipBlock)sureBlock cancleBlock:(LTMaskTipBlock)cancle {
    
    BOOL bl = [UserDefaults boolForKey:showIntegralOnlineKey];
    if (bl) {
        return;
    }
    
    NSString *showRedKey = @"showRedEnvelopes";
    BOOL showRed = [UserDefaults boolForKey:showRedKey];
    if (!showRed) {
        return;
    }
    
    LTMaskTipView *mtv = [[LTMaskTipView alloc] initWithFrame:ScreenBounds_Lit maskTipType:MaskTipType_Integral];
    mtv.hidden = NO;
    [mtv setTipImg:@"jfgnsxl"];
    mtv.tag = MaskTipTag_Nor;
    
    [UserDefaults setBool:YES forKey:showIntegralOnlineKey];
    
    mtv.cancleBlock = cancle;
    mtv.sureBlock = sureBlock;
    
    [[UIApplication sharedApplication].keyWindow addSubview:mtv];
    
}



+ (void)showVipLvUp:(LTMaskTipBlock)sureBlock cancleBlock:(LTMaskTipBlock)cancle {
    
    if (![LTUser hasLogin]) {
        return;
    }
    
    NSNumber *lv = [LTUser userVipLv];
    if (!lv) {
        return;
    }
    if ([lv integerValue] <= 1) {
        return;
    }
    
    LTMaskTipView *mtv = [[LTMaskTipView alloc] initWithFrame:ScreenBounds_Lit maskTipType:MaskTipType_Vip];
    mtv.hidden = NO;
    [mtv setTipImg:@"vipLvUp"];
    mtv.tag = MaskTipTag_Lv;
    mtv.lvLab.hidden = NO;
    mtv.discountLab.hidden = NO;
    mtv.lvLab.text = [NSString stringWithFormat:@"%@",lv];
    
    NSString *discount = [LTUser userVipLvDiscount];
    NSString *strPre = @"您可以享受商城   ";
    NSString *str = [NSString stringWithFormat:@"%@%@   折优惠",strPre,discount];
    NSAttributedString *ABStr = [str ABStrColor:LTColorHex(0xFF7901) font:autoFontSiz(32) range:NSMakeRange(strPre.length, discount.length)];
    mtv.discountLab.attributedText = ABStr;
    
    mtv.cancleBlock = cancle;
    mtv.sureBlock = sureBlock;
    
    [[UIApplication sharedApplication].keyWindow addSubview:mtv];
}


//TaskTip
+ (void)showTaskTip:(LTMaskTipBlock)sureBlock cancleBlock:(LTMaskTipBlock)cancle {
    
    if (![LTUser hasLogin]) {
        return;
    }
    
    BOOL bl = [UserDefaults boolForKey:showTaskTipKey];
    if (bl) {
        return;
    }
    
    LTMaskTipView *mtv = [[LTMaskTipView alloc] initWithFrame:ScreenBounds_Lit maskTipType:MaskTipType_Task];
    mtv.hidden = NO;
    [mtv setTipImg:@"TaskTip"];
    mtv.tag = MaskTipTag_Nor;
    
    [UserDefaults setBool:YES forKey:showTaskTipKey];
    
    mtv.cancleBlock = cancle;
    mtv.sureBlock = sureBlock;
    
    [[UIApplication sharedApplication].keyWindow addSubview:mtv];
    
}

//任务完成获得积分提示
+ (void)showTaskFinishTip:(LTMaskTipBlock)sureBlock cancleBlock:(LTMaskTipBlock)cancle point:(NSString *)point {
    
    LTMaskTipView *mtv = [[LTMaskTipView alloc] initWithFrame:ScreenBounds_Lit maskTipType:MaskTipType_TaskFinish];
    mtv.hidden = NO;
    [mtv setTipImg:@"TaskFinishTip"];
    mtv.tag = MaskTipTag_Nor;
    
    NSString *str = [NSString stringWithFormat:@"恭喜您获得%@积分",point];
    NSRange range = [str rangeOfString:point];
    NSAttributedString *ABStr = [str ABStrColor:LTColorHex(0xFF7901) range:range];
    mtv.tipLab.attributedText = ABStr;
    
    mtv.cancleBlock = cancle;
    mtv.sureBlock = sureBlock;
    
    [[UIApplication sharedApplication].keyWindow addSubview:mtv];
}

@end
