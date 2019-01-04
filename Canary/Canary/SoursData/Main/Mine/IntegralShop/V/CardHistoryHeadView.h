//
//  CardHistoryHeadView.h
//  ixit
//
//  Created by Brain on 2017/4/6.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntegralMo.h"
#import "GiftMO.h"
#import "CardDetailsMo.h"
#define CardW LTAutoW(353) /* <卡片宽度 */
#define CardH LTAutoW(215.5) /*  卡片高度*/
#define ContainerH LTAutoW(288) /*view的高度*/

@interface CardHistoryHeadView : UIView
@property(copy,nonatomic)NSString * name;//特权卡名称
@property(copy,nonatomic)NSString * timeStr;//特权卡名称

@property(assign,nonatomic)NSTimeInterval time;//特权卡结束时间戳
@property(copy,nonatomic)NSString * cardBGUrl;//特权卡图片背景url
@property(strong,nonatomic)UIColor *vipColor;//特权卡vip等级对应颜色
@property(copy,nonatomic)NSString * integral;//特权卡积分

@property (nonatomic,strong) CardDetailsMo * detailsMo;//历史特权卡model

- (instancetype)initWithMo:(GiftMO *)giftmo integralMo:(IntegralMo *) integralMo;

@end
