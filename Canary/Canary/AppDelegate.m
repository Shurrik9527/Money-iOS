//
//  AppDelegate.m
//  ferret
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+GT.h"
#import "GuideCtrl.h"
#import "GTMessageHelper.h"
#import "PopDealMsgV.h"
#import "LTSocketServe.h"
#import "WeiPanMarketViewController.h"
//#import "NIMKit.h"
#import <NIMSDK/NIMSDK.h>

#import "NTESNotificationCenter.h"
#import "NTESCustomAttachmentDecoder.h"
#import "PopRemind.h"
#import "PopDealMsgV.h"
#import "JWTHundel.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@property (nonatomic,strong) ViewController *mainVCtrl;
@property (nonatomic, strong) UINavigationController *navCtrl;

//推送提醒
@property(strong,nonatomic)PopRemind * remindView;
@property(strong,nonatomic)PushRemindModel * remindModel;
//平仓提醒
@property(strong,nonatomic)PopDealMsgV * dealView;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [LTUser reqStartup];
    [[JWTHundel shareHundle] createLogin];
    [[JWTHundel shareHundle] switchGetInfo];
    
    [self defaultValueConfig];//默认值配置
    
//    [self configUMeng];
//    [self configPush];
//    [self configShare];
//    [self configGT];
//    [self configureNIM];//初始化聊天室
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self configTabBarController:NO];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

#pragma mark - 私有方法
-(void)defaultValueConfig {
    [LTUtils setSetingDefaultValue];
}

//初始化 主页TabBar -- 未显示过导航页，先显示导航页
- (void)configTabBarController:(BOOL)needReg {
    BOOL guidShowed = [GuideCtrl showed];
    if (![LTUser hideDeal]) {
        guidShowed=YES;
    }
    if (guidShowed) {
        if (self.window.rootViewController) {
            [self.window.rootViewController removeFromParentViewController];
        }
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        
        self.mainVCtrl = [[ViewController alloc] init];
        self.navCtrl = [[UINavigationController alloc] initWithRootViewController:self.mainVCtrl];
        self.window.rootViewController = self.navCtrl;
        if (needReg) {
            [self.mainVCtrl pushReg];
        }
    } else {
        WS(ws);
        GuideCtrl *ctrl = [GuideCtrl showGuideShutBlock:^{
            [ws configTabBarController:NO];
        } registerBlock:^{
            [ws configTabBarController:YES];
        }];
        self.window.rootViewController = ctrl;
    }
}

//友盟
- (void)configUMeng {
    UMConfigInstance.appKey = kUmeng_appkey;
    UMConfigInstance.channelId = kAppMarket;
    [MobClick startWithConfigure:UMConfigInstance];
}

//第三方推送
- (void)configPush {
    [self registerAPNs];//注册权限
}

//第三方分享
- (void)configShare {
    
}
//聊天室
- (void)configureNIM {
    [[NIMSDK sharedSDK] registerWithAppID:IMAppKey cerName:IMCerName];
    [NIMCustomObject registerCustomDecoder:[NTESCustomAttachmentDecoder new]];
    [[NTESNotificationCenter sharedCenter] start];
}


