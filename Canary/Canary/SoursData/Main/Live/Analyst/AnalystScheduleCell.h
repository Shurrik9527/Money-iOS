//
//  AnalystScheduleCell.h
//  ixit
//
//  Created by litong on 2017/3/29.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveTimeMo.h"

#define kAnalystScheduleCellH     39

/** 分析师时间表Cell */
@interface AnalystScheduleCell : UITableViewCell

- (void)bindData:(LiveTimeMo *)mo row:(BOOL)row;

@end
