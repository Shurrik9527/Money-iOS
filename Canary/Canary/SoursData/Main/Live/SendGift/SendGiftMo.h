//
//  SendGiftMo.h
//  LTDevDemo
//
//  Created by litong on 2017/3/28.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendGiftMo : NSObject

@property (nonatomic,copy) NSString *senderId; // 送礼物者ID
@property (nonatomic,copy) NSString *senderName; // 送礼物者
@property (nonatomic,assign) NSInteger senderLv; // 送礼物者等级

@property (nonatomic,copy) NSString *giftId; //礼物ID
@property (nonatomic,copy) NSString *giftName; //礼物名称
@property (nonatomic,assign) NSInteger giftCount; // 礼物个数

+ (SendGiftMo *)objWithDict:(NSDictionary *)dict;

- (NSString *)onlyKey;
- (NSString *)giftImgUrl;
- (NSString *)senderLv_fmt;
- (UIColor *)sendLvColor;


@end
