//
//  UIApplication+LT.m
//  Canary
//
//  Created by litong on 2017/5/16.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "UIApplication+LT.h"

@implementation UIApplication (LT)


#pragma mark 跳转url
+ (void)openUrl:(NSString *)url {
    if (url) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }
}

@end
