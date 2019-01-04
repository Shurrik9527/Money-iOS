//
//  UIView+LTFrame.m
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "UIView+LTFrame.h"

@implementation UIView (LTFrame)



- (CGFloat)x_ {
    return self.frame.origin.x;
}

- (CGFloat)y_ {
    return self.frame.origin.y;
}

- (CGFloat)w_ {
    return self.frame.size.width;
}

- (CGFloat)h_ {
    return self.frame.size.height;
}

- (CGFloat)xw_ {
    return self.x_ + self.w_;
}

- (CGFloat)yh_ {
    return self.y_ + self.h_;
}

#pragma mark - 设置Frame、Center

- (void)setOrigin:(CGPoint)origin {
    CGRect rect = self.frame;
    rect.origin = origin;
    self.frame = rect;
}
- (void)setSize:(CGSize)size {
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}

- (void)setOX:(CGFloat)x {
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}
- (void)setOY:(CGFloat)y {
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}
- (void)setSW:(CGFloat)w {
    CGRect rect = self.frame;
    rect.size.width = w;
    self.frame = rect;
}
- (void)setSH:(CGFloat)h {
    CGRect rect = self.frame;
    rect.size.height = h;
    self.frame = rect;
}

- (void)setCenterX:(CGFloat)x {
    CGPoint p = self.center;
    p.x = x;
    self.center = p;
}
- (void)setCenterY:(CGFloat)y {
    CGPoint p = self.center;
    p.y = y;
    self.center = p;
}

- (void)centerXSameToView:(UIView *)view {
    self.center = CGPointMake(view.center.x, self.center.y);
}
- (void)centerYSameToView:(UIView *)view {
    self.center = CGPointMake(self.center.x, view.center.y);
}

#pragma mark - 获取当前View的ViewController

- (UIViewController *)findViewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - removeAllSubView

- (void)removeAllSubView {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (void)removeAllSubViewWithClass:(Class)clas {
    for (id view in self.subviews) {
        if ([view isKindOfClass:clas]) {
            [view removeFromSuperview];
        }
    }
}

#pragma mark - 坐标转换

- (CGPoint)centerConvertToView:(UIView *)aView {
    CGPoint point = [aView convertPoint:self.center fromView:self.superview];
    //    CGPoint point = [self.superview convertPoint:self.center toView:aView];//等价于上面的方法
    return point;
}

- (CGRect)rectConvertToView:(UIView *)aView {
    CGRect rect = [aView convertRect:self.frame fromView:self.superview];
    //    CGRect rect = [self.superview convertRect:self.frame toView:aView];
    return rect;
}

@end
