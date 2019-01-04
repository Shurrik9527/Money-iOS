//
//  LiveDetailVCtrl.h
//  ixit
//
//  Created by litong on 16/10/26.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "BaseVCtrl.h"

#import "LTSocketServe.h"

#import "DataProvider.h"
#import "ChartroomVCtrl.h"
#import "LiveScrollView.h"
#import "SegmentView.h"

#import "RechargeVCtrl.h"
#import "QuickDealListView.h"
#import "SelectProductView.h"
#import "BuyView.h"
#import "SellProductView.h"
#import "LiveNoticeView.h"
#import "LiveQuotationView.h"


#import "GiftListView.h"
#import "LiveMO.h"
#import "SGOperationManager.h"


/** 第一次进页面 请求网络失败 最大访问次数 */
#define kMaxReq     5

@interface LiveDetailVCtrl : BaseVCtrl<NIMChatroomManagerDelegate>

@property (nonatomic,strong) GiftListView *giftListView;
@property (nonatomic,strong) LiveGiftListMO *liveGiftListMO;
@property (nonatomic,assign) BOOL needHideGift;
@property (nonatomic,strong) LiveMO *liveModel;
@property (nonatomic,assign) BOOL needShow;
@property (nonatomic,strong) SGOperationManager *giftManager;


#pragma mark - 以下声明 category 中需要使用


- (void)backAction;
- (void)startSocketServe;

@property (nonatomic, strong)LiveNoticeView *tips;//消息tips

@property (nonatomic,assign) CGFloat tipsViewY;
/** 文字直播&聊天室 切换bar */
@property (nonatomic,strong) SegmentView *segmentView;
+ (CGFloat)playViewHeight;
/** 文字直播&聊天室 ScrollView  */
@property (nonatomic,strong) LiveScrollView *scView;
@property (nonatomic,strong) ChartroomVCtrl *chartroomVCtrl;
@property (nonatomic,strong) NIMChatroomMember *myChatroomInfo;
@property (nonatomic,assign) BOOL isChatUser;//是否已经是该聊天室会员
/** 轮询黑名单Timer */
@property (nonatomic, strong)NSTimer *myTimer;

/** 直播室能否发图片 */
@property (nonatomic,assign) BOOL canSendPic;
@property (nonatomic,assign) BOOL firstHoldList;//

/** 视频下方银、油价格条 */
@property (nonatomic,strong) LiveQuotationView *priceTipView;


/** 播放器以下内容的父view */
@property (nonatomic,strong) UIView *contentView;


//快速建仓、平仓
@property (nonatomic,strong) QuickDealListView *quickDealView;
/** 选择产品 */
@property (nonatomic,strong) SelectProductView *selectProductView;
@property (nonatomic,assign) CGFloat selectProductViewY;
/**  */
@property (nonatomic,strong) Quotation *quotation;
//快速建仓
@property(strong,nonatomic)BuyView *buyView;
@property (nonatomic,assign) CGFloat buyProductViewY;
//快速平仓
@property(strong,nonatomic)SellProductView *sellProductView;
@property (nonatomic,assign) CGFloat sellProductViewY;

/** 持仓轮询timer */
@property (nonatomic,strong) NSTimer *holdListTimer;
@property (nonatomic,strong) NSArray *holdList;
@property (nonatomic,strong) NSArray *productList;


-(void)showPersonNum:(NSInteger)num;//设置聊天室人数

@end
