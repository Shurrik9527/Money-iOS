//
//  ShopHeadView.h
//  ixit
//
//  Created by litong on 2016/12/19.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntegralMo.h"
#import "InviteFriendsInfo.h"

#define ShopBannerViewH 130
#define MyIntegralViewH  228
#define IntegralExchangeBarH  44
#define ShopHeadViewH   (MyIntegralViewH+IntegralExchangeBarH)

#define MyIntegralViewH1  220
#define ShopHeadViewH1   (ShopBannerViewH+MyIntegralViewH1+IntegralExchangeBarH)

typedef void(^MyExchangeHistoryBlock)();
typedef void(^LookIntegralDetailsBlock)();
typedef void(^LookBannerDetailsBlock)(InviteFriendsInfo *mo);


/** 积分商城 header */
@interface ShopHeadView : UIView

@property (nonatomic,copy) MyExchangeHistoryBlock myExchangeHistoryBlock;
@property (nonatomic,copy) LookIntegralDetailsBlock lookIntegralDetailsBlock;
@property (nonatomic,copy) LookBannerDetailsBlock lookBannerDetailsBlock;

- (void)refView:(IntegralMo *)mo;
- (void)addBanner:(InviteFriendsInfo *)inviteFriendsInfo;

@end
