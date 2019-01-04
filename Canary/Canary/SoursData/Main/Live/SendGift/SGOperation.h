//
//  SGOperation.h
//  LTDevDemo
//
//  Created by litong on 2017/3/28.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SendGiftView.h"

@interface SGOperation : NSOperation

@property (nonatomic,strong) SendGiftView *sendGiftView;
@property (nonatomic,strong) UIView *listView;
@property (nonatomic,strong) SendGiftMo *model;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,copy) NSString *onlyKey; // 新增用户唯一标示，记录礼物信息

// 回调参数增加了结束时礼物累计数
+ (instancetype)animOperationWithOnlyKey:(NSString *)onlyKey model:(SendGiftMo *)model finishedBlock:(void(^)(BOOL result,NSInteger finishCount))finishedBlock;

- (void)clearData;

@end
