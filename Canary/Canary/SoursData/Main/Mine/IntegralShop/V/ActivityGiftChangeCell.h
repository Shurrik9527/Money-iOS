//
//  ActivityGiftChangeCell.h
//  ixit
//
//  Created by litong on 2017/4/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftChangeMO.h"


#define kActivityGiftChangeCellH   LTAutoW(85)

/** 兑换历史cell */
@interface ActivityGiftChangeCell : UITableViewCell

- (void)bindData:(GiftChangeMO *)mo;

@end