// 申请通知权限
- (void)registerAPNs {
    if (kSystemVersion >= 10.0) {
        // Xcode 8编译会调用
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
//                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else
        // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
    } else if (kSystemVersion >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                       UIRemoteNotificationTypeSound |
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
}
#pragma mark - GTpop
//初始化 PopRemind
- (void)initPushRemindPop {
    if (!usePushRemind) { return; }
    if (!_remindView) {
        _remindView = [[PopRemind alloc]init];
        WS(ws);
        _remindView.clickCell = ^(ActionType type,PushRemindModel *model) {
            switch (type) {
                case ActionType_PushMarket: {
                    //跳转行情
                    NSString *exCode= model.productExcode;
                    NSString *code= model.productCode;
                    NSString *name = model.productName;
                    NSString *key = [NSString stringWithFormat:@"%@_%@_MarketIsPresent",exCode,code];
                    NSString *value = UD_ObjForKey(key);
                    if ([value isEqualToString:@"1"]) {
                        [ws.remindView hide];
                        return;
                    }
                    if (notemptyStr(exCode) && notemptyStr(code)) {
                        WeiPanMarketViewController *kline =
                        [[WeiPanMarketViewController alloc] initWithCode:code exCode:exCode title:name];
                        [ws.navCtrl pushVC:kline];
                    }
                }
                    break;
                case ActionType_PushPosition: {
                    //跳转持仓
                    [ws.navCtrl popToRootVC];
                    [AppDelegate selectTabBarIndex:2];
                    NFC_PostName(NFC_PushPosition);
                }
                    break;
                case ActionType_Hide: {
                    [ws.remindList removeAllObjects];
                }
                    break;
                default:
                    break;
            }
        };
        [AppKeyWindow addSubview:_remindView];
    }
}
//显示推送提醒
- (void)showRemindPop{
    if(!_remindView.isShow){
        _remindView=nil;
    }
    [self initPushRemindPop];
    [_remindView configViewWithModelList:_remindList];
    _remindView.hidden=NO;
    [AppKeyWindow bringSubviewToFront:_remindView];
}

- (void)initDealMsgPop{
    _dealView = [AppKeyWindow viewWithTag:999999];
    if (!_dealView) {
        _dealView=[[PopDealMsgV alloc]init];
        _dealView.tag=999999;
        [AppKeyWindow addSubview:_dealView];
    }
}

- (void)showDealMsgPop{
    if (!_dealView) {
        [self initDealMsgPop];
    }
    [_dealView configWithData:_dealMsgDic];
    [_dealView showView:YES];
}

#pragma mark 推送消息处理

//收到通知消息处理
- (void)notificationWithUserInfo:(NSDictionary *)userInfo {
    if (!emptyStr([userInfo stringFoKey:@"nim"])) {
        //云信
        return;
    }
    if (!emptyStr([userInfo stringFoKey:@"_gurl_"])) {
        NSMutableDictionary *gtDic=[[NSMutableDictionary alloc]initWithDictionary:userInfo];
        NSString *msgStr=[gtDic stringFoKey:@"msg"];
        NSDictionary *user = [msgStr jsonStringToDictonary];
        if([[user objectForKey:@"data"] isNotNull]) {
            NSInteger type = [[user objectForKey:@"sendType"] integerValue];
            //type 1.系统消息 2.行情提醒 3.直播室广播 4.系统平仓
            if (type>=2) {
                return;
            }
        }
        [GTMessageHelper showCustomAlertViewWithUserInfo:user];
        [GeTuiSdk handleRemoteNotification:userInfo];
        return;
    }
}

- (void)alertWithGTDic:(NSDictionary *)params {
    NSString *title = [params objectForKey:@"title"];
    if (!title) { title = @"推送消息"; }
    NSString *msg = params[@"title"];
    msg = [msg stringByRemovingPercentEncoding];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)configRemindModelWithDic:(NSDictionary *)dic{
    if([[dic objectForKey:@"data"] isNotNull]){
        NSMutableDictionary *data=[dic objectForKey:@"data"];
        _remindModel=[[PushRemindModel alloc]init];
        _remindModel.productName=[data stringFoKey:@"name"];;
        _remindModel.exchangeId=[[data stringFoKey:@"pid"] integerValue];
        _remindModel.productExcode=[data stringFoKey:@"excode"];
        _remindModel.productCode=[data stringFoKey:@"code"];
        double time=[[[NSString stringWithFormat:@"%@",[data objectForKey:@"time"]] substringWithRange:NSMakeRange(0, 10)] doubleValue];
        _remindModel.updateTime=[LTUtils timeforMin:time];
        _remindModel.sendTime=[LTUtils timeforMin:time];
        _remindModel.mq=[data stringFoKey:@"mq"];
        _remindModel.customizedProfit=[data stringFoKey:@"reminderProfit"];
        _remindModel.margin=[data numberFoKey:@"margin"];
    }
    if (!_remindList) {
        _remindList=[[NSMutableArray alloc]init];
    }
    [_remindList insertObject:_remindModel atIndex:0];
    if(![LTUser hasLogin]){
        return;
    }
    [self showRemindPop];
}

#pragma mark - 外部方法

+ (AppDelegate*)sharedInstance {
    return ((AppDelegate*) [[UIApplication sharedApplication] delegate]);
}

+ (void)selectTabBarIndex:(TabBarType)type {
    AppDelegate *appd = [AppDelegate sharedInstance];
    [appd.mainVCtrl selectTabBarType:type];
}
+ (TabBarType)currtenTabbarIndex{
    AppDelegate *appd = [AppDelegate sharedInstance];
    return appd.mainVCtrl.tabBarType;

}
- (UINavigationController *)rootNavCtrl {
    return _navCtrl;
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//App处于前台接收通知时
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    //收到推送的请求
    UNNotificationRequest *request = notification.request;
    //收到推送的内容
    UNNotificationContent *content = request.content;
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
        [self notificationWithUserInfo:userInfo];
    } else {
        // 判断为本地通知
        [self notificationWithUserInfo:userInfo];
    }
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionAlert);
}
#endif


//App通知的点击事件
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    //收到推送的请求
    UNNotificationRequest *request = response.notification.request;
    //收到推送的内容
    UNNotificationContent *content = request.content;
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
        [self notificationWithUserInfo:userInfo];
    }else {
        // 判断为本地通知
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
    }
    
    completionHandler(); // 系统要求执行这个方法
}
#pragma mark -iOS 10之前收到通知

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"userInfo = %@",userInfo);
    [self notificationWithUserInfo:userInfo];// 处理推送消息
    [GeTuiSdk handleRemoteNotification:userInfo];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"userInfo == %@",userInfo);
    [self notificationWithUserInfo:userInfo];// 处理推送消息
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    NSLog(@"Regist fail%@",error);// 一般是系统禁用了推送
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options{
    return YES;
}

#pragma mark - system

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

//切换后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    NFC_PostName(NFC_AppDidEnterBackground);
}

//从后台唤醒app
- (void)applicationWillEnterForeground:(UIApplication *)application {
    NFC_PostName(NFC_AppWillEnterForeground);
    [LTSocketServe connectSocket];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Core Data stack 数据库

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.bob.TcoreData" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DataModel.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
