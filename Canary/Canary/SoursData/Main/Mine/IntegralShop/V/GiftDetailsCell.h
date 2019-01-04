//
//  GiftDetailsCell.h
//  ixit
//
//  Created by litong on 2016/12/20.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftDetailsMO.h"

#define GiftDetailsCellH   68

/** 积分明细 */
@interface GiftDetailsCell : UITableViewCell

- (void)bindData:(GiftDetailsMO *)mo;

@end
