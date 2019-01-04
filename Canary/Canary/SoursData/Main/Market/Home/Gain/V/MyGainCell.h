//
//  MyGainCell.h
//  ixit
//
//  Created by litong on 2016/11/14.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyGainModel.h"

#define MyGainCellH  73.f

/** 我的盈利单，我的交易记录 */
@interface MyGainCell : UITableViewCell

- (void)bindData:(MyGainModel *)mo;

@end
