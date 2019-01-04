//
//  GTMessageHelper.h
//  ixit
//
//  Created by Brain on 2017/1/11.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTMessageHelper : NSObject
@property (nonatomic, strong) NSDictionary *userInfo;
@property(strong,nonatomic)UIAlertView * alert;

//建立单例
+ (GTMessageHelper *)shared;
//推送消息处理
+(void)notificationActionHandle:(NSString*)action;
+ (void)showCustomAlertViewWithUserInfo:(NSDictionary *)userInfo;
@end
