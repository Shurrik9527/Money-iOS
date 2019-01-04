//
//  WebVCtrl.h
//  Canary
//
//  Created by litong on 2017/5/12.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BaseVCtrl.h"


typedef void(^WebJSShareSuccessBlock)(void);

@interface WebVCtrl : BaseVCtrl

@property (nonatomic,copy) WebJSShareSuccessBlock webJSShareSuccessBlock;

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *redirectUrlStr;
@property (nonatomic, copy) void (^successBack)();
@property (nonatomic, copy) void (^failureBack)();

//YES:微信朋友圈&微信好友  NO:微信朋友圈
@property (nonatomic,assign) BOOL shareHasWechatTimelineAndWechatSession;

/** 是否开启返回上一个网页，默认不开启  */
@property (nonatomic,assign) BOOL useGoBack;

- (instancetype)initWithTitle:(NSString*)title url:(NSURL*)url;
- (instancetype)initWithTitle:(NSString*)title url:(NSURL*)url returnType:(BackType)returnType;
//显示Nav右广告按钮
- (instancetype)initWithADTitle:(NSString*)title url:(NSURL*)url;


- (void)configBackType:(BackType)backType;

@end
