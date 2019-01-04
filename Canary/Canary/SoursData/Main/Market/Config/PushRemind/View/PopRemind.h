//
//  PopRemind.h
//  ixit
//
//  Created by litong on 2017/2/17.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PushRemindModel.h"
/** 全局弹框提醒 */
@interface PopRemind : UIView
@property(assign,nonatomic)BOOL isShow;
@property (nonatomic, copy) void (^clickCell)(ActionType type,PushRemindModel *model);
//-(void)configViewWithModel:(PushRemindModel *)model;
-(void)configViewWithModelList:(NSMutableArray *)list;

-(void)hide;


- (void)animateShake;
@end
