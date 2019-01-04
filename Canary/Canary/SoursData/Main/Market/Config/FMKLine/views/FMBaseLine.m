//
//  FMBaseLine.m
//  golden_iphone
//
//  Created by dangfm on 15/6/11.
//  Copyright (c) 2015年 golden. All rights reserved.
//

#import "FMBaseLine.h"
#import "DaysChartModel.h"
#import <QuartzCore/CATiledLayer.h>
@interface FMBaseLine(){
    FMKLineModel *_model;
    NSArray *_points;
    NSArray *_nextPoints;
    UIColor *_lineColor;
    NSString *_key;
    NSMutableArray *_lines;
    NSOperationQueue *_queue;
    UIImageView *_baseK_left;
    UIImageView *_baseK_right;
    FMBaseView *_dateViews;
    BOOL _first_SMA_N1;
    BOOL _first_SMA_N2;
    BOOL _first_SMA_N3;
    BOOL _first_SMA_N4;
    BOOL _first_SMA_N5;

    BOOL _first_EMA;
    BOOL _first_BOLL_DOWN;
    BOOL _first_BOLL_MIDDLE;
    BOOL _first_BOLL_UP;
    BOOL _first_MACD_DIF;
    BOOL _first_MACD_DEA;
    
    BOOL _first_KDJ_K;
    BOOL _first_KDJ_D;
    BOOL _first_KDJ_J;
    BOOL _first_RSI_N1;
    BOOL _first_RSI_N2;
    BOOL _first_RSI_N3;
    
    BOOL _first_Minute;
    BOOL _first_Minute1;

    UIImage *_image;
    UIImage *_tianjiIcon_up;
    UIImage *_tianjiIcon_down;
    UIImageView *_tianji;
    CGFloat _lastX;
    
    
}
@property (nonatomic,strong) NSMutableArray * points1;
@end

@implementation FMBaseLine



#pragma mark -------------------------------自定义方法-----------------------------
-(void)dealloc
{
    _model = nil;
    _points = nil;
    _lineColor = nil;
}
+ layerClass
{
    return [CAShapeLayer class];
}
-(void)drawRect:(CGRect)rect
{
    //NSLog(@"draw start.....");
    //CGRect rect = self.bounds;
    //UIGraphicsBeginImageContext(rect.size);
    //UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self createLayerWithContext:context];
    
    //CGContextFillRect(context, rect);
    //UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //UIGraphicsEndImageContext();
    //[image drawLayer:self.layer inContext:context];
    //NSLog(@"draw end.....");
}
#pragma mark 初始化参数
-(void)initSet
{
    self.clearsContextBeforeDrawing = NO;
    //self.userInteractionEnabled = YES;
    _queue = [[NSOperationQueue alloc] init];
    _lines = [NSMutableArray new];
    
    _first_SMA_N1 = NO;
   
    _tianjiIcon_up =  [UIImage imageNamed:@"kline/tianjix_icon_up"];
    _tianjiIcon_down =  [UIImage imageNamed:@"kline/tianjix_icon_down"];
    
 
}

-(void)updateWithModel:(FMKLineModel *)model{
    _model = model;
    if (_model.points.count<=0) {
        return;
    }
    _points = [_model.points objectForKey:_key];

    if ([[_points class] isSubclassOfClass:[NSArray class]]) {
        [self setNeedsDisplay];
    }

}

#pragma mark K线初始化并画图
-(instancetype)initWithFrame:(CGRect)frame Model:(FMKLineModel*)model PointKey:(NSString*)key
{
    if (self==[super initWithFrame:frame])
    {
        _model = model;
        _key = key;
        _points = [_model.points objectForKey:key];
        _isBlack=NO;
        // 初始化
        [self initSet];
        [self setNeedsDisplay];
    }
    return self;
}

#pragma mark 生成一根k线并缓存
-(void)drawK:(NSArray*)point{
    if (point.count<=0) {
        return;
    }
    if (!_baseK_left) {
        _baseK_left = [[UIImageView alloc] initWithFrame:self.bounds];
        _baseK_left.backgroundColor = LTClearColor;
        _baseK_left.clearsContextBeforeDrawing = NO;
        [self addSubview:_baseK_left];
       
    }
    
    _baseK_left.frame = self.bounds;
    
    [self imageWithPoint:point Direction:FMKLineScrollLeft FinishedBlock:^(UIImage *image){
        //NSLog(@"draw finished");
        //_baseK_left.image = image;
        _model.isFinished = YES;
    }];

}

