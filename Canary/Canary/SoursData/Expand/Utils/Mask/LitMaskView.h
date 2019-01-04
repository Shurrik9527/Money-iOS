//
//  LitMaskView.h
//  ixit
//
//  Created by litong on 16/10/5.
//  Copyright © 2016年 ixit. All rights reserved.
//

#import <UIKit/UIKit.h>


/*
    通用蒙版view
 
    图片名称格式:
    imgName_4
    imgName_5
    imgName_6
    imgName_6p
 
*/

#define kMask_onceInto_JG   @"mask_jn"        //首次进入交易
#define kMask_onceInto_JGHoldList   @"mask_jnHoldList"   //首次进入吉农持仓
#define kMask_onceInto_LivePlay   @"mask_LivePlay"   //首次进入吉农持仓

#define kMask_onceInto_chooseExchange_Deal   @"deal_chooseExchange_guid"        //切换交易所蒙版


typedef void(^MaskClickBtn)();

@interface LitMaskView : UIView

+ (void)removeAllMaskView;

/** 首次进入交易显示吉农蒙版 */
+ (void)onceIntoJG:(MaskClickBtn)block;

/** 首次进入交易显示吉农持仓蒙版 */
+ (void)onceIntoJGHoldList;

/** 首次进入视频直播蒙版 */
+ (void)onceIntoLivePlay;
/** 切换交易所蒙版*/
+ (void)onceIntoChooseExchange;
/** 通用全屏蒙版 key为imageName*/
+(void)commonOneceMaskWithKey:(NSString *)key;

@end
