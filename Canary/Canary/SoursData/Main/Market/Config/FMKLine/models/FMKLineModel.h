//
//  FMKLineModel.h
//  golden_iphone
//
//  Created by dangfm on 15/6/11.
//  Copyright (c) 2015年 golden. All rights reserved.
//

#import <Foundation/Foundation.h>

// 线颜色
#define kStageLineColor [UIColor colorWithRed:113/255.0 green:117/255.0 blue:135/255.0 alpha:0.2]
// 舞台装饰线颜色
#define kStageMiddleLineColor HEXColor(0x343c48)
#define kStageLeftTextColor HEXColor(0x838898)
//HEXColor(0x343c48)                // 左边文本颜色

#define kStageRightTextColor HEXColor(0x343c48)
#define kStageBottomTextColor HEXColor(0x343c48)
#define kStageMiddleTextColor HEXColor(0x343c48)
#define kStageLineWidth 0.5                                         // 线宽度
#define kStageHorizontalLine 4                                      // 横线数量
#define kStageVerticalLine 3                                        // 竖线数量
#define kStageMinuteHorizontalLine 4                                // 横线数量
#define kStageMinuteVerticalLine 3                                  // 竖线数量
#define kStagePaddingTop 10
#define kStagePaddingBottom 10
#define kStageLeftTextFontSize 12
#define kStageRightTextFontSize 12
#define kStageIndexTextFontSize 9                                   // 指标文字大小
// K线颜色
#define kKLineUpColor HEXColor(0x3ae4ba)
#define kKLineDownColor HEXColor(0x3ae4ba)
#define kKLineGreyColor HEXColor(0x666666)
// 分时图
#define kStockMinuteLineColor [UIColor colorWithRed:54/255.0 green:90/255.0 blue:228/255.0 alpha:1]
#define kStockMinuteLinePathFillColor [UIColor colorWithRed:54/255.0 green:90/255.0 blue:228/255.0 alpha:0.2]

#define kStockMinuteLineMAColor  HEXColor(0xF5A245)


// MA线
#define kStockMA5Color [UIColor colorWithRed:234/255.0 green:139/255.0 blue:253/255.0 alpha:1] // 紫色
#define kStockMA10Color [UIColor colorWithRed:37/255.0 green:184/255.0 blue:215/255.0 alpha:1]                    // 蓝
#define kStockMA20Color [UIColor colorWithRed:243/255.0 green:146/255.0 blue:44/255.0 alpha:1]                    // 黄色
#define kStockMA60Color HEXColor(0x5386FF)
#define kStockMA120Color HEXColor(0xFF616F)

// EMA
#define kStockEMAColor HEXColor(0xFF0000)
// BOLL
#define kStockBOLL_UPColor HEXColor(0x1a9801)
#define kStockBOLL_MIDDLEColor HEXColor(0xfe4a87)
#define kStockBOLL_DOWNColor HEXColor(0xffbf00)
// MACD
#define kStockMACD_DIFColor [UIColor colorWithRed:37/255.0 green:184/255.0 blue:215/255.0 alpha:1]  //蓝

#define kStockMACD_DEAColor [UIColor colorWithRed:243/255.0 green:146/255.0 blue:44/255.0 alpha:1]  //棕
// KDJ
#define kStockKDJ_KColor HEXColor(0x1a9801)
#define kStockKDJ_DColor HEXColor(0xfe4a87)
#define kStockKDJ_JColor HEXColor(0xffbf00)
// RSI
#define kStockRSI_N1Color HEXColor(0x1a9801)
#define kStockRSI_N2Color HEXColor(0xfe4a87)
#define kStockRSI_N3Color HEXColor(0xffbf00)
// 虚线
#define kStockDottedLineColor HEXColor(0x469cff)

#define kStockPointsKey_KLineMinute @"kline_minute"

#define kStockPointsKey_KLineMinuteMA @"kline_minute_ma"


#define kStockPointsKey_KLine @"kline"
#define kStockPointsKey_SMA_N1 @"sma_n1"
#define kStockPointsKey_SMA_N2 @"sma_n2"
#define kStockPointsKey_SMA_N3 @"sma_n3"
#define kStockPointsKey_SMA_N4 @"sma_n4"
#define kStockPointsKey_SMA_N5 @"sma_n5"

#define kStockPointsKey_EMA @"ema"
#define kStockPointsKey_BOLL @"boll"
#define kStockPointsKey_MACD @"macd"
#define kStockPointsKey_KDJ @"kdj"
#define kStockPointsKey_RSI @"rsi"

// 天玑线EMA周期
#define kStockTianjiEMACycle_1 144
#define kStockTianjiEMACycle_2 169
#define kStockTianjiKDJ_K_Max 60
#define kStockTianjiKDJ_K_Min 40
#define kStockTianjiLine_DregColor HEXColor(0x326aaa)

#define kSmallLineWith 1.0

typedef enum{
    FMStockIndexType_MACD,
    FMStockIndexType_KDJ,
    FMStockIndexType_RSI,
    FMStockIndexType_SAM,
    FMStockIndexType_EMA,
    FMStockIndexType_BOLL
} FMKLineStockIndexType;

typedef enum {
    FMKLineScrollLeft,
    FMKLineScrollRight
}FMKLineScrollDirectionType;

typedef enum {
    FMKLineDirection_Horizontal,    // 横屏
    FMKLineDirection_Vertical       // 竖屏
} FMKLineDirectionStyle;

typedef enum {
    FMKLineTianjiLineType_None,     // 非天玑线
    FMKLineTianjiLineType_Shock,    // 震荡版
    FMKLineTianjiLineType_Trend     // 趋势版
} FMKLineTianjiLineType;

