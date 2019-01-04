//
//  NSObject+LTJson.h
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LTJson)

/** 转Data */
- (NSData *)toJsonData;
- (NSString *)toJsonString;


- (NSArray *)jsonStringToArray;
- (NSDictionary *)jsonStringToDictonary;

@end
