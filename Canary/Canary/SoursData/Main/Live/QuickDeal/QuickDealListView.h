//
//  QuickDealListView.h
//  ixit
//
//  Created by litong on 2017/3/13.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kQuickDealViewW 69
#define kQuickDealViewH 113
typedef void(^QuickDealBlock)(NSInteger row);

/** 快速交易 */
@interface QuickDealListView : UIView

@property (nonatomic,copy) QuickDealBlock quickDealBlock;

- (void)configSellNum:(NSInteger)num;

@end
