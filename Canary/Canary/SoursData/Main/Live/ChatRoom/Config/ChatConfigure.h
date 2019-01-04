//
//  ChatConfigure.h
//  群聊
//
//  Created by shuoliu on 16/3/7.
//  Copyright © 2016年 shuoLiu. All rights reserved.
//

//#import "NIMSessionConfig.h"
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, NTESMediaButton)
{
    NTESMediaButtonPicture = 0,    //相册
    NTESMediaButtonShoot,          //拍摄
    NTESMediaButtonLocation,       //位置
    NTESMediaButtonJanKenPon,      //石头剪刀布
    NTESMediaButtonVideoChat,      //视频语音通话
    NTESMediaButtonAudioChat,      //免费通话
    NTESMediaButtonFileTrans,      //文件传输
    NTESMediaButtonSnapchat,       //阅后即焚
    NTESMediaButtonWhiteBoard,     //白板沟通
    NTESMediaButtonTip,            //提醒消息
};
@interface ChatConfigure : NSObject 
- (instancetype)initWithChatroom:(NSString *)roomId;
//- (instancetype)initWithSession:(NIMSession *)session;

@end
