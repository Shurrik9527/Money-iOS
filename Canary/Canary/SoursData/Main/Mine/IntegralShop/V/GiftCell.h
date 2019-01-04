//
//  GiftCell.h
//  ixit
//
//  Created by litong on 2016/12/20.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftMO.h"

#define kGiftCellH   LTAutoW(85)

/** 积分商城 - 商品cell */
@interface GiftCell : UITableViewCell

- (void)bindData:(GiftMO *)mo indexPath:(NSIndexPath *)indexPath;

@end
