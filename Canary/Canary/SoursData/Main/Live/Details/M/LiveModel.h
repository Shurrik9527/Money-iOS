//
//  LiveModel.h
//  ixit
//
//  Created by litong on 16/10/26.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "BaseMO.h"

@interface LiveModel : BaseMO

@property (nonatomic, copy) NSString *chatRoomId; /**< 聊天室id */
@property (nonatomic, copy) NSString *chatName;  /**< 聊天室名字 */
@property (nonatomic, copy) NSString *rtmpDownstreamAddress;  /**< 聊天室拉流地址 */
@property (nonatomic, copy) NSString *hlsDownstreamAddress;  /**< 聊天室拉流地址 */
@property (nonatomic, copy) NSString *teachers; /**< 频道指导老师 */
@property (nonatomic, copy) NSString *image;  /**< 频道图片 */
@property (nonatomic, copy) NSString *password;  /**< 频道密码 */

@property (nonatomic, copy) NSString *channelDescribe;  /**< 频道描述 */
@property (nonatomic, strong) NSNumber *channelId; /**< 频道ID */
@property (nonatomic, copy) NSString *channelName; /**< 频道名 */
@property (nonatomic, strong) NSNumber *channelStatus; /**< 频道状态 */
@property (nonatomic, copy) NSString *channelStatusName; /**< 频道状态 */
@property (nonatomic, strong) NSNumber *onlineNumber; /**< 在线人数 */

@end
