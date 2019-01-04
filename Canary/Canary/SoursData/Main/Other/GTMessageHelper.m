//
//  GTMessageHelper.m
//  ixit
//
//  Created by Brain on 2017/1/11.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "GTMessageHelper.h"
#import "AppDelegate.h"
#import "WebVCtrl.h"
//#import "StrategyDetailViewController.h"

#define kNewsCodeWithType @{@"1":@[@"REALTIME",@"实时新闻"],@"2":@[@"IMPORTANT",@"全球要闻"],@"3":@[@"OIL",@"大宗商品头条"],@"4":@[@"PROFESSIONAL",@"专家策略"],@"5":@[@"HEADLINE",@"黄金头条"],@"6":@[@"ACTIVITY",@"在线活动"]}
// ios 8.0 以后可用，这个参数要求指定为固定值
#define kCategoryIdentifier @"xiaoyaor"

@implementation GTMessageHelper
+ (GTMessageHelper *)shared {
    static GTMessageHelper *sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedObject) {
            sharedObject = [[[self class] alloc] init];
        }
    });
    return sharedObject;
}
-(void)dealloc{
    _userInfo=nil;
    _alert=nil;
}
+ (void)showCustomAlertViewWithUserInfo:(NSDictionary *)userInfo{
    [GTMessageHelper shared].userInfo = userInfo;
    // 应用当前处于前台时，需要手动处理
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive || [UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *title = [userInfo objectForKey:@"title"];
            NSString *msg = [userInfo objectForKey:@"body"];
            msg = [msg stringByRemovingPercentEncoding];
            if (!title) {
                title = @"推送消息";
            }
            if (!msg) {
                msg = @"";
            }
            if (![GTMessageHelper shared].alert) {
                [GTMessageHelper shared].alert = [[UIAlertView alloc] initWithTitle:title
                                                                    message:msg
                                                                   delegate:[GTMessageHelper shared]
                                                          cancelButtonTitle:@"知道了"
                                                          otherButtonTitles:@"去查看", nil];
            }
            [GTMessageHelper shared].alert.title=title;
            [GTMessageHelper shared].alert.message=msg;
            [[GTMessageHelper shared].alert show];
        });
    }
    NSLog(@"%ld",(long)[UIApplication sharedApplication].applicationState);
    return;
}

#pragma mark - UIAlertViewDelegate
/*
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // 点击确定
        // action
        NSDictionary *userInfo = [GTMessageHelper shared].userInfo;
        NSString *action = userInfo[@"action"];
        if (action) {
            [GTMessageHelper notificationActionHandle:action];
        }
    }
    return;
}
#pragma mark 处理推送
+(void)notificationActionHandle:(NSString*)action{
    if(!action)return;
    NSDictionary *params = [GTMessageHelper shared].userInfo;;
    NSString *newsTitle = [params objectForKey:@"title"];
    if (newsTitle)
        newsTitle = [newsTitle stringByRemovingPercentEncoding];
    NSString *newsUrl = [params objectForKey:@"url"];
    if (newsUrl) {
        newsUrl =  [newsUrl stringByRemovingPercentEncoding];
        //newsUrl = [newsUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (!([newsUrl hasPrefix:@"http://"] | [newsUrl hasPrefix:@"https://"])) {
            newsUrl = [NSString stringWithFormat:@"http://%@",newsUrl];
        }
    }
    NSString *actionValue = [[params objectForKey:@"action"] stringByReplacingOccurrencesOfString:@"touzile://" withString:@""];
    if ([actionValue isEqualToString:@"webview"]) {
        NSLog(@" newsUrl =%@",newsUrl);
        WebVCtrl *web = [[WebVCtrl alloc] initWithTitle:newsTitle url:[NSURL URLWithString:newsUrl]];
        [[AppDelegate sharedInstance].window.rootViewController presentVC:web];
    }
}
+(NSString*)newsCodeWithType:(int)newsType{
    NSDictionary *newsTypes = kNewsCodeWithType;
    NSArray *typs = [newsTypes objectForKey:[NSString stringWithFormat:@"%d",newsType]];
    if (typs) {
        return [[typs firstObject] lowercaseString];
    }
    newsTypes = nil;
    typs = nil;
    return nil;
}

@end
