//
//  PrivilegedCardInfoVCtrl.h
//  ixit
//
//  Created by litong on 2017/4/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BaseVCtrl.h"
#import "GiftMO.h"
#import "IntegralMo.h"
#import "GiftChangeMO.h"

typedef void(^GiftListRefBlock)();

/** 特权卡介绍 */
@interface PrivilegedCardInfoVCtrl : BaseVCtrl

@property (nonatomic,copy) GiftListRefBlock giftListRefBlock;

@property (nonatomic,assign) BOOL fromHistory;//是否从历史记录跳转
@property (nonatomic,strong) GiftMO *mo;
@property (nonatomic,strong) IntegralMo *Integralmo;
@property (nonatomic,strong) GiftChangeMO *giftChangeMO;
@property(copy,nonatomic)NSString * endTime;//活动结束时间

@end
