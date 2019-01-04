//
//  GiftCountDownView.h
//  ixit
//
//  Created by litong on 2017/4/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NFC_GiftTimeIsUp    @"NFC_GiftTimeIsUp"

#define kGiftCountDownH   LTAutoW(32)
#define kGiftCountDownLabW  LTAutoW(28)
#define kGiftCountDownMar   LTAutoW(4)


/** 活动 -- 倒计时 */
@interface GiftCountDownView : UIImageView

@property (nonatomic,assign) NSInteger section;
- (void)refTimeInterval:(NSTimeInterval)t;

@end

