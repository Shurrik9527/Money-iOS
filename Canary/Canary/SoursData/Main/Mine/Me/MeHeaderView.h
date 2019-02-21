//
//  MeHeaderView.h
//  ixit
//
//  Created by litong on 2017/2/14.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntegralMo.h"

#define kMeHeaderViewH     158     //登录成功
#define kMeHeaderViewH1    200   //未登录

#define NFC_PushLoginVC     @"NFC_PushLoginVC"
#define NFC_PushAccountManager     @"NFC_PushAccountManager"
#define NFC_PushIntegralVC     @"NFC_PushIntegralVC"
#define NFC_PushAuthVC     @"NFC_PushAuthVC"

@interface MeHeaderView : UIView

- (void)refViewWithLogin;//登录或退出时调用
- (void)animationBegin;

- (void)updateNickName;
- (void)updateHeadImg;

@end
