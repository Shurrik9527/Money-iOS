//
//  AppDelegate.h
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#define  kCoreDataContext  [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "GeTuiSdk.h" // GetuiSdk
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#import <CoreData/CoreData.h>
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate*)sharedInstance;
+ (void)selectTabBarIndex:(TabBarType)index;
+ (TabBarType)currtenTabbarIndex;
- (UINavigationController *)rootNavCtrl;

@property(strong,nonatomic)NSDictionary * dealMsgDic;
@property(strong,nonatomic)NSMutableArray * remindList;
- (void)configRemindModelWithDic:(NSDictionary *)dic;
- (void)showRemindPop;
-(void)showDealMsgPop;

#pragma mark CoreData
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

