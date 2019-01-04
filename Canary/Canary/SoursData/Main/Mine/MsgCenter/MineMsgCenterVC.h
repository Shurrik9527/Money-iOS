//
//  MineMsgCenterVC.h
//  ixit
//
//  Created by litong on 2017/3/10.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BaseTableVCtrl.h"

typedef void(^AllMessageReadedBlock)();

/** 消息中心 新 */
@interface MineMsgCenterVC : BaseTableVCtrl

@property (nonatomic,copy) AllMessageReadedBlock allMessageReadedBlock;

@end
