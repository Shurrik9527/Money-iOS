//
//  NetworkRequests.h
//  YiSheGou-M
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 JHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NetworkSuccess)(id resonseObj , BOOL isSuccess , NSString *message);


@interface NetworkRequests : NSObject

+ (NetworkRequests *)sharedInstance;

- (void)SWDGET:(NSString *)URLString
          dict:(id)dict
       succeed:(NetworkSuccess)success
       failure:(void (^)(NSError *error))failure;

- (void)SWDPOST:(NSString *)URLString
           dict:(id)dict
        succeed:(NetworkSuccess)success
        failure:(void (^)(NSError *error))failure;


- (void)GET:(NSString *)URLString dict:(id)dict succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure;
- (void)POST:(NSString *)URLString dict:(id)dict succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure;

- (void)LoginPOST:(NSString *)URLString dict:(id)dict succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure;
- (void)RegisterPOST:(NSString *)URLString dict:(id)dict succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure;

@end
