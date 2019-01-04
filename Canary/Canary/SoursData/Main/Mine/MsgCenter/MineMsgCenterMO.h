//
//  MineMsgCenterMO.h
//  ixit
//
//  Created by litong on 2017/3/10.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BaseMO.h"


typedef NS_ENUM(NSUInteger, MineMsgType) {
    MineMsgType_Normal = 0,//异常
    MineMsgType_System,//系统，官方
    MineMsgType_Quan,//券
    MineMsgType_Deal,//仓
};


@interface MineMsgCenterMO : BaseMO

@property (nonatomic,copy) NSString *messageId;//	Long	主消息ID
@property (nonatomic,copy) NSString *messageDetailId;//	String	消息ID
@property (nonatomic,copy) NSString *messageTitle;//	String	消息标题
@property (nonatomic,copy) NSString *messageContent;//	String	消息内容
@property (nonatomic,copy) NSString *createTime;//	Long	创建时间

/** messageType  	false	普通参数	string
        官 -- 1：系统消息; 8：交易风险-系统提示;
        券 --  4,代金券-到账提醒;5,代金券-到期提现;6,代金券-即将到期;
        仓 -- 3,系统平仓-爆仓提醒;7,系统平仓-止盈止损;
        2,行情提醒;（不处理）
 */
@property (nonatomic,assign) NSInteger messageType;
@property (nonatomic,assign) NSInteger status;//	Integer	消息状态（1:未读，2:已读,3失败）

@property (nonatomic,copy) NSString *excode;//	String	交易所编号
@property (nonatomic,copy) NSString *orderId;//	String	订单号
@property (nonatomic,copy) NSString *url;//	String	跳转地址

@property (nonatomic,copy) NSString *userId;//
@property (nonatomic,copy) NSString *nickName;//
@property (nonatomic,copy) NSString *mobile;//

@property (nonatomic,copy) NSString *targetObject;//
@property (nonatomic,copy) NSString *sendTime;//
@property (nonatomic,copy) NSString *sendType;//
@property (nonatomic,copy) NSString *deadline ;//


- (BOOL)showRed;
- (NSString *)createTime_fmt;
- (MineMsgType)mineMsgType;


+ (NSArray *)testDatas;

/*
 createTime = 1488877962996;
 deadline = "<null>";
 excode = "";
 messageContent = "\U672c\U5468\U5468\U672b\Uff0803.07-0.08\Uff09\U7cfb\U7edf\U5347\U7ea7\Uff0c\U5c4a\U65f6\U5c06\U6709\U90e8\U5206\U7528\U6237\U51fa\U73b0\U767b\U5f55\U5f02\U5e38\Uff0c\U8bf7\U77e5\U6653\Uff01";
 messageDetailId = 010148887796299639f5;
 messageId = 6;
 messageTitle = "\U7cfb\U7edf\U5347\U7ea7\U516c\U544a";
 messageType = 1;
 mobile = 18521302526;
 nickName = "\U795e\U7b97\U5b50";
 orderId = "";
 sendTime = "<null>";
 sendType = "<null>";
 status = 1;
 targetObject = "<null>";
 url = "";
 userId = 125068;
 
 */


@end
