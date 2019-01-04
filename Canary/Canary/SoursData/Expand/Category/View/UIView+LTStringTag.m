//
//  UIView+LTStringTag.m
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "UIView+LTStringTag.h"
#import <objc/runtime.h>

static char kLTViewStringTag;

@implementation UIView (LTStringTag)

- (void)setStringTag:(NSString *)stringTag{
    objc_setAssociatedObject(self, &kLTViewStringTag, stringTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)stringTag{
    
    return objc_getAssociatedObject(self, &kLTViewStringTag);
}

- (UIView *)viewWithStringTag:(NSString *)tag{
    
    UIView *targetView = nil;
    for (UIView *view in self.subviews) {
        
        if ([view.stringTag isEqualToString:tag]) {
            targetView = view;
            break;
        }else{
            targetView = [view viewWithStringTag:tag];
            if (targetView) {
                break;
            }
        }
    }
    
    return targetView;
}

- (UIView *)findFirstResponder {
    UIView *firstResponder = nil;
    if (self.isFirstResponder) {
        firstResponder = self;
    } else {
        
        for (UIView *view in self.subviews) {
                if (view.isFirstResponder) {
                        firstResponder = view;
                        break;
                } else {
                        firstResponder = [view findFirstResponder];
                        if (firstResponder) {
                            break;
                        }
                }
        }
        
    }
    return firstResponder;
}

@end
