//
//  FMCalculationMinuteLine.m
//  golden_iphone
//
//  Created by dangfm on 15/6/11.
//  Copyright (c) 2015年 golden. All rights reserved.
//

#import "FMCalculationMinuteLine.h"
#import "FMStockIndexs.h"
#import "MinuteChartModel.h"

@interface FMCalculationMinuteLine() {
    FMKLineModel *_model;
    BOOL _updateAll;
    CGFloat _lastMaxValue;
    CGFloat _lastMinValue;
    NSOperationQueue *_queue;
    __block NSMutableDictionary *_operationTempData;
    NSString *middleTimeStr;
    CGFloat minCounts;//时间数
    double startTimeTamp;//开始时间戳;
    CGFloat tx;
}
@property(strong,nonatomic)NSMutableArray *mtArr;//middle时间arr

@end
@implementation FMCalculationMinuteLine

-(instancetype)initWithModel:(FMKLineModel *)model CalculationFinished:(CalculationFinished)calculationFinished{
    if (self==[super init]) {
        _updateAll = NO;
        _model = model;
        _calculationFinished = calculationFinished;
        [self initSet];
        [self changeToPoints];
    }
    return self;
}
-(instancetype)initWithModel:(FMKLineModel *)model CalculationFinished:(CalculationFinished)calculationFinished UpdateAll:(BOOL)updateAll{
    if (self==[super init]) {
        _updateAll = updateAll;
        _model = model;
        _calculationFinished = calculationFinished;
        [self initSet];
        [self changeToPoints];
    }
    return self;
}

-(void)dealloc{
    [_queue cancelAllOperations];
    _model.isFinished = YES;
    _model = nil;
    _mtArr=nil;
}

-(void)initSet{
    _queue = [[NSOperationQueue alloc] init];
    _operationTempData = [NSMutableDictionary new];
}

#pragma mark *********************坐标换算**********************

#pragma mark 价格集合换算为坐标集合
-(void)changeToPoints{
    [self changeToPointsCollectionWithPricesCollection:_model];
    // 数据处理完成 回调
    if (self.calculationFinished) {
        self.calculationFinished(_model);
    }
}

#pragma mark 价格集合换算为坐标集合
-(void)changeToPointsCollectionWithPricesCollection:(FMKLineModel*)model{
    NSArray *prices = (NSArray*)model.prices;
    if (model.startTime && model.endTime && model.middleTime) {
        model.times = [LTUtils changeTimesWithStartTime:model.startTime MiddleTime:model.middleTime EndTime:model.endTime Vertical:4];
        model.upMinutes = [LTUtils changeMinutesWithStartTime:model.startTime MiddleTime:model.middleTime EndTime:model.endTime Vertical:4 Type:0];
        model.downMinutes = [LTUtils changeMinutesWithStartTime:model.startTime MiddleTime:model.middleTime EndTime:model.endTime Vertical:4 Type:1];
    }
    CGFloat totalMinutes = model.upMinutes+model.downMinutes;
    if (prices.count<=0 || totalMinutes<=0) {
        return;
    }
    
    //step 1计算最值 最值用于确定Y坐标
    CGFloat maxPrice=0,minPrice=MAXFLOAT; // 最高价，最低价
    for (int i = 0;i<prices.count;i++) {
        NSDictionary *item = prices[i];
        MinuteChartModel *mchart = [[MinuteChartModel alloc] initWithDic:item];
        CGFloat transationPrice = [mchart.closePrice floatValue];
        // 最高最低价动态变化
        if (transationPrice>=maxPrice) {
            maxPrice = transationPrice;
        }
        if (transationPrice<=minPrice) {
            minPrice = transationPrice;
        }
        mchart = nil;
    }
    model.maxPrice = maxPrice;
    model.minPrice = minPrice;

    // 人为加高
    CGFloat yestodayClose=model.yestodayClosePrice;
    CGFloat subUpMax = fabs(maxPrice - yestodayClose);
    CGFloat subDownMax = fabs(minPrice - yestodayClose);
    CGFloat sub = (model.maxPrice - model.minPrice) / 4;
    if (subUpMax>subDownMax) {
        model.maxPrice=yestodayClose+subUpMax+sub;
    }else{
        model.maxPrice=yestodayClose+subDownMax+sub;
    }
    CGFloat _subvalue = fabs((model.maxPrice - yestodayClose)/2);
    model.minPrice =yestodayClose - 2*_subvalue;
    
    //step 2 计算tx（每单位x 对应的分钟时间）
    if (!minCounts) {
        [self configTimeCounts];
    }
    tx = minCounts/model.width;
    //step 3 计算py (每单位y 对应的价格)
    CGFloat height = model.height;
    CGFloat py = (model.maxPrice-model.minPrice)/height;
    //计算坐标
    CGFloat x=0,y=0,y1=0;
    CGFloat sumPrice = 0;
    NSInteger numPrice=0;
    NSMutableArray *points = [[NSMutableArray alloc] init];
    NSMutableArray *points1 = [[NSMutableArray alloc] init];
    
    double beforetime = 0;
    double time = 0;
    
    for (int i =0;i< prices.count;i++) {
        NSDictionary *item = prices[i];
        MinuteChartModel *mchart = [[MinuteChartModel alloc] initWithDic:item];
        CGFloat transationPrice = [mchart.closePrice floatValue];
        
        sumPrice +=transationPrice;
        numPrice++;
        CGFloat transationPrice1 = sumPrice * 1.0/numPrice;
        
        // 计算y坐标
        y = (model.maxPrice - transationPrice)/py;
//        height*(model.maxPrice - transationPrice) / (model.maxPrice - model.minPrice);
        y1 = (model.maxPrice - transationPrice1)/py;
//        height*(model.maxPrice - transationPrice1) / (model.maxPrice - model.minPrice);
        //计算x坐标
        time = [[item objectForKey:@"time"] longLongValue];
        
        if (i==0) {
            x=[self firstX:time startT:model.startTime tx:tx];
            beforetime = time;
        }
        x = x + (time - beforetime)/60/tx;
        beforetime = time;
        
        CGPoint _point = CGPointMake(x, y);
        [points addObject:NSStringFromCGPoint(_point)];
        
        CGPoint _point1 = CGPointMake(x, y1);
        [points1 addObject:NSStringFromCGPoint(_point1)];
    }
    
    [_model.points setObject:points
                      forKey:kStockPointsKey_KLineMinute];
    [_model.points setObject:points1
                      forKey:kStockPointsKey_KLineMinuteMA];
    prices = nil;
    points = nil;
    points1 = nil;
}


