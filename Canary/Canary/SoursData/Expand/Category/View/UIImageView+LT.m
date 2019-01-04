//
//  UIImageView+LT.m
//  Canary
//
//  Created by litong on 2017/5/16.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "UIImageView+LT.h"

@implementation UIImageView (LT)


/** UIImageView 帧动画
 animationDuration：动画总时长
 imgNamePrefix：图片名称前缀
 imgCount：图片数量
 begin：图片命名从数字几开始
 repeatCount：重复次数
 */
- (void)animationTime:(NSTimeInterval)time repeatCount:(NSInteger)repeatCount imgNamePrefix:(NSString *)imgNamePrefix imgCount:(NSInteger)imgCount begin:(NSInteger)begin {
    NSMutableArray *imgs = [NSMutableArray array];
    for (NSInteger i = 0; i < imgCount; i++) {
        NSString *imgName = [NSString stringWithFormat:@"%@%li",imgNamePrefix ,(i+1)];
        UIImage *img = [UIImage imageNamed:imgName];
        [imgs addObject:img];
    }
    self.animationImages = imgs;
    self.animationDuration = time;
    self.animationRepeatCount = repeatCount;
}

@end
