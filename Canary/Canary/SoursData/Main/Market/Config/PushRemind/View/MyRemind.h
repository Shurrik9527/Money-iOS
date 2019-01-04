//
//  MyRemind.h
//  ixit
//
//  Created by litong on 2017/2/17.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PushRemindConfigModel.h"

typedef void(^ReqRemindListBlock)(void);
typedef void(^GoLoginBlock)(void);
typedef void(^AddRemindBlock)(void);
typedef void(^EditRemindBlock)(NSInteger row);

/** 我的提醒 */
@interface MyRemind : UIView

//请求列表
@property (nonatomic,copy) ReqRemindListBlock reqRemindListBlock;
//去登录
@property (nonatomic,copy) GoLoginBlock goLoginBlock;
@property (nonatomic,copy) AddRemindBlock addRemindBlock;
//跳转到  编辑提醒
@property (nonatomic,copy) EditRemindBlock editRemindBlock;

@property (nonatomic,strong) PushRemindConfigModel *remindConfigModel;

- (instancetype)initWithTempH:(CGFloat)h excode:(NSString *)exCode code:(NSString *)code pName:(NSString *)pName;
- (void)reload:(NSArray *)list;
- (void)showView:(BOOL)show;
- (void)showView:(BOOL)show animate:(BOOL)animate;

@end
