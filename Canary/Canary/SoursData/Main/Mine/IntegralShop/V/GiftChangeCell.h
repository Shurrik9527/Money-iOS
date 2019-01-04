//
//  GiftChangeCell.h
//  ixit
//
//  Created by litong on 2016/12/20.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftChangeMO.h"


#define kGiftChangeCellH   LTAutoW(85)

/** 兑换历史cell */
@interface GiftChangeCell : UITableViewCell

- (void)bindData:(GiftChangeMO *)mo;

@end
