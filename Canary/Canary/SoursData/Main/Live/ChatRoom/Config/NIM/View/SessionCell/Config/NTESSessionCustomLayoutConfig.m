//
//  NTESSessionCustomConfig.m
//  NIM
//
//  Created by chris on 15/7/24.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESSessionCustomLayoutConfig.h"
#import "NTESCustomAttachmentDefines.h"
#import "NTESSessionUtil.h"
#import "NTESSessionCustomContentConfig.h"
#import "NTESGlobalMacro.h"
//#import "NIMSDK.h"
//#import "NIMMessageModel.h"

@interface NTESSessionCustomLayoutConfig()
@property (nonatomic,strong) NTESSessionCustomContentConfig *contentConfig; //所有的自定义消息都使用这个对象，重用
@end

@implementation NTESSessionCustomLayoutConfig

- (instancetype)init{
    self = [super init];
    if (self) {
        _contentConfig = [[NTESSessionCustomContentConfig alloc] init];
    }
    return self;
}



- (CGSize)contentSize:(NSObject *)model cellWidth:(CGFloat)width{
//    id<NIMSessionContentConfig> config = [self sessionContentConfig:model.message];
//    return [config contentSize:width];
    return CGSizeZero;
}

- (NSString *)cellContent:(NSObject *)model{
//    id<NIMSessionContentConfig> config = [self sessionContentConfig:model.message];
//    return [config cellContent];
    return @"";

}

- (UIEdgeInsets)contentViewInsets:(NSObject *)model
{
//    id<NIMSessionContentConfig> config = [self sessionContentConfig:model.message];
//    return [config contentViewInsets];
    return UIEdgeInsetsMake(0, 0, 0, 0);

}


#pragma mark - misc
- (id)sessionContentConfig:(NSObject *)message{
//    self.contentConfig.message = message;
    return self.contentConfig;
}

#pragma mark - 支持类型配置
+ (BOOL)supportMessage:(NSObject *)message{
    NSArray *supportType = [NTESSessionCustomLayoutConfig supportAttachmentType];
//    NIMCustomObject *object = message.messageObject;
//    return [supportType indexOfObject:NSStringFromClass([object.attachment class])] != NSNotFound;
    return  NULL;
}

+ (NSArray *)supportAttachmentType
{
    static NSArray *types = nil;
    static dispatch_once_t onceTypeToken;
    //所对应的contentView只适用于cellClass为NTESSessionChatCell的情况，其他cellClass则需要自己实现布局
    dispatch_once(&onceTypeToken, ^{
        types =  @[
                   @"NTESJanKenPonAttachment",
                   @"NTESSnapchatAttachment",
                   @"NTESChartletAttachment",
                   @"SessionReplayAttachment",
                   @"NTESWhiteboardAttachment"
                   ];
    });
    return types;
}

@end
