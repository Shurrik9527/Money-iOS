//
//  CountDownView.h
//  ixit
//
//  Created by litong on 2016/11/11.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NFC_HomeTimeIsUp    @"NFC_HomeTimeIsUp"
#define CountDownViewW      93.f
#define CountDownViewH       34.f

/** 行情预演 -- 日历 倒计时 */
@interface CountDownView : UIImageView

@property (nonatomic,strong) NSIndexPath *iPath;
- (void)refTimeInterval:(NSTimeInterval)t;

@end