#pragma mark 生成分时图并缓存
-(void)drawMinute:(NSArray*)point
{
    if (point.count<=0)
    {
        return;
    }
    
    if (!_baseK_right)
    {
        _baseK_right = [[UIImageView alloc] initWithFrame:self.bounds];
        _baseK_right.backgroundColor = LTClearColor;
        _baseK_right.clearsContextBeforeDrawing = NO;
        [self addSubview:_baseK_right];
    }
    _baseK_right.frame = self.bounds;
    [self imageWithPoint:point Direction:FMKLineScrollRight FinishedBlock:^(UIImage *image)
    {
        _baseK_right.image = image;
    }];
    
    
}

-(void)createLayerWithContext:(CGContextRef)context
{
    CGMutablePathRef path_SMA_N1 = CGPathCreateMutable();
    CGMutablePathRef path_SMA_N2 = CGPathCreateMutable();
    CGMutablePathRef path_SMA_N3 = CGPathCreateMutable();
    CGMutablePathRef path_SMA_N4 = CGPathCreateMutable();
    CGMutablePathRef path_SMA_N5 = CGPathCreateMutable();

    CGMutablePathRef path_EMA = CGPathCreateMutable();
    CGMutablePathRef path_BOLL_DOWN = CGPathCreateMutable();
    CGMutablePathRef path_BOLL_MIDDLE = CGPathCreateMutable();
    CGMutablePathRef path_BOLL_UP = CGPathCreateMutable();
    CGMutablePathRef path_MACD_DIF = CGPathCreateMutable();
    CGMutablePathRef path_MACD_DEA = CGPathCreateMutable();
    CGMutablePathRef path_KDJ_K = CGPathCreateMutable();
    CGMutablePathRef path_KDJ_D = CGPathCreateMutable();
    CGMutablePathRef path_KDJ_J = CGPathCreateMutable();
    CGMutablePathRef path_RSI_N1 = CGPathCreateMutable();
    CGMutablePathRef path_RSI_N2 = CGPathCreateMutable();
    CGMutablePathRef path_RSI_N3 = CGPathCreateMutable();
    CGMutablePathRef path_Minute = CGPathCreateMutable();
    CGMutablePathRef path_MinuteMA = CGPathCreateMutable();

    // 消除锯齿
    CGContextSetShouldAntialias(context, NO);
    
    _first_SMA_N1 = NO;
    _first_SMA_N2 = NO;
    _first_SMA_N3 = NO;
    _first_SMA_N4 = NO;
    _first_SMA_N5 = NO;

    _first_EMA = NO;
    _first_BOLL_DOWN = NO;
    _first_BOLL_MIDDLE = NO;
    _first_BOLL_UP = NO;
    _first_MACD_DEA = NO;
    _first_MACD_DIF = NO;
    _first_Minute = NO;
    _first_Minute1 = NO;

    _first_KDJ_K = NO;
    _first_KDJ_D = NO;
    _first_KDJ_J = NO;
    _first_RSI_N1 = NO;
    _first_RSI_N2 = NO;
    _first_RSI_N3 = NO;
    
    int i=_model.offsetStart;
    CGPoint topPoint,bottomPoint;
    CGPoint tempPoint;
    int dateSub = 20;
    if (_model.klineWidth>5) {
        dateSub = 20;
    }
    if (_model.klineWidth<3) {
        dateSub = 30;
    }
    [self removeDateViews];
    NSArray *p;
    NSArray *nextP;
    CGPoint lastClosePoint;
    int j = 0;
    if(_points.count==0)
    {
        p = nil;
        _model.isFinished = YES;
        _model.isReset = NO;
        return;
    }
    
    for (id ps in _points)
    {
        
        if ([_key isEqualToString:kStockPointsKey_KLineMinute])
        {
            tempPoint = CGPointFromString(ps);
            // 分时图
            [self addPath:context Path:path_Minute Point:tempPoint IsFirst:&_first_Minute];
            
        }
        else
        {
            p = (NSArray*)ps;
            int nextTwoIndex = j+2;
            if (nextTwoIndex<_points.count)
            {
                nextP = (NSArray*)[_points objectAtIndex:nextTwoIndex];
                if (_model.tianjiLineType==FMKLineTianjiLineType_Trend)
                {
                    nextP = p;
                }
            }
            tempPoint = CGPointFromString([p firstObject]);
            if (tempPoint.y>0)
            {
                lastClosePoint = CGPointFromString([p objectAtIndex:3]);
            }
            // 画日期线
            if (i%dateSub==0) {
                topPoint = CGPointMake(tempPoint.x, 0.5);
                bottomPoint = CGPointMake(tempPoint.x, _model.height/3*2-_dateViews.frame.size.height);
                [self drawLine:context Color:kStageLineColor LineType:0 Width:kStageLineWidth StartPoint:topPoint EndPoint:bottomPoint];
                topPoint = CGPointMake(tempPoint.x, _model.height/3*2+16);
                bottomPoint = CGPointMake(tempPoint.x, _model.height-0.5);
                [self drawLine:context Color:kStageLineColor LineType:0 Width:kStageLineWidth StartPoint:topPoint EndPoint:bottomPoint];
                //绘制非分时底部的时间图
                [self createDateViews:topPoint.x Model:[p objectAtIndex:(p.count-2)]];
            }
            // k线图
            [self drawOneKLine:context Point:p KlineWidth:_model.klineWidth];
            // 画天玑线
            if (_model.lastTianjiLine && _model.tianjiLineType==FMKLineTianjiLineType_Trend)
            {
                if ([[_model.lastTianjiLine firstObject] intValue]!=j)
                {
                    [self createThreeCornerWithContext:context Point:p];
                }
            }
            else
            {
                [self createThreeCornerWithContext:context Point:p];
            }
            
            // 画最后天玑线图标
            [self createLastTianjiLineWithContext:context Point:p NextPoints:nextP];
            
            if (_model.stockIndexType==FMStockIndexType_SAM)
            {
                [self addPath:context Path:path_SMA_N1 Points:p Index:4 IsFirst:&_first_SMA_N1 ];
                [self addPath:context Path:path_SMA_N2 Points:p Index:5 IsFirst:&_first_SMA_N2 ];
                [self addPath:context Path:path_SMA_N3 Points:p Index:6 IsFirst:&_first_SMA_N3 ];
                [self addPath:context Path:path_SMA_N4 Points:p Index:7 IsFirst:&_first_SMA_N4 ];
                [self addPath:context Path:path_SMA_N5 Points:p Index:8 IsFirst:&_first_SMA_N5 ];

            }
            
            if (_model.stockIndexType==FMStockIndexType_EMA)
            {
                [self addPath:context Path:path_EMA Points:p Index:9 IsFirst:&_first_EMA ];
            }
            
            if (_model.stockIndexType==FMStockIndexType_BOLL)
            {
                [self addPath:context Path:path_BOLL_DOWN Points:p Index:10 IsFirst:&_first_BOLL_DOWN ];
                [self addPath:context Path:path_BOLL_MIDDLE Points:p Index:11 IsFirst:&_first_BOLL_MIDDLE ];
                [self addPath:context Path:path_BOLL_UP Points:p Index:12 IsFirst:&_first_BOLL_UP ];
            }
            
            if (_model.stockIndexBottomType==FMStockIndexType_MACD)
            {
                [self drawOneKLine:context Point:[p objectAtIndex:15] KlineWidth:_model.klineWidth];
                [self addPath:context Path:path_MACD_DIF Points:p Index:13 IsFirst:&_first_MACD_DIF ];
                [self addPath:context Path:path_MACD_DEA Points:p Index:14 IsFirst:&_first_MACD_DEA ];
            }
            if (_model.stockIndexBottomType==FMStockIndexType_KDJ)
            {
                [self addPath:context Path:path_KDJ_K Points:p Index:16 IsFirst:&_first_KDJ_K];
                [self addPath:context Path:path_KDJ_D Points:p Index:17 IsFirst:&_first_KDJ_D];
                [self addPath:context Path:path_KDJ_J Points:p Index:18 IsFirst:&_first_KDJ_J];
            }
            if (_model.stockIndexBottomType==FMStockIndexType_RSI)
            {
                [self addPath:context Path:path_RSI_N1 Points:p Index:19 IsFirst:&_first_RSI_N1];
                [self addPath:context Path:path_RSI_N2 Points:p Index:20 IsFirst:&_first_RSI_N2];
                [self addPath:context Path:path_RSI_N3 Points:p Index:21 IsFirst:&_first_RSI_N3];
            }
        }
        j++;
        i++;
    }
    if ([_key isEqualToString:kStockPointsKey_KLineMinute]) {
        if (!_points1) {
            _points1=[[NSMutableArray alloc]init];
        }else{
            if (_points1.count>0) {
                [_points1 removeAllObjects];
            }
        }
        NSArray *arr=[_model.points objectForKey:kStockPointsKey_KLineMinuteMA];
        for (int i = 0; i<arr.count; i++) {
            [_points1 addObject:arr[i]];
        }
        for (id ps in _points1) {
            tempPoint = CGPointFromString(ps);
            // 分时图
            [self addPath:context Path:path_MinuteMA Point:tempPoint IsFirst:&_first_Minute1];
        }
    }
    // 连线
    //把绘制直线的绘图信息保存到图形上下文中
    if ([_key isEqualToString:kStockPointsKey_KLineMinute])
    {
        CGContextSetShouldAntialias(context, YES);
        [self drawMorePointGradientWithContext:context WithPoints:_points color:kStockMinuteLinePathFillColor];
        CGContextSetAlpha(context, 1);
        CGContextSetStrokeColorWithColor(context, kStockMinuteLineColor.CGColor);
        CGContextAddPath(context, path_Minute);
        CGPathCloseSubpath(path_Minute);

        //CGContextStrokePath(context);
        CGContextDrawPath(context, kCGPathStroke);
        
        
        if (_points1.count>0) {
            CGContextSetShouldAntialias(context, YES);
            CGContextSetAlpha(context, 1);
            CGContextSetStrokeColorWithColor(context, kStockMinuteLineMAColor.CGColor);
            CGContextAddPath(context, path_MinuteMA);
            CGPathCloseSubpath(path_MinuteMA);
            CGContextDrawPath(context, kCGPathStroke);
        }
        
        // 画虚线
        [self drawLine:context Color:kStageMiddleLineColor LineType:1 Width:0.5 StartPoint:CGPointMake(0, _model.height/2+0.5) EndPoint:CGPointMake(_model.width, _model.height/2+0.5)];

    }
    else
    {
        CGContextSetShouldAntialias(context, YES);
        CGContextSetLineWidth(context, kSmallLineWith);
        if (_model.stockIndexType==FMStockIndexType_SAM) {
            CGContextAddPath(context, path_SMA_N1);
            CGContextSetStrokeColorWithColor(context, kStockMA5Color.CGColor);
            CGContextStrokePath(context);
            
            CGContextAddPath(context, path_SMA_N2);
            CGContextSetStrokeColorWithColor(context, kStockMA10Color.CGColor);
            CGContextStrokePath(context);
            
            CGContextAddPath(context, path_SMA_N3);
            CGContextSetStrokeColorWithColor(context, kStockMA20Color.CGColor);
            CGContextStrokePath(context);
            
            if (!([_model.klineType isEqualToString:@"1"] | [_model.klineType isEqualToString:@"2"])) {
                CGContextAddPath(context, path_SMA_N4);
                CGContextSetStrokeColorWithColor(context, kStockMA60Color.CGColor);
                CGContextStrokePath(context);
                
                CGContextAddPath(context, path_SMA_N5);
                CGContextSetStrokeColorWithColor(context, kStockMA120Color.CGColor);
                CGContextStrokePath(context);
            }

        }
        if (_model.stockIndexType==FMStockIndexType_EMA)
        {
            CGContextAddPath(context, path_EMA);
            CGContextSetStrokeColorWithColor(context, kStockEMAColor.CGColor);
            CGContextStrokePath(context);
        }
        if (_model.stockIndexType==FMStockIndexType_BOLL)
        {
            CGContextAddPath(context, path_BOLL_DOWN);
            CGContextSetStrokeColorWithColor(context, kStockBOLL_DOWNColor.CGColor);
            CGContextStrokePath(context);
            
            CGContextAddPath(context, path_BOLL_MIDDLE);
            CGContextSetStrokeColorWithColor(context, kStockBOLL_MIDDLEColor.CGColor);
            CGContextStrokePath(context);
            
            CGContextAddPath(context, path_BOLL_UP);
            CGContextSetStrokeColorWithColor(context, kStockBOLL_UPColor.CGColor);
            CGContextStrokePath(context);
        }
        
        if (_model.stockIndexBottomType==FMStockIndexType_MACD)
        {
            CGContextAddPath(context, path_MACD_DIF);
            CGContextSetStrokeColorWithColor(context, kStockMACD_DIFColor.CGColor);
            CGContextStrokePath(context);
            
            CGContextAddPath(context, path_MACD_DEA);
            CGContextSetStrokeColorWithColor(context, kStockMACD_DEAColor.CGColor);
            CGContextStrokePath(context);
        }
        if (_model.stockIndexBottomType==FMStockIndexType_KDJ) {
            CGContextAddPath(context, path_KDJ_K);
            CGContextSetStrokeColorWithColor(context, kStockKDJ_KColor.CGColor);
            CGContextStrokePath(context);
            
            CGContextAddPath(context, path_KDJ_D);
            CGContextSetStrokeColorWithColor(context, kStockKDJ_DColor.CGColor);
            CGContextStrokePath(context);
            
            CGContextAddPath(context, path_KDJ_J);
            CGContextSetStrokeColorWithColor(context, kStockKDJ_JColor.CGColor);
            CGContextStrokePath(context);
        }
        if (_model.stockIndexBottomType==FMStockIndexType_RSI)
        {
            CGContextAddPath(context, path_RSI_N1);
            CGContextSetStrokeColorWithColor(context, kStockRSI_N1Color.CGColor);
            CGContextStrokePath(context);
            
            CGContextAddPath(context, path_RSI_N2);
            CGContextSetStrokeColorWithColor(context, kStockRSI_N2Color.CGColor);
            CGContextStrokePath(context);
            
            CGContextAddPath(context, path_RSI_N3);
            CGContextSetStrokeColorWithColor(context, kStockRSI_N3Color.CGColor);
            CGContextStrokePath(context);
        }
        // 最后一个k线的虚线
        //[self drawLine:context Color:kStockDottedLineColor LineType:1 Width:1 StartPoint:CGPointMake(0, lastClosePoint.y) EndPoint:CGPointMake(_model.width+2, lastClosePoint.y)];
        
    }
    p = nil;
    _model.isFinished = YES;
    _model.isReset = NO;
}