typedef enum {
    FMKLineTianjiLineDirection_None,    // 无方向
    FMKLineTianjiLineDirection_Up,      // 做多信号
    FMKLineTianjiLineDirection_Down     // 做空信号
} FMKLineTianjiLineDirection;

@class FMKLineModel;
@class DaysChartModel;
typedef void (^CalculationFinished)(FMKLineModel *model);
typedef void (^ZoomingBlock)(FMKLineModel *model,CGFloat scale);
#pragma mark 绘图结束后回调
typedef void (^DrawEndBlock)();

#pragma mark 十字线移动回调
typedef void (^CrossLineTipBlock)(DaysChartModel *model,BOOL isEnd);
#pragma mark 点击回调
typedef void (^TapBoxBlock)(void);

@interface FMKLineModel : NSObject

@property (nonatomic,assign) int type;                      // 0=分时图 1=5天分时图 2=k线图
@property (nonatomic,assign) int offsetLastStart;           // 上一个数据偏移起点
@property (nonatomic,assign) int offsetStart;               // 数据偏移起点
@property (nonatomic,assign) int offsetEnd;                 // 数据偏移终点
@property (nonatomic,assign) int offsetMiddle;              // 数据偏移中间点
@property (nonatomic,assign) int drawOffsetStart;           // 画K线数据偏移起点
@property (nonatomic,assign) int leftEmptyKline;            // 左边空的k线数量
@property (nonatomic,assign) int rightEmptyKline;           // 右边空的k线数量

@property (nonatomic,retain) NSString *startTime;           // 分时图开始时间
@property (nonatomic,retain) NSString *middleTime;          // 分时图中间时间
@property (nonatomic,retain) NSString *endTime;             // 分时图结束时间
@property (nonatomic,retain) NSString *stockCode;           // 品种编码
@property (nonatomic,retain) NSString *klineType;           //当前选中type(K线:1分,5分,15分...)

@property (nonatomic,assign) CGPoint scrollOffset;          // 滚动偏移距离

@property (nonatomic,assign) BOOL isChangeData;             // 是否变更过数据
@property (nonatomic,assign) BOOL isShowSide;               // 是否显示边框周边指示 默认否 不显示
@property (nonatomic,assign) BOOL isHideRight;              // 是否显示边框右边文字提示 默认否 不显示
@property (nonatomic,assign) BOOL isHideLeft;               // 是否显示边框左边文字提示 默认否 不显示
@property (nonatomic,assign) BOOL isStopDraw;               // 停止画图
@property (nonatomic,assign) BOOL isFinished;               // 是否画图完成
@property (nonatomic,assign) BOOL isShowMiddleLine;         // 是否画中间横线（主要针对分时图）
@property (nonatomic,assign) BOOL isZooming;                // 是否正在放大缩小
@property (nonatomic,assign) BOOL isShadow;                 // 是否显示阴影
@property (nonatomic,assign) BOOL isReset;                  // 是否重置
@property (nonatomic,assign) BOOL isHasLastTianji;          // 是否有了最后一个天玑线

@property (nonatomic,assign) CGFloat maxPrice;              // 最高价
@property (nonatomic,assign) CGFloat minPrice;              // 最低价
@property (nonatomic,assign) CGFloat bottomMaxPrice;        // 副图指标最高价
@property (nonatomic,assign) CGFloat bottomMinPrice;        // 副图指标最低价
@property (nonatomic,assign) CGFloat upMinutes;             // 上午分钟数
@property (nonatomic,assign) CGFloat downMinutes;           // 下午分钟数
@property (nonatomic,assign) CGFloat lastClosePrice;        // k线最后一个收盘价
@property (nonatomic,assign) CGFloat width;                 // 舞台宽度
@property (nonatomic,assign) CGFloat height;                // 舞台高度
@property (nonatomic,assign) CGFloat klineWidth;            // k线宽度
@property (nonatomic,assign) CGFloat klinePadding;          // k线相隔距离
@property (nonatomic,assign) CGFloat yestodayClosePrice;    // 昨日收盘价
@property (nonatomic,assign) CGFloat scale;                 // 放大缩小倍数


@property (nonatomic,retain) NSMutableDictionary *points;           // 坐标集合
@property (nonatomic,retain) NSMutableDictionary *allPoints;        // 坐标集合
@property (nonatomic,retain) NSMutableArray *prices;                // 价格集合
@property (nonatomic,retain) NSArray *times;                        // 时间集合
@property (nonatomic,retain) NSMutableArray *lastTianjiLine;        // 最后一个天玑线集合
@property (nonatomic,retain) NSArray *lastPoints;                   // 最后一个k线数据集合

@property (nonatomic,assign) FMKLineStockIndexType stockIndexType;           // k线图指标类型
@property (nonatomic,assign) FMKLineStockIndexType stockIndexBottomType;     // 副图指标类型

@property (nonatomic,assign) FMKLineScrollDirectionType scrollDerectionType; // 滚动方向
@property (nonatomic,assign) FMKLineDirectionStyle kLineDirectionStyle;      // 横竖屏状态
@property (nonatomic,assign) FMKLineTianjiLineType tianjiLineType;           // 天玑线类型

//k线接口返回数据   根据type格式化时间
+ (NSMutableArray *)objsWithList:(NSArray *)list type:(NSString *)type;
//k线接口返回数据   根据type格式化时间  兼容老版本
+ (NSDictionary *)dictWithList:(NSArray *)list type:(NSString *)type;




//外盘  分时图、K线   返回数据
+ (NSMutableArray *)objsWithList:(NSArray *)list;



@end
