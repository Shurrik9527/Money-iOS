//
//  GoodsExchangeCell.h
//  ixit
//
//  Created by litong on 2017/4/11.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftChangeMO.h"

#define kGoodsChangeCellH   LTAutoW(107)

/** 实物兑换历史 */
@interface GoodsExchangeCell : UITableViewCell

- (void)bindData:(GiftChangeMO *)mo;

@end
