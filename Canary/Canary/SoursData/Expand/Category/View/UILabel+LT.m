//
//  UILabel+LT.m
//  Canary
//
//  Created by litong on 2017/5/16.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "UILabel+LT.h"

@implementation UILabel (LT)

- (CGFloat)fitWidth {
    CGSize size = [self sizeThatFits:CGSizeMake(MAXFLOAT, self.h_)];
    return size.width;
}

- (CGFloat)fitHeight {
    CGSize size = [self sizeThatFits:CGSizeMake(self.w_, MAXFLOAT)];
    return size.height;
}

@end
