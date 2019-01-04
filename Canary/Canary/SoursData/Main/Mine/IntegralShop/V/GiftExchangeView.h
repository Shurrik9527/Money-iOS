//
//  GiftExchangeView.h
//  ixit
//
//  Created by litong on 2016/12/21.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftMO.h"
#import "IntegralMo.h"

#define GiftExchangeViewH   228

//typedef void(^GiftExchangeBlock)(NSString *gid,NSInteger num,ExchangeType exType);
typedef void(^GiftExchangeBlock)(GiftMO *mo,NSInteger num);
typedef void(^GiftExShowTipBlock)(NSString *tip);

/** 兑换优惠券 */
@interface GiftExchangeView : UIView

@property (nonatomic,strong) GiftMO *mo;
@property (nonatomic,strong) IntegralMo *integralMo;
@property (nonatomic,copy) GiftExchangeBlock giftExchangeBlock;
@property (nonatomic,copy) GiftExShowTipBlock giftExShowTipBlock;

- (void)showView:(BOOL)show;

@end
