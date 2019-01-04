//
//  GainBtmView.h
//  ixit
//
//  Created by litong on 2016/11/14.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowGainModel.h"

#define GainBtmViewAllH 68.f

#define GainBtmViewH 56.f
#define GainBtmTempH 12.f

typedef NS_ENUM(NSUInteger, GainBtmViewType) {
    GainBtmViewType_logout,//本人未登录
    GainBtmViewType_meOutTop,//本人未上榜
    GainBtmViewType_meInTop,//本人已上榜
};

typedef void(^LoginBlock)();
typedef void(^ShowGainBlock)();

/** 盈利列表 底部view */
@interface GainBtmView : UIView

@property (nonatomic,copy) LoginBlock loginBlock;
@property (nonatomic,copy) ShowGainBlock showGainBlock;

@property (nonatomic,assign) GainBtmViewType typ;

- (void)refData:(ShowGainModel *)mo;

@end