- (void)imageWithPoint:(NSArray*)point Direction:(FMKLineScrollDirectionType)scrollDirectionType FinishedBlock:(void(^)(UIImage *image))finishBlock
{
    //NSLog(@"draw start.....");
    CGRect rect = self.bounds;
    //UIGraphicsBeginImageContext(rect.size);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self createLayerWithContext:context];
    
    //CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (finishBlock) {
        finishBlock(image);
    }
    image = nil;
}

-(void)removeDateViews
{
    if (_dateViews) {
        for (FMBaseView *v in _dateViews.subviews) {
            [v removeFromSuperview];
        }
    }
}
#pragma mark 日期提示
-(void)createDateViews:(CGFloat)x Model:(DaysChartModel*)model{
    if (!_dateViews) {
        _dateViews = [[FMBaseView alloc] initWithFrame:CGRectMake(0, _model.height, _model.width, 15)];
        [self addSubview:_dateViews];
        //行情页进入时的非分时图的时间栏dateViews
//        if (_isBlack) {
//            _dateViews.backgroundColor=KLineBoxBG;
//        }
    }
    _dateViews.frame = CGRectMake(0, _model.height, _model.width, 16);
    if (_model.kLineDirectionStyle==FMKLineDirection_Horizontal)
    {
        _dateViews.frame = CGRectMake(0, _model.height/3*2-4, _model.width, 16);
    }
    else
    {
        if (_model.type>0)
        {
            _dateViews.frame = CGRectMake(0, _model.height/3*2-16, _model.width, 16);
        }
    }
    UILabel *dateTips = [[UILabel alloc] init];
    dateTips.text = [LTUtils timeFormat_ShortHourStyle:[model.time doubleValue]];
    dateTips.font = fontSiz(kStageLeftTextFontSize);
    dateTips.textColor = LTSubTitleRGB;
    [dateTips sizeToFit];
    dateTips.frame = CGRectMake(x-dateTips.frame.size.width/2, 0, dateTips.frame.size.width+6, 16);
    dateTips.textAlignment = NSTextAlignmentCenter;
    dateTips.backgroundColor = LTClearColor;
    [_dateViews addSubview:dateTips];
    dateTips = nil;
    
}
#pragma mark 画三角形 天玑线信号
-(void)createThreeCornerWithContext:(CGContextRef)context Point:(NSArray*)point{
    CGFloat w = 13;
    CGFloat h = 8;
    UIColor *color = LTKLineGreen;
    CGFloat padding = 3;
    DaysChartModel *cm = [point objectAtIndex:point.count-2];
    CGPoint heightPoint = CGPointFromString([point objectAtIndex:0]);
    CGPoint lowPoint = CGPointFromString([point objectAtIndex:1]);
    if (cm.tianjiLineDirection==FMKLineTianjiLineDirection_None || _model.tianjiLineType==FMKLineTianjiLineType_None) {
        return;
    }
    // 三角路径
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGContextSetShouldAntialias(context, YES);
    if (cm.tianjiLineDirection==FMKLineTianjiLineDirection_Up) {
        color = LTKLineRed;
        CGPoint point = lowPoint;
        CGPathMoveToPoint(path, NULL, point.x-w/2, point.y + h + padding);
        CGPathAddLineToPoint(path, NULL, point.x, point.y + padding);
        CGPathAddLineToPoint(path, NULL, point.x+w/2, point.y+h + padding);
        CGPathAddLineToPoint(path, NULL, point.x-w/2, point.y+h + padding);
        CGContextAddPath(context, path);
        CGContextSetFillColorWithColor(context,color.CGColor);
    }else{
        CGPoint point = heightPoint;
        CGPathMoveToPoint(path, NULL, point.x-w/2, point.y - h - padding);
        CGPathAddLineToPoint(path, NULL, point.x, point.y - padding);
        CGPathAddLineToPoint(path, NULL, point.x+w/2, point.y-h - padding);
        CGPathAddLineToPoint(path, NULL, point.x-w/2, point.y-h - padding);
        CGContextAddPath(context, path);
        CGContextSetFillColorWithColor(context,color.CGColor);
    }
  
    //CGContextSetStrokeColorWithColor(context, _bottomLine.backgroundColor.CGColor);
    //CGContextStrokePath(context);
    CGContextFillPath(context);

}

