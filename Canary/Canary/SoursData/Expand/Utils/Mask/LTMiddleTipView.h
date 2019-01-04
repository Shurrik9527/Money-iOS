//
//  LTMiddleTipView.h
//  ixit
//
//  Created by litong on 2017/1/16.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LTMiddleTipViewBlock)();

@interface LTMiddleTipView : UIView

//邀请好友赚积分
+ (LTMiddleTipView *)getInviteFriendsView:(LTMiddleTipViewBlock)sureBlock;

//新用户注册
+ (void)showNewUserRedPacket:(LTMiddleTipViewBlock)lookRedPacket placeAnOrder:(LTMiddleTipViewBlock)placeAnOrder shutBlock:(LTMiddleTipViewBlock)shutBlock numRP:(NSInteger)numRP newUserNumRP:(NSInteger)newUserNumRP;

@end
