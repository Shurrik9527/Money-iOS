//
//  LiveGiftMO.h
//  ixit
//
//  Created by litong on 2017/3/30.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BaseMO.h"


#define GiftSingleBgColor       LTColorHexA(0x2B2B2C, 0.96)
#define GiftSingleBgColorSel  LTColorHex(0x2B2B2C)

/** 聊天室单个礼物 */
@interface LiveGiftMO : BaseMO

@property (nonatomic,copy) NSString *giftId;//	礼物ID
@property (nonatomic,copy) NSString *giftName;//	礼物名称
@property (nonatomic,copy) NSString *giftSmallPic;//	礼物小图片
@property (nonatomic,copy) NSString *giftPic;//	礼物大图片
@property (nonatomic,copy) NSString *poins;//	礼物需要的积分

- (NSAttributedString *)poins_absfmt;


#define kGiftDataVerKey    @"kGiftDataVerKey"
+ (void)saveGiftImgDict:(NSDictionary *)dict;
+ (NSInteger)giftDataVer;
+ (NSString *)giftImgKey:(NSString *)gid;
+ (NSString *)giftImgUrl:(NSString *)gid;


@end
