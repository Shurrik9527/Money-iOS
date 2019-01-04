//
//  TaskListCell.h
//  ixit
//
//  Created by litong on 2017/3/1.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskListMo.h"

typedef void(^TaskListCellBtnAction)(NSInteger row);

/** 任务列表cell */
@interface TaskListCell : UITableViewCell

/**  */
@property (nonatomic,copy) TaskListCellBtnAction taskListCellBtnAction;
- (void)bindData:(TaskListMo *)mo row:(NSInteger)row;
+ (CGFloat)cellH:(TaskListMo *)mo;

@end
