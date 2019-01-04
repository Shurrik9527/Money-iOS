//
//  SGOperationManager.m
//  LTDevDemo
//
//  Created by litong on 2017/3/28.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "SGOperationManager.h"
#import "SGOperation.h"
#import "LiveDetailVCtrl.h"

#define kGiftCacheTime    3

@interface SGOperationManager ()

/// 队列1
@property (nonatomic,strong) NSOperationQueue *queue1;
/// 队列2
@property (nonatomic,strong) NSOperationQueue *queue2;
/// 操作缓存池
@property (nonatomic,strong) NSCache *operationCache;
/// 维护用户礼物信息
@property (nonatomic,strong) NSCache *userGigtInfos;

@property (nonatomic,strong) NSMutableArray *opKeys;

@property (nonatomic,assign) BOOL queue1Used;

@end


@implementation SGOperationManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.queue1Used = NO;
    }
    return self;
}

+ (instancetype)sharedManager {
//    static SGOperationManager *manager;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        manager = [[SGOperationManager alloc] init];
//    });
//    return manager;
    return [[SGOperationManager alloc] init];
}

/// 动画操作 : 需要onlyKey和回调
- (void)animWithOnlyKey:(NSString *)onlyKey model:(SendGiftMo *)model finishedBlock:(void(^)(BOOL result))finishedBlock {
    
    [self.opKeys addObject:onlyKey];
    
    // 在有用户礼物信息时
    if ([self.userGigtInfos objectForKey:onlyKey]) {
        // 如果有操作缓存，则直接累加，不需要重新创建op
        if ([self.operationCache objectForKey:onlyKey]!=nil) {
            SGOperation *op = [self.operationCache objectForKey:onlyKey];
            op.sendGiftView.giftCount = model.giftCount;
            [op.sendGiftView shakeNumberLabel];
            return;
        }
        WS(ws);
        // 没有操作缓存，创建op
        SGOperation *op = [SGOperation animOperationWithOnlyKey:onlyKey model:model finishedBlock:^(BOOL result,NSInteger finishCount) {
            // 回调
            if (finishedBlock) {
                finishedBlock(result);
            }
            [ws animFinishedWithOnlyKey:onlyKey finishCount:finishCount afterTime:kGiftCacheTime];
        }];
        
        // 注意：下面两句代码是和无用户礼物信息时不同的，其余的逻辑一样
        op.sendGiftView.animCount = [[self.userGigtInfos objectForKey:onlyKey] integerValue];
        op.model.giftCount = op.sendGiftView.animCount + 1;
        
        op.listView = self.parentView;
        op.index = [self onlyKeyLengthMod:onlyKey];
        
        // 将操作添加到缓存池
        [self.operationCache setObject:op forKey:onlyKey];
        
        // 根据用户ID 控制显示的位置
        if ([self onlyKeyLengthMod:onlyKey]) {
            
            if (op.model.giftCount != 0) {
                op.sendGiftView.frame  = [self rectWithIdx:1];
                op.sendGiftView.originFrame = op.sendGiftView.frame;
                [self.queue1 addOperation:op];
            }
        } else {
            
            if (op.model.giftCount != 0) {
                
                op.sendGiftView.frame  = [self rectWithIdx:0];
                op.sendGiftView.originFrame = op.sendGiftView.frame;
                [self.queue2 addOperation:op];
            }
        }
    }
    
    // 在没有用户礼物信息时
    else {
        // 如果有操作缓存，则直接累加，不需要重新创建op
        if ([self.operationCache objectForKey:onlyKey]!=nil) {
            SGOperation *op = [self.operationCache objectForKey:onlyKey];
            op.sendGiftView.giftCount = model.giftCount;
            [op.sendGiftView shakeNumberLabel];
            return;
        }
        WS(ws);
        SGOperation *op = [SGOperation animOperationWithOnlyKey:onlyKey model:model finishedBlock:^(BOOL result,NSInteger finishCount) {
            // 回调
            if (finishedBlock) {
                finishedBlock(result);
            }
            [ws animFinishedWithOnlyKey:onlyKey finishCount:finishCount afterTime:0.2];
        }];
        op.listView = self.parentView;
        op.index = [self onlyKeyLengthMod:onlyKey];
        // 将操作添加到缓存池
        [self.operationCache setObject:op forKey:onlyKey];
        
        if ([self onlyKeyLengthMod:onlyKey]) {
            
            if (op.model.giftCount != 0) {
                op.sendGiftView.frame  = [self rectWithIdx:1];
                op.sendGiftView.originFrame = op.sendGiftView.frame;
                [self.queue1 addOperation:op];
            }
        }else {
            
            if (op.model.giftCount != 0) {
                op.sendGiftView.frame  = [self rectWithIdx:0];
                op.sendGiftView.originFrame = op.sendGiftView.frame;
                [self.queue2 addOperation:op];
            }
        }
        
    }
    
}


