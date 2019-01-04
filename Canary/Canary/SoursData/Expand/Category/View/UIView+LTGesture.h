//
//  UIView+LTGesture.h
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LTGesture)

#pragma mark - 手势 UIGestureRecognizer

//单击、双击、多次点击、长按
- (void)addSingeTap:(SEL)sel target:(id)target;
- (void)addDoubleTap:(SEL)sel target:(id)target;
- (void)addTap:(NSInteger)numTap action:(SEL)action target:(id)target;
- (void)addSingeTap:(SEL)action andDoubleTap:(SEL)doubleSel target:(id)target;
- (void)addLongPressAction:(SEL)action second:(NSTimeInterval)second target:(id)target;
//上、下、左、右滑
- (void)addUpSwipeAction:(SEL)action target:(id)target;
- (void)addDownSwipeAction:(SEL)action target:(id)target;
- (void)addLeftSwipeAction:(SEL)action target:(id)target;
- (void)addRightSwipeAction:(SEL)action target:(id)target;


@end
