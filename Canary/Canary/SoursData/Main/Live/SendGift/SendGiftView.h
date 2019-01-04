//
//  SendGiftView.h
//  LTDevDemo
//
//  Created by litong on 2017/3/28.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendGiftMo.h"
#import "SGShakeLable.h"

#define SendGiftViewH  (147*0.5)

typedef void(^CompleteBlock)(BOOL finished,NSInteger finishCount);

@interface SendGiftView : UIView

@property (nonatomic,strong) SendGiftMo *sendGiftMo;
@property (nonatomic,assign) NSInteger giftCount; // 礼物个数
@property (nonatomic,assign) NSInteger animCount; // 动画执行到了第几次
@property (nonatomic,assign) CGRect originFrame; // 记录原始坐标
@property (nonatomic,assign,getter=isFinished) BOOL finished;

- (void)animateWithCompleteBlock:(CompleteBlock)completed;
- (void)shakeNumberLabel;
- (void)hidePresendView;

@end
