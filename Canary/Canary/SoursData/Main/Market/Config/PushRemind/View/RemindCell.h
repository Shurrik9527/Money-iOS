//
//  RemindCell.h
//  ixit
//
//  Created by litong on 2017/2/17.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PushRemindModel.h"

#define kRemindCellH 72

@interface RemindCell : UITableViewCell

- (void)bindData:(PushRemindModel *)mo;

@end