#pragma mark 画最后的天玑线标识
-(void)createLastTianjiLineWithContext:(CGContextRef)context Point:(NSArray*)points NextPoints:(NSArray*)nextPoint{
    NSMutableArray *lastTianji = _model.lastTianjiLine;
    if (lastTianji.count<=0) {
        return;
    }
    //int index = [[lastTianji firstObject] intValue];
    CGFloat time = [[lastTianji objectAtIndex:2] floatValue];
    // 震荡版提前两天 趋势版不提前
    DaysChartModel *cm = [points objectAtIndex:points.count-2];
    
    if (time != [cm.time floatValue]) {
        return;
    }
    CGPoint point = CGPointFromString([nextPoint objectAtIndex:0]);
    
    
    FMKLineTianjiLineDirection _lineDirection = [[lastTianji lastObject] intValue];
    if (_lineDirection==FMKLineTianjiLineDirection_None) {
        return;
    }
    CGFloat padding = 3;
    UIImage *icon = _tianjiIcon_down;
    CGFloat w = icon.size.width;
    CGFloat h = icon.size.height;
    CGFloat x = point.x ;//+ 2*(_model.klineWidth + _model.klinePadding);
    if (x+_model.klinePadding+_model.klineWidth>=_model.width) {
        return;
    }
    point = CGPointMake(x-w/2, point.y-h-padding);
    if (_lineDirection==FMKLineTianjiLineDirection_Up) {
        icon = _tianjiIcon_up;
        point = CGPointFromString([nextPoint objectAtIndex:1]);
        point = CGPointMake(x-w/2, point.y+padding);
    }
    // 画图标上去
    [icon drawAtPoint:point];

}

