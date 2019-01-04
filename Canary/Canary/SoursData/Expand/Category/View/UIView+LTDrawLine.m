//
//  UIView+LTDrawLine.m
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "UIView+LTDrawLine.h"
#import "UIView+LTFrame.h"

@implementation UIView (LTDrawLine)

typedef NS_ENUM(NSUInteger, LineViewDirection) {
    LineView_Top,
    LineView_Bottom,
    LineView_Left,
    LineView_Right,
};


+ (UIView *)lineFrame:(CGRect)frame color:(UIColor *)color {
    UIView *lView = [[UIView alloc] init] ;
    lView.frame = frame;
    lView.backgroundColor = color;
    return lView;
}

- (void)addLine:(UIColor *)color frame:(CGRect)frame {
    UIView *lineView = [[UIView alloc] init] ;
    lineView.frame = frame;
    lineView.backgroundColor = color;
    [self addSubview:lineView];
}

- (void)addLine:(UIColor *)color w_h:(CGFloat)w_h orientation:(LineViewDirection)orientation {
    
    CGRect rect = CGRectMake(0, 0, self.w_, w_h);
    
    if (orientation == LineView_Top) {
        rect = CGRectMake(0, 0, self.w_, w_h);
    } else if (orientation == LineView_Left) {
        rect = CGRectMake(0, 0, w_h, self.h_);
    }else if (orientation == LineView_Right) {
        rect = CGRectMake(self.w_ - w_h, 0, w_h, self.h_);
    } else {//LineView_Bottom
        rect = CGRectMake(0, self.h_ - w_h, self.w_, w_h);
    }
    
    UIView *lineView = [[UIView alloc] init] ;
    lineView.frame = rect;
    lineView.backgroundColor = color;
    [self addSubview:lineView];
}

- (void)addLineTop:(UIColor *)color h:(CGFloat)h {
    [self addLine:color w_h:h orientation:LineView_Top];
}
- (void)addLineBottom:(UIColor *)color h:(CGFloat)h {
    [self addLine:color w_h:h orientation:LineView_Bottom];
}
- (void)addLineLeft:(UIColor *)color w:(CGFloat)w {
    [self addLine:color w_h:w orientation:LineView_Left];
}
- (void)addLineRight:(UIColor *)color w:(CGFloat)w {
    [self addLine:color w_h:w orientation:LineView_Right];
}

static CGFloat Line_WOrH = 0.5;
- (void)addLineTop:(UIColor *)color {
    [self addLineTop:color h:Line_WOrH];
}
- (void)addLineBottom:(UIColor *)color {
    [self addLineBottom:color h:Line_WOrH];
}
- (void)addLineLeft:(UIColor *)color {
    [self addLineLeft:color w:Line_WOrH];
}
- (void)addLineRight:(UIColor *)color {
    [self addLineRight:color w:Line_WOrH];
}

@end
