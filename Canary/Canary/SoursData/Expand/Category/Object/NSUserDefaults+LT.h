//
//  NSUserDefaults+LT.h
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UserDefaults  [NSUserDefaults standardUserDefaults]
#define UD_SetObjForKey(obj,key)    [NSUserDefaults setObj:obj foKey:key]
#define UD_ObjForKey(key)               [NSUserDefaults objFoKey:key]
#define UD_RemoveForKey(key)    [NSUserDefaults removeObjFoKey:key]

@interface NSUserDefaults (LT)

//取值
+ (id)objFoKey:(NSString*)key;
//设值
+ (void)setObj:(id)value foKey:(NSString *)key;
//删除
+ (void)removeObjFoKey:(NSString *)key;

+ (void)removeAll;


@end
