//
//  CardFooterView.h
//  ixit
//
//  Created by Brain on 2017/4/6.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftMO.h"
#import "IntegralMo.h"

@interface CardFooterView : UIView
@property(assign,nonatomic)NSInteger buyStatus;/**< 购买状态：0=未购买 1=已购买 2=已抢光*/
@property(assign,nonatomic)NSInteger validPoints;/*< 可用积分*/

@property (nonatomic, copy) void (^reqGiftChangeBlock)();

- (void)refreshWithMo:(GiftMO *)giftmo integralMo:(IntegralMo *) integralMo;
@end
