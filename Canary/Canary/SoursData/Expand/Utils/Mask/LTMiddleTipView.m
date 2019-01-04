//
//  LTMiddleTipView.m
//  ixit
//
//  Created by litong on 2017/1/16.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "LTMiddleTipView.h"

@interface LTMiddleTipView ()

@property (nonatomic,strong) UIImageView *tipView;
@property (nonatomic,strong) UIButton *shutBtn;//X关闭按钮
@property (nonatomic,strong) UIButton *cancleBtn;//取消按钮
@property (nonatomic,strong) UIButton *sureBtn;//确定按钮

@property (nonatomic,copy) LTMiddleTipViewBlock cancleBlock;
@property (nonatomic,copy) LTMiddleTipViewBlock sureBlock;
@property (nonatomic,copy) LTMiddleTipViewBlock shutBlock;


//关闭时：YES -> 从父view移除、NO -> 隐藏
@property (nonatomic,assign) BOOL removed;



@end

@implementation LTMiddleTipView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = LTMaskColor;
        [self createView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = LTMaskColor;
        [self createView];
    }
    return self;
}

- (void)createView {
    self.tipView = [[UIImageView alloc] init];
    self.tipView.userInteractionEnabled = YES;
    [self addSubview:self.tipView];
    
    self.shutBtn = [self btnWithTarget:self action:@selector(shutAction)];
    _shutBtn.backgroundColor = LTClearColor;
    [_tipView addSubview:_shutBtn];
    
    self.cancleBtn = [self btnWithTarget:self action:@selector(cancleAction)];
    _cancleBtn.backgroundColor = LTClearColor;
    [_tipView addSubview:_cancleBtn];
    
    self.sureBtn = [self btnWithTarget:self action:@selector(sureAction)];
    _sureBtn.backgroundColor = LTClearColor;
    [_tipView addSubview:_sureBtn];
}

#pragma mark  - setting

- (void)configTipViewFrame:(CGRect)frame {
    self.tipView.frame = frame;
}

- (void)configTipImgName:(NSString *)imgName {
    self.tipView.image = [UIImage imageNamed:imgName];
}

- (void)configShutBtnFrame:(CGRect)frame {
    self.shutBtn.frame = frame;
}

- (void)configCancleBtnFrame:(CGRect)frame {
    self.cancleBtn.frame = frame;
}

- (void)configSureBtnFrame:(CGRect)frame {
    self.sureBtn.frame = frame;
}

- (void)tipViewAddSubview:(id)view {
    [self.tipView addSubview:view];
}


#pragma mark - action

- (void)shutView {
    if (self.removed) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        for (id obj in keyWindow.subviews) {
            if ([obj isKindOfClass:[LTMiddleTipView class]]) {
                LTMiddleTipView *mtv = (LTMiddleTipView *)obj;
                [mtv removeFromSuperview];
            }
        }
    } else {
        self.hidden = YES;
    }
}

- (void)shutAction {
    _shutBlock ? _shutBlock() : nil;
    [self shutView];
}

- (void)cancleAction {
    _cancleBlock ? _cancleBlock() : nil;
    [self shutView];
}

- (void)sureAction {
    _sureBlock ? _sureBlock() : nil;
    [self shutView];
}


#pragma mark - utils 


- (UIButton *)btnWithTarget:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - 外部
//邀请好友赚积分
+ (LTMiddleTipView *)getInviteFriendsView:(LTMiddleTipViewBlock)sureBlock {
    
    LTMiddleTipView *mtv = [[LTMiddleTipView alloc] initWithFrame:ScreenBounds_Lit];
    mtv.sureBlock = sureBlock;
    
    CGFloat tipVW = LTAutoW(250);
    CGFloat tipVH = LTAutoW(351);
    [mtv configTipViewFrame:CGRectMake((mtv.w_ - tipVW)*0.5, (mtv.h_ - tipVH)*0.5, tipVW, tipVH)];
    [mtv configTipImgName:@"InviteFriends"];
    
    CGFloat shutBtnW = LTAutoW(50);
    CGFloat shutBtnH = LTAutoW(50);
    [mtv configShutBtnFrame:CGRectMake((tipVW - shutBtnW), 0, shutBtnW, shutBtnH)];
    
    CGFloat sureBtnW = LTAutoW(150);
    CGFloat sureBtnH = LTAutoW(40);
    [mtv configSureBtnFrame:CGRectMake((tipVW - sureBtnW)*0.5, tipVH- LTAutoW(28) - sureBtnH, sureBtnW, sureBtnH)];
    
    
    return mtv;
}

