//
//  ActivityGiftCell.h
//  ixit
//
//  Created by litong on 2017/3/31.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftMO.h"

#define kActivityGiftCellH      LTAutoW(80)

@interface ActivityGiftCell : UITableViewCell

- (void)bindData:(GiftMO *)mo indexPath:(NSIndexPath *)indexPath;

@end
