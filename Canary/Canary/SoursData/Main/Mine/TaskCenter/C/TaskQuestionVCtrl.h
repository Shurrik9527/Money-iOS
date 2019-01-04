//
//  TaskQuestionVCtrl.h
//  ixit
//
//  Created by litong on 2017/3/1.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BaseVCtrl.h"
#import "TaskListMo.h"
#import "TaskQuestionMo.h"
#import "LitTipsView.h"

typedef void(^ReloadTaskList)();

/** 新手答题 */
@interface TaskQuestionVCtrl : BaseVCtrl

@property (nonatomic,strong) TaskListMo*taskMo;
@property (nonatomic,copy) ReloadTaskList reloadTaskList;

@end
