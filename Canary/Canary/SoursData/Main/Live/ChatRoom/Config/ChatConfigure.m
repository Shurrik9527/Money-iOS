//
//  ChatConfigure.m
//  群聊
//
//  Created by shuoliu on 16/3/7.
//  Copyright © 2016年 shuoLiu. All rights reserved.
//

#import "ChatConfigure.h"
#import "ChatroomMessageDataProvider.h"
#import "NTESBundleSetting.h"
@interface ChatConfigure ()

@property (nonatomic, strong) ChatroomMessageDataProvider *provider;

@end

@implementation ChatConfigure

- (instancetype)initWithChatroom:(NSString *)roomId {
    self = [super init];
    if (self) {
        self.provider = [[ChatroomMessageDataProvider alloc] initWithChatroom:roomId];
    }
    return self;
}
//-(instancetype)initWithSession:(NIMSession *)session
//{
//    self = [super init];
//    if (self)
//    {
//        self.provider=[[ChatroomMessageDataProvider alloc] initWithSession:session];
//    }
//    return self;
//}
//- (id<NIMKitMessageProvider>)messageDataProvider
//{
//    return self.provider;
//}
//
//- (BOOL)shouldHideItem:(NIMMediaItem *)item {
//    BOOL hidden = NO;
//    return hidden;
//}

- (BOOL)disableCharlet {
    return YES;
}

//- (NSArray<NSNumber *> *)inputBarItemTypes {
//    if (useThreeLive) {
//        return @[
//                 @(NIMInputBarItemTypeEmoticon),
//                 @(NIMInputBarItemTypeTextAndRecord),
//                 @(NIMInputBarItemTypeQuestion),
//                 @(NIMInputBarItemTypeGift),
//                 @(NIMInputBarItemTypeMore)
//                 ];
//    }
//    return @[
//        @(NIMInputBarItemTypeEmoticon),
//        @(NIMInputBarItemTypeTextAndRecord),
//        @(NIMInputBarItemTypeGift),
//        @(NIMInputBarItemTypeMore)
//    ];
//}

//- (NSArray *)mediaItems {
//    return @[[NIMMediaItem item:NTESMediaButtonPicture
//             normalImage:[UIImage imageNamed:@"bk_media_picture_normal"]
//           selectedImage:[UIImage imageNamed:@"bk_media_picture_nomal_pressed"]
//                          title:@"相册"],];
//}

//- (NIMAudioType)recordType
//{
//    return [[NTESBundleSetting sharedConfig] usingAmr] ? NIMAudioTypeAMR : NIMAudioTypeAAC;
//}

@end