#pragma mark 画一根K线
/*
 根据（最高价，最低价,开盘价，收盘）为依据重绘
 @prices 价格数组 ［heightPrice,lowPrice,openPrice,closePrice］
 */

-(void)drawOneKLine:(CGContextRef)context Point:(NSArray*)point KlineWidth:(CGFloat)lineWidth{
    if (point.count<=0) {
        return;
    }
    // 消除锯齿
    CGContextSetShouldAntialias(context, NO);

    [self drawDownLineWithContext:context Point:point KlineWidth:lineWidth];
    [self drawUpLineWithContext:context Point:point KlineWidth:lineWidth];
}
#pragma mark 画根阳线
-(void)drawUpLineWithContext:(CGContextRef)context Point:(NSArray*)point KlineWidth:(CGFloat)lineWidth{
    CGPoint heightPoint,lowPoint,openPoint,closePoint;
    heightPoint = CGPointFromString([point objectAtIndex:0]);
    lowPoint = CGPointFromString([point objectAtIndex:1]);
    openPoint = CGPointFromString([point objectAtIndex:2]);
    closePoint = CGPointFromString([point objectAtIndex:3]);
    BOOL isMiddleLine = YES;
    if (point.count==5) {
        isMiddleLine = [[point objectAtIndex:4] boolValue];
    }
    if (openPoint.y>=closePoint.y) {
        CGFloat width = 1;
        if (_model.klineWidth<2) {
            width = 0.5;// 影线最小0.5
        }
        CGContextSetLineWidth(context, width);
        CGContextSetStrokeColorWithColor(context, LTKLineRed.CGColor);
        if (closePoint.y==openPoint.y) {
            CGContextSetStrokeColorWithColor(context, kKLineGreyColor.CGColor);
        }
        if (isMiddleLine) {
            // 画多线的上下影线
            const CGPoint points[] = {CGPointMake(heightPoint.x, heightPoint.y),CGPointMake(lowPoint.x, lowPoint.y)};
            CGContextStrokeLineSegments(context, points, 2);
        }
        
        // 纠正实体的中心点为当前坐标
        openPoint = CGPointMake(openPoint.x, openPoint.y);
        closePoint = CGPointMake(closePoint.x, closePoint.y);
        
        // 开始画实体
        if (closePoint.y==openPoint.y) {
            CGContextSetStrokeColorWithColor(context, kKLineGreyColor.CGColor);
            // 纠正实体的中心点为当前坐标
            openPoint = CGPointMake(openPoint.x, openPoint.y);
            closePoint = CGPointMake(closePoint.x, closePoint.y+1);
            CGContextSetLineWidth(context, lineWidth);
            const CGPoint point[] = {openPoint,closePoint};
            CGContextStrokeLineSegments(context, point, 2);  // 绘制
        }else{
            // 纠正实体的中心点为当前坐标
            openPoint = CGPointMake(openPoint.x, openPoint.y);
            closePoint = CGPointMake(closePoint.x, closePoint.y);
            CGContextSetLineWidth(context, lineWidth);
            const CGPoint point[] = {openPoint,closePoint};
            CGContextStrokeLineSegments(context, point, 2);  // 绘制
        }
        
    }
}

