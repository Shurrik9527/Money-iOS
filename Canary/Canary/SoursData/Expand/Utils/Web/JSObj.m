//
//  JSObj.m
//  ixit
//
//  Created by litong on 2016/11/25.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "JSObj.h"

@implementation JSObj

- (void)openShare:(NSString *)title :(NSString *)url {
    if (_delegate && [_delegate respondsToSelector:@selector(openShare:url:)]) {
        [_delegate openShare:title url:url];
    }
}

- (void)shareByJson:(NSString *)jsonStr {
    if (_delegate && [_delegate respondsToSelector:@selector(shareByJson:)]) {
        [_delegate shareByJson:jsonStr];
    }
}

@end
