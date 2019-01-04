//
//  AddRemind.h
//  ixit
//
//  Created by litong on 2017/2/17.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PushRemindModel.h"
#import "PushRemindConfigModel.h"


typedef void(^ReqRemindListBlock)(void);
typedef void(^AddRemindShutBlock)();

/** 添加提醒 */
@interface AddRemind : UIView

@property (nonatomic,copy) ReqRemindListBlock reqRemindListBlock;
//关闭添加提醒
@property (nonatomic,copy) AddRemindShutBlock addRemindShutBlock;
@property (nonatomic,strong) PushRemindConfigModel *remindConfigModel;


- (instancetype)initWithTempH:(CGFloat)h excode:(NSString *)excode code:(NSString *)code pName:(NSString *)pName;
- (void)showView:(BOOL)show;

- (void)changeEditing:(PushRemindModel *)mo;

@end