#pragma mark 画根阴线
-(void)drawDownLineWithContext:(CGContextRef)context Point:(NSArray*)point KlineWidth:(CGFloat)lineWidth{
    CGPoint heightPoint,lowPoint,openPoint,closePoint;
    heightPoint = CGPointFromString([point objectAtIndex:0]);
    lowPoint = CGPointFromString([point objectAtIndex:1]);
    openPoint = CGPointFromString([point objectAtIndex:2]);
    closePoint = CGPointFromString([point objectAtIndex:3]);
    if (closePoint.y>self.frame.size.height || openPoint.y>self.frame.size.height) {
        return;
    }
    BOOL isMiddleLine = YES;
    if (point.count==5) {
        isMiddleLine = [[point objectAtIndex:4] boolValue];
    }
    if (openPoint.y<closePoint.y) {
        CGFloat width = 1;
        if (_model.klineWidth<2) {
            width = 0.5;
        }
        // 画空线的上下影线
        CGContextSetLineWidth(context, width);
        if (closePoint.y==openPoint.y) {
            CGContextSetLineWidth(context, _model.klineWidth);
        }
        // 设置线条颜色
        CGContextSetStrokeColorWithColor(context, LTKLineGreen.CGColor);
        if (isMiddleLine) {
            // 画线的上下影线
            const CGPoint points[] = {CGPointMake(heightPoint.x, heightPoint.y),CGPointMake(lowPoint.x, lowPoint.y)};
            CGContextStrokeLineSegments(context, points, 2);
        }
        
        // 纠正实体的中心点为当前坐标
        openPoint = CGPointMake(openPoint.x, openPoint.y);
        closePoint = CGPointMake(closePoint.x, closePoint.y);
        
        // 开始画实体
        CGContextSetLineWidth(context, lineWidth);
        const CGPoint point[] = {openPoint,closePoint};
        CGContextStrokeLineSegments(context, point, 2);
    }
    
}