#pragma mark - utils
/*计算上下半段时间数
 */
-(void)configTimeCounts{
    NSString *startT=_model.startTime;
    NSString *endT=_model.endTime;
    
    NSInteger startHour = [[startT substringToIndex:[startT rangeOfString:@":"].location] floatValue];
    NSInteger startMinute = [[startT substringFromIndex:[startT rangeOfString:@":"].location+1] floatValue];
    NSInteger endHour = [[endT substringToIndex:[endT rangeOfString:@":"].location] floatValue];
    NSInteger endMinute = [[endT substringFromIndex:[endT rangeOfString:@":"].location+1] floatValue];
    if (endHour<12) {
        endHour=endHour+24;
    }
    NSInteger startTimeCount=startHour*60+startMinute;
    NSInteger endTimeCount = endHour*60+endMinute;
    minCounts = endTimeCount -startTimeCount;//分钟差
    
    if (startHour > endHour) {
        minCounts = 24*60-startTimeCount + endTimeCount;
    }
}
/*计算开始时间对应的x
 time double 时间戳
 startT string 开始时间
 return time对应的x坐标
 */
-(CGFloat)firstX:(double)time startT:(NSString *)startT tx:(CGFloat)timex{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 年月日获得
    NSDateComponents *com =[calendar components:( NSCalendarUnitHour | NSCalendarUnitMinute )
                                       fromDate:[NSDate dateWithTimeIntervalSince1970:time]];
    NSInteger hour = com.hour;
    NSInteger min = com.minute;
    
    CGFloat startHour = [[startT substringToIndex:[startT rangeOfString:@":"].location] floatValue];
    CGFloat startMinute = [[startT substringFromIndex:[startT rangeOfString:@":"].location+1] floatValue];
    
    if ([startT rangeOfString:@"/"].location != NSNotFound) {
        NSString * middleNext = [startT substringFromIndex:[startT rangeOfString:@"/"].location+1];
        startHour = [[middleNext substringToIndex:[middleNext rangeOfString:@":"].location] floatValue];
        startMinute = [[middleNext substringFromIndex:[middleNext rangeOfString:@":"].location+1] floatValue];
    }
    
    NSInteger startTimeCount=startHour*60+startMinute;
    NSInteger timeCount = hour*60+min;
    NSInteger subT= timeCount -startTimeCount;//分钟差
    if (startHour > hour && startHour>12) {
        subT=(24*60*60-startTimeCount)+timeCount;
    }
    if (subT<0) {
        subT=0;
    }
    CGFloat x=subT/timex;
    return x;
    
}

@end
