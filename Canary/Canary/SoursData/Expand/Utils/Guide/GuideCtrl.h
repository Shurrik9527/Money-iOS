//
//  GuideCtrl.h
//  Canary
//
//  Created by litong on 2017/5/5.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kStr_GuideShowed    @"GuideShowed"

typedef void(^GuideShutBlock)();
typedef void(^GuideRegisterBlock)();

@interface GuideCtrl : UIViewController

+ (GuideCtrl *)showGuideShutBlock:(GuideShutBlock)shutBlock registerBlock:(GuideRegisterBlock)registerBlock;

+ (BOOL)showed;
+ (void)setShowed:(BOOL)show;

@end