#pragma mark ************************画连接线*************************
-(void)drawLineWithContext:(CGContextRef)context{
    if(_points.count<=0) return;
    // 定义两个点 画两点连线
    CGPoint startPoint = CGPointFromString([_points firstObject]);
    CGPoint endPoint = CGPointFromString([_points lastObject]);
    
    [self drawLine:context Color:_lineColor LineType:0 Width:_model.klineWidth StartPoint:startPoint EndPoint:endPoint];
    
}

-(void)addPath:(CGContextRef)context Path:(CGMutablePathRef)path Points:(NSArray*)point Index:(NSInteger)index IsFirst:(BOOL*)isfirst{
    CGPoint currentPoint = CGPointFromString([point objectAtIndex:index]);
    if (currentPoint.y<=0 || currentPoint.y>=_model.height) {
        return;
    }
    CGContextSetShouldAntialias(context, YES);
    CGContextSetLineWidth(context, kSmallLineWith);
    CGContextSetAlpha(context, 1);
    if (!*isfirst) {
        // 消除锯齿
        
        *isfirst = YES;
        // 定位第一个点
        CGPathMoveToPoint(path, NULL, currentPoint.x, currentPoint.y);
    }else{
        // 继续添加点
        CGPathAddLineToPoint(path,NULL, currentPoint.x, currentPoint.y);
    }
    
}

