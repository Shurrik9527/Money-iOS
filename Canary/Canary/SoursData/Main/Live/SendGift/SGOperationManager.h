//
//  SGOperationManager.h
//  LTDevDemo
//
//  Created by litong on 2017/3/28.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SendGiftMo.h"

@interface SGOperationManager : NSObject

@property (nonatomic,strong) UIView *parentView;
@property (nonatomic,strong) SendGiftMo *model;

+ (instancetype)sharedManager;
/// 动画操作 : 需要onlyKey和回调
- (void)animWithOnlyKey:(NSString *)onlyKey model:(SendGiftMo *)model finishedBlock:(void(^)(BOOL result))finishedBlock;
/// 取消上一次的动画操作
- (void)cancelOperationWithLastOnlyKey:(NSString *)onlyKey;
- (void)clearData;
- (void)cancleAllOperation;

@end
