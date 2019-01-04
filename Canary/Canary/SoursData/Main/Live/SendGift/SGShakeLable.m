//
//  SGShakeLable.m
//  LTDevDemo
//
//  Created by litong on 2017/3/28.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "SGShakeLable.h"

@implementation SGShakeLable


- (void)startAnimWithDuration:(NSTimeInterval)duration {
    WS(ws);
    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1/2.0 animations:^{
            ws.transform = CGAffineTransformMakeScale(3, 3);
        }];
        [UIView addKeyframeWithRelativeStartTime:1/2.0 relativeDuration:1/2.0 animations:^{
            ws.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            ws.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:nil];
    }];
}

//  重写 drawTextInRect 文字阴影效果
- (void)drawTextInRect:(CGRect)rect {
    self.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowRadius = 0.5;//阴影半径，默认3
    self.shadowColor = _borderColor;
    [super drawTextInRect:rect];
}

@end
