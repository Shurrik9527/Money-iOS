//
//  GiftSingleView.h
//  ixit
//
//  Created by litong on 2017/3/29.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveGiftMO.h"

#define kGiftSingleViewH    LTAutoW(115)
#define kGiftSingleViewW    (ScreenW_Lit/3.0)

typedef void(^SelectIdxBlock)(NSInteger idx);

/** 单个礼物样式 */
@interface GiftSingleView : UIView

@property (nonatomic,copy) SelectIdxBlock selectIdxBlock;

- (void)configData:(LiveGiftMO *)mo idx:(NSInteger)idx;
- (void)selectedView:(BOOL)selected;

@end