//新用户注册
+ (void)showNewUserRedPacket:(LTMiddleTipViewBlock)lookRedPacket placeAnOrder:(LTMiddleTipViewBlock)placeAnOrder shutBlock:(LTMiddleTipViewBlock)shutBlock numRP:(NSInteger)numRP newUserNumRP:(NSInteger)newUserNumRP {
    
    LTMiddleTipView *mtv = [[LTMiddleTipView alloc] initWithFrame:ScreenBounds_Lit];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:mtv];
    [keyWindow bringSubviewToFront:mtv];
    
    
    CGFloat tipVW = LTAutoW(340);
    CGFloat tipVH = LTAutoW(450);
    [mtv configTipViewFrame:CGRectMake((mtv.w_ - tipVW)*0.5, (mtv.h_ - tipVH)*0.5, tipVW, tipVH)];
    [mtv configTipImgName:@"newUserRedPacket"];
    
    CGFloat shutBtnW = LTAutoW(50);
    CGFloat shutBtnH = LTAutoW(50);
    [mtv configShutBtnFrame:CGRectMake((tipVW - shutBtnW - LTAutoW(45)), LTAutoW(20), shutBtnW, shutBtnH)];
    
    
    CGFloat btmBtnW = LTAutoW(120);
    CGFloat btmBtnH = LTAutoW(40);
    CGFloat btmBtnY = tipVH - LTAutoW(24) - btmBtnH;
    CGRect cancleBtnRect = CGRectMake(LTAutoW(37), btmBtnY, btmBtnW, btmBtnH);
    [mtv configCancleBtnFrame:cancleBtnRect];
    mtv.cancleBlock = lookRedPacket;
    mtv.shutBlock = shutBlock;
    [mtv configSureBtnFrame:CGRectMake(cancleBtnRect.origin.x + cancleBtnRect.size.width + LTAutoW(16), btmBtnY, btmBtnW, btmBtnH)];
    mtv.sureBlock = placeAnOrder;
    
    
    UILabel *totalLab = [[UILabel alloc] init];
    totalLab.frame = CGRectMake(LTAutoW(50), LTAutoW(114), LTAutoW(80), LTAutoW(37));
    NSInteger total = (newUserNumRP+numRP)*8;
    totalLab.text = [NSString stringWithInteger:total];
    totalLab.textColor = LTColorHex(0xFFDD00);
    totalLab.font = autoBoldFontSiz(37);
    totalLab.textAlignment = NSTextAlignmentRight;
    [mtv tipViewAddSubview:totalLab];
    
    UILabel *numLab0 = [[UILabel alloc] init];
    numLab0.frame = CGRectMake(LTAutoW(73), LTAutoW(323), LTAutoW(58), LTAutoW(17));
    numLab0.text = [NSString stringWithFormat:@"%ldi张",(long)newUserNumRP];
    numLab0.textColor = LTWhiteColor;
    numLab0.font = autoBoldFontSiz(17);
    numLab0.textAlignment = NSTextAlignmentCenter;
    [mtv tipViewAddSubview:numLab0];
    
    
    UILabel *numLab = [[UILabel alloc] init];
    numLab.frame = CGRectMake(LTAutoW(200), LTAutoW(323), LTAutoW(58), LTAutoW(17));
    numLab.text = [NSString stringWithFormat:@"%ld张",(long)numRP];
    numLab.textColor = LTWhiteColor;
    numLab.font = autoBoldFontSiz(17);
    numLab.textAlignment = NSTextAlignmentCenter;
    [mtv tipViewAddSubview:numLab];
    
    
//    mtv.shutBtn.backgroundColor = LTYellowColor;
//    mtv.cancleBtn.backgroundColor = LTYellowColor;
//    mtv.sureBtn.backgroundColor = LTYellowColor;
    
}

@end
