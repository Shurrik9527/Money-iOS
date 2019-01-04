//
//  KeyChainManager.h
//  PandaINV
//
//  Created by Brain on 2017/5/12.
//  Copyright © 2017年 Brain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface KeyChainManager : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;

@end
