//
//  WeiPanMarketViewController.h
//  ixit
//
//  Created by yu on 15/8/27.
//  Copyright (c) 2015年 ixit. All rights reserved.
//

#import "BaseVCtrl.h"
#import "FMKLineChart.h"
#import "QuotationDetailModel.h"
#import "RequestCenter.h"
#import "KLineHeaderView.h"
#import "WeiPanKChartNavigationView.h"
#import "SelfStock.h"
#import "MJRefresh.h"
#import "TransformImageView.h"
#import "KLineSelectIndexHView.h"
#import "KLineOtherIndexView.h"
#import "DaysChartModel.h"
#import "FMKLineModel.h"
#import "FMKLineChart.h"
#import "KLineHorizontalIndexNavView.h"
#import "LoginVCtrl.h"
#import "DealVCtrl.h"
#import "ViewController.h"
#import "DealVCtrl.h"
#import "KLineSMAVerticalView.h"
#import "KLineMACDVerticalView.h"
#import "WeiPanPriceView.h"
#import "RechargeVCtrl.h"
#import "LTSocketServe.h"
#import "Quotation.h"
#import "PopTableView.h"
#import "PushRemindModel.h"
#import "PushRemindConfigModel.h"
#import "MyRemind.h"
#import "AddRemind.h"
#import "PushRemindConfigModel.h"
#import "KChatLineFootView.h"


#define kRefreshTime 2
#define kOtherRefreshTime        5      //轮询刷新时间 单位秒

#define kLineChartView_LeftNavViewWidth 45

/** 微盘详情 */
@interface WeiPanMarketViewController : BaseVCtrl
{
    //轮循请求获取线图数据
    BOOL _isRequestFinish;
    BOOL _isTimeLoop;
        
    //标记
    NSInteger sma_Index;
    NSInteger macd_Index;
    NSInteger refreshNum;
}

@property(strong,nonatomic)NSTimer *timer;
@property (copy,nonatomic)NSString * price;//上一个界面价格
@property (copy,nonatomic)NSString * change;//上一个页面的涨跌值
@property (copy,nonatomic)NSString * changeCHa;//   上一个页面的涨跌百分比
@property (copy,nonatomic)NSString * timeStr;//上页面时间
@property (copy,nonatomic)NSString * dataStr;//上页面日期
@property (copy,nonatomic)NSString *stops_level;//浮动点

@property(nonatomic,copy)NSString * open;
@property (nonatomic,copy)NSString * high;
@property (nonatomic,copy)NSString * low;
@property (nonatomic,copy)NSString *close;
@property (nonatomic,assign)NSInteger  digit;
/** 日线图表 */
@property(strong,nonatomic) FMKLineChart *dayschart;
/** 分线图表 */
@property(strong,nonatomic)FMKLineChart *minutechart;
/** 线图模型 */
@property(strong,nonatomic)FMKLineModel *model;
/** 分线图模型 */
@property(strong,nonatomic)FMKLineModel *minutemodel;

/**  */
@property(copy,nonatomic) NSString *lastType;

@property(strong,nonatomic) UITableView *tableview;
@property(strong,nonatomic) KLineHeaderView *headerview;
@property(strong,nonatomic) KChatLineFootView *footerview;


//横屏产品分时导航栏
@property(strong,nonatomic) WeiPanKChartNavigationView *klineNavView;
@property(strong,nonatomic) KLineSelectIndexHView *horizontalHeaderView;
//横屏竖直指标导航栏
@property(strong,nonatomic) KLineHorizontalIndexNavView *klineHorizontalIndexNavView;
//竖屏下的指标view
@property(strong,nonatomic) KLineSMAVerticalView *kind_SMA_View;
@property(strong,nonatomic) KLineMACDVerticalView *kind_MACD_View;

@property(copy,nonatomic) NSString *titler;
@property(strong,nonatomic) UIView *klinebox;
@property(copy,nonatomic) NSString *excode;
@property(copy,nonatomic) NSString *code;
@property(copy,nonatomic) NSString *type;//什么类型的图几分钟1分或者5分
@property(copy,nonatomic) NSString *weipanId;
@property (copy,nonatomic) NSString * code_cn;
//报价详情model
@property(strong,nonatomic) QuotationDetailModel *stockDish;
@property(strong,nonatomic) NSDictionary *lastData;
@property(strong,nonatomic) TransformImageView *transform;
//旋转按钮
@property(strong,nonatomic) UIButton *transBtn;
@property(strong,nonatomic) UIButton *moreBtn;

@property(strong,nonatomic) UIButton *liveBtn;



//更多按钮弹框
@property(strong,nonatomic)PopTableView * morePopView;

@property(strong,nonatomic)NSMutableArray *productList;
@property(strong,nonatomic)NSMutableArray *priceList;
@property(strong,nonatomic)NSMutableArray *candleList;
@property(strong,nonatomic)NSMutableArray *remindList;//推送提醒列表
@property (nonatomic,strong) NSMutableArray *holdList;//持仓列表

@property (nonatomic,strong) MyRemind *myRemindView;
@property (nonatomic,strong) AddRemind *addRemindView;
@property (nonatomic,strong) PushRemindConfigModel *remindConfigModel;

@property (nonatomic,assign) FMKLineDirectionStyle fmKlineDirectionStyle;

#pragma mark - init
- (instancetype)initWithCode:(NSString*)code exCode:(NSString*)excode title:(NSString*)title;
-(void)initSMAKindView;
-(void)initMACDKindView;
-(void)createHorizontalIndexNavViews;
#pragma mark - actions
-(void)changeViewDirection;
//b-(void)updateHeaderView:(BOOL)isScroll;
- (void)reqTickChartIsSuccess:(BOOL)bl;
@end