-(void)addPath:(CGContextRef)context Path:(CGMutablePathRef)path Point:(CGPoint)point IsFirst:(BOOL*)isfirst{
    // 线条宽度
    // 消除锯齿
    CGContextSetShouldAntialias(context, YES);
    CGContextSetLineWidth(context, kSmallLineWith);
    CGContextSetAlpha(context, 1);
    
    CGPoint currentPoint = point;
    if (currentPoint.y<=0 || currentPoint.y>=_model.height) {
        return;
    }
    if (!*isfirst) {
        *isfirst = YES;
        // 定位第一个点
        CGPathMoveToPoint(path, NULL, currentPoint.x, currentPoint.y);
    }else{
        // 继续添加点
        CGPathAddLineToPoint(path,NULL, currentPoint.x, currentPoint.y);
    }
    
}

#pragma mark 画多点连线
-(void)drawMorePointWithContext:(CGContextRef)context WithPoints:(NSArray*)points Index:(NSInteger)index LineColor:(UIColor*)lineColor{
    if(points.count<=0) return;
    // 线条宽度
    CGContextSetLineWidth(context, kSmallLineWith);
    CGContextSetAlpha(context, 1);
    //CGContextSetShouldAntialias(context, NO);
    // 颜色
    [lineColor setStroke];
    // 画多点连线
    NSInteger i = 0;
    for (NSArray* item in points) {
        CGPoint currentPoint = CGPointFromString([item objectAtIndex:index]);
        if (currentPoint.y<0 || currentPoint.y>self.frame.size.height) {
            continue;
        }
        //NSLog(@"%f",currentPoint.y);
        if (i==0) {
            // 定位第一个点
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, currentPoint.x, currentPoint.y);
            i++;
            continue;
        }else{
            // 继续添加点
            CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
        }
        i++;
    }
    // 连线
    CGContextStrokePath(context);
}

#pragma mark 画多点路径填充
-(void)drawMorePointGradientWithContext:(CGContextRef)context WithPoints:(NSArray*)points color:(UIColor *)color{
    if (!_model.isShadow) {
        return;
    }
    if(points.count<=0) return;
    // 线条宽度
    CGContextSetAlpha(context, 0.8);
    CGContextSetLineWidth(context, kSmallLineWith);
    // 画多点路径
    int i = 0;
    CGPoint currentPoint = CGPointFromString(points[0]);
    CGMutablePathRef path = CGPathCreateMutable();
    for (id item in points) {
        currentPoint = CGPointFromString(item);
        if (currentPoint.y<0 || currentPoint.y>self.frame.size.height) {
            continue;
        }
        //NSLog(@"%f",currentPoint.y);
        if (i==0) {
            // 定位第一个点
            //CGContextBeginPath(context);
//            CGPathAddLineToPoint(path,NULL, currentPoint.x, currentPoint.y);
            CGPathMoveToPoint(path, NULL, currentPoint.x, currentPoint.y);
            i++;
        }else{
            // 继续添加点
            CGPathAddLineToPoint(path,NULL, currentPoint.x, currentPoint.y);
        }
        i++;
    }
    // 封闭路径
    currentPoint = CGPointFromString([points lastObject]);
    CGPathAddLineToPoint(path,NULL, currentPoint.x, _model.height);
    CGPathAddLineToPoint(path,NULL, CGPointFromString([points firstObject]).x, _model.height);
    CGPathAddLineToPoint(path,NULL, CGPointFromString([points firstObject]).x, CGPointFromString([points firstObject]).y);
    CGPathCloseSubpath(path);
    // 连线
    //CGContextStrokePath(context);
    // 填充
    //[self.color setFill];
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextAddPath(context, path);
    //CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathEOFill);
    
}


#pragma mark 画两点间接线
-(void)drawLine:(CGContextRef)context Color:(UIColor*)color LineType:(int)lineType Width:(CGFloat)lineWidth StartPoint:(CGPoint)startPoint EndPoint:(CGPoint)endPoint{
    //NSLog(@"drawLineWithContext");
    if (startPoint.y<=0 || startPoint.y>=_model.height) {
        return;
    }
    if (endPoint.y<=0 || endPoint.y>=_model.height) {
        return;
    }
    CGContextSetLineWidth(context, lineWidth);
    CGMutablePathRef path = CGPathCreateMutable();
    // 如果是虚线
    if (lineType==1) {
        CGFloat lengths[] = {3,3};
        CGContextSetLineDash(context, 0, lengths, 2);  //画虚线
        
    }
    CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
    CGPathAddLineToPoint(path,NULL, endPoint.x, endPoint.y);
    //CGPathCloseSubpath(path);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathStroke);
    //CGContextStrokePath(context);
}


@end
