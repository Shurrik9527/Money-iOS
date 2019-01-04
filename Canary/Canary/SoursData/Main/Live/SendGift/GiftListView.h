//
//  GiftListView.h
//  ixit
//
//  Created by litong on 2017/3/29.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveGiftListMO.h"

typedef void(^SendGiftBlock)(NSInteger idx);

/** 礼物列表view */
@interface GiftListView : UIView

@property (nonatomic,copy) SendGiftBlock sendGiftBlock;

- (void)configData:(LiveGiftListMO *)mo name:(NSString *)name;
- (void)showView:(BOOL)show;
- (void)refValidPoints:(NSString *)validPoints;

@end
