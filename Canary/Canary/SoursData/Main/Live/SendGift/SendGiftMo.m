//
//  SendGiftMo.m
//  LTDevDemo
//
//  Created by litong on 2017/3/28.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "SendGiftMo.h"
#import "LiveGiftMO.h"

@implementation SendGiftMo


+ (SendGiftMo *)objWithDict:(NSDictionary *)dict {
    
    NSString *senderId = [dict stringFoKey:@"senderId"];
    NSString *senderName = [dict stringFoKey:@"senderName"];
    NSInteger senderLv = [dict integerFoKey:@"levelNum"];
    
    if (emptyStr(senderId) || emptyStr(senderName)) {
        return nil;
    }
    
    NSDictionary *dic = [dict dictionaryFoKey:@"data"];
    NSString *giftId = [dic stringFoKey:@"giftId"];
    NSString *giftName = [dic stringFoKey:@"giftName"];
    NSInteger giftCount = [dic integerFoKey:@"giftNum"];
    
    // 礼物模型
    SendGiftMo *giftMo = [[SendGiftMo alloc] init];
    giftMo.giftId = giftId;
    giftMo.giftName = giftName;
    giftMo.giftCount = giftCount;
    
    giftMo.senderId = senderId;
    giftMo.senderName = senderName;
    giftMo.senderLv = senderLv;
    
    return giftMo;
}

- (NSString *)onlyKey {
    NSString *str = [NSString stringWithFormat:@"SGK%@,%@",_giftId,_senderId];
    return str;
}


- (NSString *)giftImgUrl {
    NSString *imgUrl = [LiveGiftMO giftImgUrl:_giftId];
    return imgUrl;
}

- (NSString *)senderLv_fmt {
    NSString *str = [NSString stringWithFormat:@"v%ld",self.senderLv];
    return str;
}

#define kMeVipColor @[@"FFB601",@"FF9F01",@"FF7901",\
@"FF5101",@"FF3A01",@"FF0000",@"FF006A"]
- (UIColor *)sendLvColor {
    NSString *coStr = @"B4B9CB";
    if (self.senderLv > 4) {
        coStr = kMeVipColor[(self.senderLv-1)];
    }
    return LTColorHexString(coStr);
}

@end
