//
//  GainCell.h
//  ixit
//
//  Created by litong on 2016/11/14.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GainModel.h"

#define GainCellH       50.f

/** 盈利列表 3名以后Cell */
@interface GainCell : UITableViewCell

//idx 灰色区域数字
- (void)bindData:(GainModel *)mo idx:(NSInteger)idx;

@end
