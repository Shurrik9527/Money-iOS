//
//  SGOperation.m
//  LTDevDemo
//
//  Created by litong on 2017/3/28.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "SGOperation.h"

#define KScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface SGOperation ()

@property (nonatomic, getter = isFinished)  BOOL finished;
@property (nonatomic, getter = isExecuting) BOOL executing;
@property (nonatomic,copy) void(^finishedBlock)(BOOL result,NSInteger finishCount);

@end


@implementation SGOperation

@synthesize finished = _finished;
@synthesize executing = _executing;

+ (instancetype)animOperationWithOnlyKey:(NSString *)onlyKey model:(SendGiftMo *)model finishedBlock:(void(^)(BOOL result,NSInteger finishCount))finishedBlock; {
    SGOperation *op = [[SGOperation alloc] init];
    op.sendGiftView = [[SendGiftView alloc] init];
    op.model = model;
    op.finishedBlock = finishedBlock;
    return op;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _executing = NO;
        _finished  = NO;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"SGOperation dealloc");
}

- (void)clearData {
    [self.listView removeAllSubView];
    [self.listView removeFromSuperview];
    [self.sendGiftView removeFromSuperview];

    self.sendGiftView = nil;
    self.listView = nil;
    self.model = nil;
    self.index = 0;
    self.onlyKey = nil;
}

- (void)start {
    // 添加到队列时调用
//    if (如果半天没消息或者取消了操作) {
//        return
//    }
//    self.executing = YES;
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        执行动画；
//        } completion:^(BOOL finished) {
//            self.finished = YES;
//            self.executing = NO;
//        }];
//    }];
    
    if ([self isCancelled]) {
        self.finished = YES;
        return;
    }
    self.executing = YES;
    
    WS(ws);
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [ws addOperationBlock];
    }];
    
}

- (void)addOperationBlock {
    self.sendGiftView.sendGiftMo = self.model;
    
//        // i ％ 2 控制最多允许出现几行
//        if (_index % 2) {
//             _sendGiftView.frame = CGRectMake(-self.listView.frame.size.width / 2, 300, self.listView.frame.size.width / 2, 40);
//        }else {
//             _sendGiftView.frame = CGRectMake(-self.listView.frame.size.width / 2, 230, self.listView.frame.size.width / 2, 40);
//        }
    
    _sendGiftView.originFrame = _sendGiftView.frame;
    [self.listView addSubview:_sendGiftView];
    
    WS(ws);
    [self.sendGiftView animateWithCompleteBlock:^(BOOL finished,NSInteger finishCount) {
        [ws animateFinish:finished finishCount:finishCount];
    }];
}

- (void)animateFinish:(BOOL)finished finishCount:(NSInteger)finishCount {
    self.finished = finished;
    self.finishedBlock(finished,finishCount);
}


#pragma mark -  手动触发 KVO
- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}
@end
