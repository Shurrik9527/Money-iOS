//
//  PollADView.h
//  ixit
//******************************************************************
//     自动滚屏实现：比如 现在有  a、b、c 3张图
//         实际： c、(a、b、c)、a
//         第一张a图前面插入c，最后一张c图后面插入a
//     缺点：快速滑动到最后一张a，无法再滑动
//
//******************************************************************
//  Created by litong on 2016/11/8.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PollADModel.h"
#import "TaskListMo.h"

typedef void(^ClickPollADView)(id mo);

/** 首页滚图 */
@interface PollADView : UIView

@property (nonatomic,copy) ClickPollADView clickPollADView;

- (void)refDatas:(NSArray *)datas;
- (void)start;
- (void)stop;

+ (CGFloat)viewH;

@end
