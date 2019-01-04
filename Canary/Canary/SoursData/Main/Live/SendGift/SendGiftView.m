//
//  SendGiftView.m
//  LTDevDemo
//
//  Created by litong on 2017/3/28.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "SendGiftView.h"
#import "UIImageView+WebCache.h"

#define kNameLabFZ  12
#define kSKLabFZ  18
#define tmpMar  4

@interface SendGiftView ()
{
    CGFloat senderLabMaxW;
}
@property (nonatomic,strong) UIImageView *bgIV;//背景
@property (nonatomic,strong) UILabel *sendrLvLab; // 送礼物者等级
@property (nonatomic,strong) UILabel *sendrLab; // 送礼物者
@property (nonatomic,strong) UILabel *songLab; // 送 字
@property (nonatomic,strong) UIImageView *giftIV; // 礼物
@property (nonatomic,strong) SGShakeLable *skLab;//礼物数量


@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,copy) void(^completeBlock)(BOOL finished,NSInteger finishCount); // 新增了回调参数 finishCount， 用来记录动画结束时累加数量，将来在3秒内，还能继续累加

@end

@implementation SendGiftView


- (instancetype)init {
    if (self = [super init]) {
        _originFrame = self.frame;
        _giftCount = 0;
        senderLabMaxW = kNameLabFZ*5;
        [self createView];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"SendGiftView dealloc");
}

#pragma mark - utils

- (void)setSendGiftMo:(SendGiftMo *)sendGiftMo {
    _sendGiftMo = sendGiftMo;
    
    
    if (sendGiftMo.senderLv > 0) {
        _sendrLvLab.text = sendGiftMo.senderLv_fmt;
        _sendrLvLab.backgroundColor = sendGiftMo.sendLvColor;
        _sendrLvLab.hidden = NO;
    } else {
        _sendrLvLab.hidden = YES;
    }
    
    NSString *senderName = sendGiftMo.senderName;
    _sendrLab.text = senderName;
    
    [_giftIV sd_setImageWithURL:[[sendGiftMo giftImgUrl] toURL] placeholderImage:nil options:SDWebImageProgressiveDownload];
    _giftCount = sendGiftMo.giftCount;
    
    CGSize size = [_sendrLab sizeThatFits:CGSizeMake(senderLabMaxW, _sendrLab.h_)];
    CGFloat labw = size.width;
    if (labw > senderLabMaxW) {
        labw = senderLabMaxW;
    }
    [_sendrLab setSW:labw];
    [_songLab setOX:(_sendrLab.xw_ + tmpMar)];
    [_giftIV setOX:(_songLab.xw_)];
    [_skLab setOX:(_giftIV.xw_)];
    [_bgIV setSW:(_skLab.xw_ + 18)];
}


// 根据礼物个数播放动画
- (void)animateWithCompleteBlock:(CompleteBlock)completed{
    WS(ws);
    [UIView animateWithDuration:0.3 animations:^{
        ws.frame = CGRectMake(0, ws.frame.origin.y, ws.frame.size.width, ws.frame.size.height);
    } completion:^(BOOL finished) {
        [ws shakeNumberLabel];
    }];
    self.completeBlock = completed;
}

- (void)shakeNumberLabel{
    _animCount ++;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidePresendView) object:nil];//可以取消成功。
    [self performSelector:@selector(hidePresendView) withObject:nil afterDelay:2];
    
    self.skLab.text = [NSString stringWithFormat:@"x%ld",_animCount];
    [self.skLab startAnimWithDuration:0.3];
}

- (void)hidePresendView {
    WS(ws);
    [UIView animateWithDuration:0.30 delay:2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [ws changeFrame];
    } completion:^(BOOL finished) {
        [ws complete:finished];
    }];
}

- (void)changeFrame {
    self.frame = CGRectMake(0, self.frame.origin.y - 20, self.frame.size.width, self.frame.size.height);
    self.alpha = 0;
}

- (void)complete:(BOOL)finished {
    if (self.completeBlock) {
        self.completeBlock(finished,self.animCount);
    }
    [self reset];
    self.finished = finished;
    [self removeFromSuperview];
}



// 重置
- (void)reset {
    self.frame = _originFrame;
    self.alpha = 1;
    self.animCount = 0;
    self.skLab.text = @"";
}


#pragma mark - UI

- (void)createView {
    //背景
    _bgIV = [[UIImageView alloc] init];
    _bgIV.image = [[UIImage imageNamed:@"giftBg"] stretchMiddle];
    [self addSubview:_bgIV];
    // 送礼物者等级
    _sendrLvLab = [[UILabel alloc] init];
    _sendrLvLab.textColor = LTWhiteColor;
    _sendrLvLab.font = [UIFont fontOfSize:10];
    _sendrLvLab.backgroundColor = LTColorHex(0xB4B9CB);
    _sendrLvLab.layer.cornerRadius = 1;
    _sendrLvLab.layer.masksToBounds = YES;
    _sendrLvLab.textAlignment = NSTextAlignmentCenter;
    [_bgIV addSubview:_sendrLvLab];
    // 送礼物者
    _sendrLab = [self nameLab];
    _sendrLab.numberOfLines = 0;
    [_bgIV addSubview:_sendrLab];
    // 送 字
    _songLab = [self nameLab];
    _songLab.text = @"送";
    [_bgIV addSubview:_songLab];
    // 礼物
    _giftIV = [[UIImageView alloc] init];
    [self addSubview:_giftIV];
    // 礼物数量 动画label
    
    _skLab =  [[SGShakeLable alloc] init];
    _skLab.borderColor =  SGShakeLableBorderColor;
    _skLab.textColor = SGShakeLableTextColor;
    _skLab.textAlignment = NSTextAlignmentCenter;
    _skLab.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:kSKLabFZ];;
    [_bgIV addSubview:_skLab];
    _animCount = 0;
    
    CGFloat bgh = 34;
    CGFloat labh = 12;
    CGFloat laby = (bgh - labh)*0.5;
    CGFloat giftwh = 70;
    
    _sendrLvLab.frame = CGRectMake(16, laby, 18, labh);
    _sendrLab.frame = CGRectMake(_sendrLvLab.xw_+tmpMar, laby, senderLabMaxW, labh);
    _songLab.frame = CGRectMake(_sendrLab.xw_+tmpMar, laby, 14, labh);
    _giftIV.frame = CGRectMake(_songLab.xw_, 0, giftwh, giftwh);
    _skLab.frame = CGRectMake(_giftIV.xw_-10, (bgh - kSKLabFZ)*0.5, 50, kSKLabFZ);
    _bgIV.frame = CGRectMake(0, 24.5, _skLab.xw_, bgh);

}

- (UILabel *)nameLab {
    UILabel *lab = [[UILabel alloc] init];
    lab.textColor = LTColorHex(0xF5A623);
    lab.font = [UIFont fontOfSize:kNameLabFZ];
    return lab;
}


@end
