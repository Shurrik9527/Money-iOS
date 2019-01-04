//
//  UIImageView+LT.h
//  Canary
//
//  Created by litong on 2017/5/16.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (LT)

/** UIImageView 帧动画
 animationDuration：动画总时长
 imgNamePrefix：图片名称前缀
 imgCount：图片数量
 begin：图片命名从数字几开始
 repeatCount：重复次数
 */
- (void)animationTime:(NSTimeInterval)time repeatCount:(NSInteger)repeatCount imgNamePrefix:(NSString *)imgNamePrefix imgCount:(NSInteger)imgCount begin:(NSInteger)begin;


@end
