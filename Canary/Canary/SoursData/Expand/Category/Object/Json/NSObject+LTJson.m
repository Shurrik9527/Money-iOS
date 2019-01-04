//
//  NSObject+LTJson.m
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "NSObject+LTJson.h"
#import "NSObject+LT.h"

@implementation NSObject (LTJson)


- (NSData *)toJsonData {
    NSError *error;
    //    NSJSONWritingPrettyPrinted  是有换位符；  nil：无换位符
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (jsonData) {
        return jsonData;
    }
    
    NSLog(@"ToJsonData error : %@", error);
    return nil;
}


- (NSString *)toJsonString {
//    if (![NSObject isNotNull]) {
//        return nil;
//    }
    NSData *jsonData = [self toJsonData];
    if (jsonData) {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    return nil;
}


+ (id)objWithJsonString:(id)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    if (![jsonString isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    
    id obj = [NSJSONSerialization JSONObjectWithData:jsonData
                                             options:NSJSONReadingMutableContainers
                                               error:&err];
    
    if(err) {
        NSLog(@"NSObject (LTJson) === json解析失败");
        NSLog(@"---------------------");
        NSLog(@"%@",jsonString);
        NSLog(@"---------------------");
        return nil;
    }
    return obj;
}

- (NSArray *)jsonStringToArray {
    id obj = [NSObject objWithJsonString:self];
    if ([obj isKindOfClass:[NSArray class]]) {
        return [NSArray arrayWithArray:obj];
    }
    return nil;
}
- (NSDictionary *)jsonStringToDictonary {
    id obj = [NSObject objWithJsonString:self];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return [NSDictionary dictionaryWithDictionary:obj];
    }
    return nil;
}


@end
