//
//  JWTHundel.h
//  Canary
//
//  Created by 孙武东 on 2019/1/17.
//  Copyright © 2019 litong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JWTHundel : NSObject

+ (JWTHundel *)shareHundle;

- (void)createLogin;

- (void)createTimer;

- (void)removeTimer;

- (NSString *)getRSAKEY:(NSString *)jsonStr;

//上传公钥
- (void)uploadPublicKey;

- (void)switchGetInfo;

@end

NS_ASSUME_NONNULL_END
