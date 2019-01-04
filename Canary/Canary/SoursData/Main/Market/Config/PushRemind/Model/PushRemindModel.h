//
//  PushRemindModel.h
//  ixit
//
//  Created by Brain on 2017/2/10.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BaseMO.h"

@interface PushRemindModel : BaseMO
@property(copy,nonatomic)NSString *customizedProfit;
@property(copy,nonatomic)NSString *exchangeName;
@property(copy,nonatomic)NSString *productName;
@property(copy,nonatomic)NSString *reminderProfit;
@property(copy,nonatomic)NSString *sendTime;
@property(strong,nonatomic)NSNumber *margin;//涨跌幅
@property(copy,nonatomic)NSString*mq;//百分比
@property(copy,nonatomic)NSString *productCode;
@property(copy,nonatomic)NSString *productExcode;
@property(copy,nonatomic)NSString *updateTime;
@property(copy,nonatomic)NSString *userName;
@property(copy,nonatomic)NSString *userMobile;
@property(copy,nonatomic)NSString *userId;
@property(copy,nonatomic)NSString *pid;
@property(copy,nonatomic)NSString *createTime;
@property(copy,nonatomic)NSString *expirationTime;
@property(copy,nonatomic)NSString *userLever;
@property(copy,nonatomic)NSString *floatDownProfit;
@property(copy,nonatomic)NSString *floatUpProfit;
@property(copy,nonatomic)NSString *buyType;

@property(assign,nonatomic)NSInteger cycleType;
@property(assign,nonatomic)NSInteger exchangeId;
@property(assign,nonatomic)NSInteger status;
@property(assign,nonatomic)NSInteger type;

//5点 | %@ - %@ 有效
- (NSString *)wave_fmd;

//@"%@ - %@ 有效"
- (NSString *)validTime_fmd;

+ (PushRemindModel *)testMO;

/*
createTime = 1487333047000;
customizedProfit = "3001.1";
cycleType = 1;
exchangeId = 8;
exchangeName = "\U54c8\U5c14\U6ee8\U8d35\U91d1\U5c5e\U4ea4\U6613\U4e2d\U5fc3";
expirationTime = 1487419447000;
floatDownProfit = 10;
floatUpProfit = 10;
id = 121;
margin = "";
mq = "";
productCode = HGNI;
productExcode = HPME;
productName = "\U54c8\U8d35\U954d";
reminderProfit = "";
sendTime = "<null>";
status = 1;
type = 2;
updateTime = "<null>";
userId = 125068;
userLever = 7;
userMobile = 18521302526;
userName = "\U795e\U7b97\U5b50";
*/


@end
