//
//  UIFont+LT.m
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "UIFont+LT.h"

@implementation UIFont (LT)


+ (UIFont *)autoFontSize:(CGFloat)fs {
    return [UIFont systemFontOfSize:LTAutoW(fs)];
}

+ (UIFont *)autoBoldFontSize:(CGFloat)fs {
    return [UIFont boldSystemFontOfSize:LTAutoW(fs)];
}



+ (UIFont *)fontOfSize:(CGFloat)fontSize {
    return [UIFont systemFontOfSize:fontSize];
}

+ (UIFont *)boldFontOfSize:(CGFloat)fontSize{
    return [UIFont boldSystemFontOfSize:fontSize];
}

+ (UIFont *)fontSTHeitiTC_Light:(CGFloat)fontSize {
    return [UIFont fontWithName:@"STHeitiTC-Light" size:(CGFloat)fontSize];
}

+ (UIFont *)fontPingFangSC:(CGFloat)fontSize {
    return [UIFont fontWithName:@"PingFang SC" size:(CGFloat)fontSize];
    
}

@end
