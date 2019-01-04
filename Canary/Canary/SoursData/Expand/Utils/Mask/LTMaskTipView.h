//
//  LTMaskTipView.h
//  ixit
//
//  Created by litong on 2016/12/27.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>


static NSString *showIntegralOnlineKey = @"showIntegralOnlineKey";
static NSString *showTaskTipKey = @"showTaskTipKey";

typedef void(^LTMaskTipBlock)();

/** 等级提升、固定大小的淡出框 */
@interface LTMaskTipView : UIView

//积分上线
+ (void)showIntegralOnline:(LTMaskTipBlock)sureBlock cancleBlock:(LTMaskTipBlock)cancle;
//等级提升
+ (void)showVipLvUp:(LTMaskTipBlock)sureBlock cancleBlock:(LTMaskTipBlock)cancle;
//任务中心
+ (void)showTaskTip:(LTMaskTipBlock)sureBlock cancleBlock:(LTMaskTipBlock)cancle;
//任务完成获得积分提示
+ (void)showTaskFinishTip:(LTMaskTipBlock)sureBlock cancleBlock:(LTMaskTipBlock)cancle point:(NSString *)point;

@end