- (CGRect)rectWithIdx:(NSInteger)idx {
    CGFloat hh = [LiveDetailVCtrl playViewHeight] + LTAutoW(75);
    CGFloat y = (idx > 0) ? hh+0.75*SendGiftViewH : hh;
    CGRect rect = CGRectMake(-self.parentView.frame.size.width / 2, y , self.parentView.frame.size.width / 2, SendGiftViewH);
    return rect;
}


- (void)animFinishedWithOnlyKey:(NSString *)onlyKey finishCount:(NSInteger)finishCount afterTime:(NSInteger)afterTime {
    // 将礼物信息数量存起来
    [self.userGigtInfos setObject:@(finishCount) forKey:onlyKey];
    // 动画完成之后,要移除动画对应的操作
    [self.operationCache removeObjectForKey:onlyKey];
    // 延时删除用户礼物信息
    WS(ws);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(afterTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ws.userGigtInfos removeObjectForKey:onlyKey];
    });
}

- (NSInteger)onlyKeyLengthMod:(NSString *)onlyKey {
    NSInteger mod = [onlyKey length] % 2;
    return mod;
}

/// 取消上一次的动画操作 暂时没用到
- (void)cancelOperationWithLastOnlyKey:(NSString *)onlyKey {
    // 当上次为空时就不执行取消操作 (第一次进入执行时才会为空)
    if (onlyKey!=nil) {
        [[self.operationCache objectForKey:onlyKey] cancel];
    }
}

- (void)cancleAllOperation {
    for (NSString *onlyKey in _opKeys) {
        SGOperation *op = [_operationCache objectForKey:onlyKey];
        op.sendGiftView.hidden = YES;
        [op.sendGiftView removeFromSuperview];
        
        [self cancelOperationWithLastOnlyKey:onlyKey];
        [self.operationCache removeObjectForKey:onlyKey];
        [self.userGigtInfos removeObjectForKey:onlyKey];
    }
    
    [_queue1 cancelAllOperations];
    [_queue2 cancelAllOperations];
    [_operationCache removeAllObjects];
    [_userGigtInfos removeAllObjects];
    [_opKeys removeAllObjects];
    
    _queue1 = nil;
    _queue2  =nil;
    _operationCache = nil;
    _userGigtInfos = nil;
    _opKeys = nil;
}

- (void)clearData {
    
    for (NSString *onlyKey in _opKeys) {
        SGOperation *op = [_operationCache objectForKey:onlyKey];
        [op clearData];
        [op cancel];
        [self.operationCache removeObjectForKey:onlyKey];
        [self.userGigtInfos removeObjectForKey:onlyKey];
    }

    
    [_queue1 cancelAllOperations];
    [_queue2 cancelAllOperations];
    [_operationCache removeAllObjects];
    [_userGigtInfos removeAllObjects];
    [_opKeys removeAllObjects];
    
    _queue1 = nil;
    _queue2  =nil;
    _operationCache = nil;
    _userGigtInfos = nil;
    _opKeys = nil;
}





#pragma mark - 属性


- (NSOperationQueue *)queue1 {
    if (_queue1==nil) {
        _queue1 = [[NSOperationQueue alloc] init];
        _queue1.maxConcurrentOperationCount = 1;
        
    }
    return _queue1;
}

- (NSOperationQueue *)queue2 {
    if (_queue2==nil) {
        _queue2 = [[NSOperationQueue alloc] init];
        _queue2.maxConcurrentOperationCount = 1;
    }
    return _queue2;
}

- (NSCache *)operationCache {
    if (_operationCache==nil) {
        _operationCache = [[NSCache alloc] init];
    }
    return _operationCache;
}

- (NSCache *)userGigtInfos {
    if (_userGigtInfos == nil) {
        _userGigtInfos = [[NSCache alloc] init];
    }
    return _userGigtInfos;
}

- (NSMutableArray *)opKeys {
    if (_opKeys == nil) {
        _opKeys = [NSMutableArray array];
    }
    return _opKeys;
}

@end
