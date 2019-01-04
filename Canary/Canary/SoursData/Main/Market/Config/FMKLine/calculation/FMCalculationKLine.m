//
//  FMCalculationKLine.m
//  golden_iphone
//
//  Created by dangfm on 15/6/11.
//  Copyright (c) 2015年 golden. All rights reserved.
//

#import "FMCalculationKLine.h"
#import "FMStockIndexs.h"
#import "DaysChartModel.h"

@interface FMCalculationKLine(){
    FMKLineModel *_model;
    BOOL _updateAll;
    CGFloat _lastMaxValue;
    CGFloat _lastMinValue;
    NSOperationQueue *_queue;
    __block NSMutableDictionary *_operationTempData;
    BOOL _isHasTianji;
}

@end

@implementation FMCalculationKLine

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
    
}

-(void)initSet{
    _queue = [[NSOperationQueue alloc] init];
    _operationTempData = [NSMutableDictionary new];
}

#pragma mark *********************坐标换算**********************

#pragma mark 价格集合换算为坐标集合
-(void)changeToPoints{
    if (!_model.isFinished) {
        return ;
    }
    _model.isFinished = NO;
    
    // 首次转换
    [self firstChange];
    // 更新转换
    if (_updateAll) {
        [self updateAllChange];
    }else{
        [self updateChange];
    }
    
    
    
    // 更新数据处理标识
    _model.isChangeData = YES;
    // 数据处理完成 回调
    if (self.calculationFinished) {
        self.calculationFinished(_model);
    }
}
#pragma mark 首次转换
-(void)firstChange{
    //是否变更过数据，没有就进入方法计算
    if (!_model.isChangeData) {
        //新数组newprice
        NSMutableArray *newPrice = [NSMutableArray new];
        // 加几个空的k线填充距离
        int tempCount = _model.rightEmptyKline;
        for (int j=0; j<tempCount; j++) {
            NSMutableDictionary *newitem = [self getEmptyKLine];
            [newPrice addObject:newitem];
            newitem = nil;
        }
        int i = 0;
        // 计算KDJ
        NSMutableDictionary *KDJ = [FMStockIndexs getKDJMap:_model.prices];
        // 计算其他指标
        int SMA_N1 = [[self getSeting:@"SMA_N1"] intValue];
        int SMA_N2 = [[self getSeting:@"SMA_N2"] intValue];
        int SMA_N3 = [[self getSeting:@"SMA_N3"] intValue];
        int SMA_N4 = [[self getSeting:@"SMA_N4"] intValue];
        int SMA_N5 = [[self getSeting:@"SMA_N5"] intValue];
        
        int MACD_N1 = [[self getSeting:@"MACD_N1"] intValue];
        int MACD_N2 = [[self getSeting:@"MACD_N2"] intValue];
        int MACD_P = [[self getSeting:@"MACD_P"] intValue];
        int RSI_N1 = [[self getSeting:@"RSI_N1"] intValue];
        int RSI_N2 = [[self getSeting:@"RSI_N2"] intValue];
        int RSI_N3 = [[self getSeting:@"RSI_N3"] intValue];
        int BOLL_K = [[self getSeting:@"BOLL_K"] intValue];
        int BOLL_N = [[self getSeting:@"BOLL_N"] intValue];
        //        float RSI_N1_ly = 0;
        //        float RSI_N1_ly1 = 0;
        //        float RSI_N2_ly = 0;
        //        float RSI_N2_ly1 = 0;
        //        float RSI_N3_ly = 0;
        //        float RSI_N3_ly1 = 0;
        for (NSMutableDictionary *item in _model.prices) {
            float DIF = 0;
            float DEA = 0;
            float M = 0;
            float K = 0;
            float D = 0;
            float J = 0;
            
            NSMutableDictionary *newitem = item;
            // MA值
            CGFloat MA5 = [FMStockIndexs createMAWithPrices:_model.prices MA:SMA_N1 Index:i];
            CGFloat MA10 = [FMStockIndexs createMAWithPrices:_model.prices MA:SMA_N2 Index:i];
            CGFloat MA20 = [FMStockIndexs createMAWithPrices:_model.prices MA:SMA_N3 Index:i];
            CGFloat MA60 = [FMStockIndexs createMAWithPrices:_model.prices MA:SMA_N4 Index:i];
            CGFloat MA120 = [FMStockIndexs createMAWithPrices:_model.prices MA:SMA_N5 Index:i];
            
            [newitem setObject:[NSString stringWithFormat:@"%f",MA5]forKey:@"MA5"];
            [newitem setObject:[NSString stringWithFormat:@"%f",MA10]forKey:@"MA10"];
            [newitem setObject:[NSString stringWithFormat:@"%f",MA20]forKey:@"MA20"];
            [newitem setObject:[NSString stringWithFormat:@"%f",MA60]forKey:@"MA60"];
            [newitem setObject:[NSString stringWithFormat:@"%f",MA120]forKey:@"MA120"];
            
            // 计算每天的MACD值
            NSMutableDictionary *MACD = [FMStockIndexs getMACD:_model.prices
                                                       andDays:i
                                                   DhortPeriod:MACD_N1
                                                    LongPeriod:MACD_N2
                                                     MidPeriod:MACD_P];
            if (MACD) {
                DIF = [[MACD objectForKey:@"DIF"] floatValue];
                DEA = [[MACD objectForKey:@"DEA"] floatValue];
                M = [[MACD objectForKey:@"M"] floatValue];
            }
            if(item == _model.prices.lastObject)
            {
                NSLog(@"MACD = %@",MACD);
            }
            [newitem setObject:[NSString stringWithFormat:@"%f",DIF] forKey:@"MACD_DIF"];
            [newitem setObject:[NSString stringWithFormat:@"%f",DEA] forKey:@"MACD_DEA"];
            [newitem setObject:[NSString stringWithFormat:@"%f",M] forKey:@"MACD_M"];
            MACD = nil;
            // KDJ
            if (KDJ) {
                K = [[[KDJ valueForKey:@"K"] objectAtIndex:i] floatValue];
                D = [[[KDJ valueForKey:@"D"] objectAtIndex:i] floatValue];
                J = [[[KDJ valueForKey:@"J"] objectAtIndex:i] floatValue];
            }
            [newitem setObject:[NSString stringWithFormat:@"%f",K] forKey:@"KDJ_K"];
            [newitem setObject:[NSString stringWithFormat:@"%f",D] forKey:@"KDJ_D"];
            [newitem setObject:[NSString stringWithFormat:@"%f",J] forKey:@"KDJ_J"];
            // 计算RSI值
            [FMStockIndexs getRSIWithDay:i Key:@"RSI_1" Number:RSI_N1 Data:_model.prices];
            [FMStockIndexs getRSIWithDay:i Key:@"RSI_2" Number:RSI_N2 Data:_model.prices];
            [FMStockIndexs getRSIWithDay:i Key:@"RSI_3" Number:RSI_N3 Data:_model.prices];
            
            //            [FMStockIndexs RSI:i N:RSI_N1 list:_model.prices ly:&RSI_N1_ly ly1:&RSI_N1_ly1];
            //            [FMStockIndexs RSI:i N:RSI_N2 list:_model.prices ly:&RSI_N2_ly ly1:&RSI_N2_ly1];
            //            [FMStockIndexs RSI:i N:RSI_N3 list:_model.prices ly:&RSI_N3_ly ly1:&RSI_N3_ly1];
            
            // 计算EMA
            NSInteger prei = i;
            if (prei>0) {
                prei = prei - 1;
            }
            NSMutableArray *list = [NSMutableArray arrayWithObjects:[_model.prices objectAtIndex:prei],item,nil];
            CGFloat EMA = [FMStockIndexs getEMA:list Number:[[LTUtils getSeting:@"EMA_N"] intValue]];
            int EMA_Tianji_Cycle_1 = kStockTianjiEMACycle_1;
            int EMA_Tianji_Cycle_2 = kStockTianjiEMACycle_2;
            int sub = EMA_Tianji_Cycle_2 - EMA_Tianji_Cycle_1;
            if(_model.prices.count<EMA_Tianji_Cycle_2){
                EMA_Tianji_Cycle_1 = (int)_model.prices.count - sub;
                EMA_Tianji_Cycle_2 = (int)_model.prices.count;
            }
            CGFloat EMA_Tianji_1 = [FMStockIndexs getEMA:list Number:EMA_Tianji_Cycle_1];
            CGFloat EMA_Tianji_2 = [FMStockIndexs getEMA:list Number:EMA_Tianji_Cycle_2];
            [newitem setObject:[NSString stringWithFormat:@"%f",EMA] forKey:@"EMA"];
            [newitem setObject:[NSString stringWithFormat:@"%f",EMA_Tianji_1] forKey:@"EMA_Tianji_1"];
            [newitem setObject:[NSString stringWithFormat:@"%f",EMA_Tianji_2] forKey:@"EMA_Tianji_2"];
            list = nil;
            
            //NSLog(@"天玑线时间：%@  EMA1:%f   EMA2:%f  CLOSE:%@ KDJ_K:%f N1:%d N2:%d",[LTUtils timeformat:[[item objectForKey:@"time"] floatValue]],EMA_Tianji_1,EMA_Tianji_2,[item objectForKey:@"closePrice"],K,EMA_Tianji_Cycle_1,EMA_Tianji_Cycle_2);
            
            // 计算每天的BOLL值
            NSMutableDictionary *BOLL = [FMStockIndexs getBOLLWithDay:i K:BOLL_K N:BOLL_N Data:_model.prices];
            [newitem setObject:[BOLL valueForKey:@"mid"] forKey:@"BOLL_MIDDLE"];
            [newitem setObject:[BOLL valueForKey:@"up"] forKey:@"BOLL_UP"];
            [newitem setObject:[BOLL valueForKey:@"dn"] forKey:@"BOLL_DOWN"];
            BOLL = nil;
            [newPrice addObject:newitem];
            newitem = nil;
            i++;
            
            
        }
        i = 0;
        // 后面加几个空的k线填充距离
        for (int j=0; j<_model.leftEmptyKline; j++) {
            NSMutableDictionary *newitem = [self getEmptyKLine];
            [newPrice addObject:newitem];
            newitem = nil;
        }
        // 新的价格集合
        _model.prices = newPrice;
        newPrice = nil;
        
        // 计算偏移
        [self updateAllChange];
        // 首次加载 中间偏移
        _model.offsetMiddle = _model.offsetStart + (_model.offsetEnd-_model.offsetStart+1)/2;
    }
}

#pragma mark 多线程计算
-(void)moreQueueChange{
    [_model.points removeAllObjects];
    [_queue cancelAllOperations];
    // 生成多少个线程
    int operationCount = 1;
    if (_model.isZooming) {
        operationCount = 1;
    }
    int sub = (_model.offsetEnd - _model.offsetStart) / operationCount;
    int start = _model.offsetStart;
    [_queue setMaxConcurrentOperationCount:operationCount+1];
    int end = _model.offsetStart + sub;
    WS(weakSelf);
    for (int i=0; i<=operationCount; i++) {
        if (end>=_model.offsetEnd) {
            end = _model.offsetEnd;
        }
        // 生成线程
        NSNumber *key = [NSNumber numberWithInt:i];
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            NSMutableArray * tempData = [weakSelf updateChangePointWithStartIndex:start EndIndex:end];
            //NSLog(@"key=%@",key);
            // 数据装入缓存
            [_operationTempData setObject:tempData forKey:key];
            tempData = nil;
        }];
        key = nil;
        operation.completionBlock = ^{
            //NSLog(@"finished:%d",i);
        };
        //[operation start];
        // 加入队列
        [_queue addOperation:operation];
        operation = nil;
        key = nil;
        if (end>=_model.offsetEnd) {
            break;
        }
        start = end;
        end = start + sub;
        
    }
    
    // 等待所有线程完成
    [_queue waitUntilAllOperationsAreFinished];
    // 整合数据
    NSMutableArray *point = [NSMutableArray new];
    for (int i=0; i<=operationCount; i++)
    {
        // 取出对应缓存数据
        NSArray *tempdata = [_operationTempData objectForKey:[NSNumber numberWithInt:i]];
        if (tempdata) {
            [point addObjectsFromArray:tempdata];
        }
        tempdata = nil;
    }
    [_model.points setObject:point forKey:kStockPointsKey_KLine];
    _model.allPoints = _operationTempData.copy;
    [_operationTempData removeAllObjects];
    point = nil;
}


#pragma mark 更新所有
-(void)updateAllChange
{
    // 计算偏移
    [self setOffset];
    // 更新最大最小值
    [self updateMaxMinValue];
    // 多线程计算
    [self moreQueueChange];
}

#pragma mark 更新转换
-(void)updateChange{
    if (_model.isChangeData) {
        // 计算偏移
        [self setOffset];
        // 更新最大最小值
        [self updateMaxMinValue];
        // 多线程计算
        [self moreQueueChange];
        
    }
}
#pragma mark 计算偏移量
-(void)setOffset{
    // 线的显示总量
    int pointCounts = floor((_model.width) / (_model.klineWidth + _model.klinePadding))+1;
    if (_model.prices.count<=0) {
        pointCounts = 0;
    }
    if (_model.offsetStart<0 || _model.isReset) {
        // 数据偏移起始位置
        _model.offsetStart = (int)_model.prices.count - pointCounts;
    }
    _model.offsetEnd = _model.offsetStart + pointCounts;
    
    if (_model.offsetStart<=0) {
        _model.offsetStart = 0;
    }
    if (_model.offsetEnd>=_model.prices.count) {
        _model.offsetEnd = (int)_model.prices.count;
        _model.offsetStart = _model.offsetEnd - pointCounts;
    }
    
    //NSLog(@"start:%d  end:%d",_model.offsetStart,_model.offsetEnd);
}
#pragma mark 更新最大最小值
-(void)updateMaxMinValue{
    int startIndex = _model.offsetStart;
    int endIndex = _model.offsetEnd;
    _model.maxPrice = 0;
    _model.minPrice = CGFLOAT_MAX;
    _model.bottomMaxPrice = 0;
    _model.bottomMinPrice = CGFLOAT_MAX;
    for (int i=startIndex<0?0:startIndex;i<endIndex;i++) {
        if (i>=_model.prices.count) {
            break;
        }
        NSDictionary *item = [_model.prices objectAtIndex:i];
        DaysChartModel *mchart = [[DaysChartModel alloc] initWithDic:item];
        CGFloat heightPrice = [mchart.heightPrice floatValue];
        CGFloat lowPrice = [mchart.lowPrice floatValue];
        CGFloat SMA_N1 = [mchart.MA5 floatValue];
        CGFloat SMA_N2 = [mchart.MA10 floatValue];
        CGFloat SMA_N3 = [mchart.MA20 floatValue];
        CGFloat SMA_N4 = [mchart.MA60 floatValue];
        CGFloat SMA_N5 = [mchart.MA120 floatValue];
        
        CGFloat EMA = [mchart.EMA floatValue];
        CGFloat BOLL_DOWN = [mchart.BOLL_DOWN floatValue];
        CGFloat BOLL_MIDDLE = [mchart.BOLL_MIDDLE floatValue];
        CGFloat BOLL_UP = [mchart.BOLL_UP floatValue];
        // 最高最低价动态变化
        if (heightPrice>_model.maxPrice && heightPrice<CGFLOAT_MAX) {
            _model.maxPrice = heightPrice;
        }
        if (lowPrice<_model.minPrice && lowPrice>0 && lowPrice<CGFLOAT_MAX) {
            _model.minPrice = lowPrice;
        }
        if (_model.stockIndexType == FMStockIndexType_SAM) {
            if (SMA_N1>_model.maxPrice && SMA_N1<CGFLOAT_MAX) {
                _model.maxPrice = SMA_N1;
            }
            if (SMA_N1<_model.minPrice && SMA_N1>0 && SMA_N1<CGFLOAT_MAX) {
                _model.minPrice = SMA_N1;
            }
            if (SMA_N2>_model.maxPrice && SMA_N2<CGFLOAT_MAX ) {
                _model.maxPrice = SMA_N2;
            }
            if (SMA_N2<_model.minPrice && SMA_N2>0 && SMA_N2<CGFLOAT_MAX) {
                _model.minPrice = SMA_N2;
            }
            if (SMA_N3>_model.maxPrice && SMA_N3<CGFLOAT_MAX) {
                _model.maxPrice = SMA_N3;
            }
            if (SMA_N3<_model.minPrice && SMA_N3>0 && SMA_N3<CGFLOAT_MAX) {
                _model.minPrice = SMA_N3;
            }
            if (SMA_N4>_model.maxPrice && SMA_N4<CGFLOAT_MAX) {
                _model.maxPrice = SMA_N4;
            }
            if (SMA_N4<_model.minPrice && SMA_N4>0 && SMA_N4<CGFLOAT_MAX) {
                _model.minPrice = SMA_N4;
            }
            if (SMA_N5>_model.maxPrice && SMA_N5<CGFLOAT_MAX) {
                _model.maxPrice = SMA_N5;
            }
            if (SMA_N5<_model.minPrice && SMA_N5>0 && SMA_N5<CGFLOAT_MAX) {
                _model.minPrice = SMA_N5;
            }
        }
        if (_model.stockIndexType == FMStockIndexType_EMA) {
            if (EMA>_model.maxPrice && EMA<CGFLOAT_MAX) {
                _model.maxPrice = EMA;
            }
            if (EMA<_model.minPrice && EMA>0 && EMA<CGFLOAT_MAX) {
                _model.minPrice = EMA;
            }
        }
        if (_model.stockIndexType == FMStockIndexType_BOLL) {
            if (BOLL_DOWN>_model.maxPrice && BOLL_DOWN<CGFLOAT_MAX) {
                _model.maxPrice = BOLL_DOWN;
            }
            if (BOLL_DOWN<_model.minPrice && BOLL_DOWN>0 && BOLL_DOWN<CGFLOAT_MAX) {
                _model.minPrice = BOLL_DOWN;
            }
            if (BOLL_MIDDLE>_model.maxPrice && BOLL_MIDDLE<CGFLOAT_MAX) {
                _model.maxPrice = BOLL_MIDDLE;
            }
            if (BOLL_MIDDLE<_model.minPrice && BOLL_MIDDLE>0 && BOLL_MIDDLE<CGFLOAT_MAX) {
                _model.minPrice = BOLL_MIDDLE;
            }
            if (BOLL_UP>_model.maxPrice && BOLL_UP<CGFLOAT_MAX) {
                _model.maxPrice = BOLL_UP;
            }
            if (BOLL_UP<_model.minPrice && BOLL_UP>0 && BOLL_UP<CGFLOAT_MAX) {
                _model.minPrice = BOLL_UP;
            }
        }
        
        float M = 0;
        float DIF = 0;
        float DEA = 0;
        float J = 0;
        float rsi_1 = 0;
        float rsi_2 = 0;
        float rsi_3 = 0;
        M = [mchart.MACD_M floatValue];
        DIF = [mchart.MACD_DIF floatValue];
        DEA = [mchart.MACD_DEA floatValue];
        J = [mchart.KDJ_J floatValue];
        rsi_1 = [mchart.RSI_1 floatValue];
        rsi_2 = [mchart.RSI_2 floatValue];
        rsi_3 = [mchart.RSI_3 floatValue];
        if (_model.stockIndexBottomType == FMStockIndexType_MACD) {
            // 计算MACD的最大最小
            if (M > _model.bottomMaxPrice && M<CGFLOAT_MAX) {
                _model.bottomMaxPrice = M;
            }
            if (M < _model.bottomMinPrice && M<CGFLOAT_MAX) {
                _model.bottomMinPrice = M;
            }
            if (DIF > _model.bottomMaxPrice && DIF<CGFLOAT_MAX) {
                _model.bottomMaxPrice = DIF;
            }
            if (DIF < _model.bottomMinPrice && DIF<CGFLOAT_MAX) {
                _model.bottomMinPrice = DIF;
            }
            if (DEA > _model.bottomMaxPrice && DEA<CGFLOAT_MAX) {
                _model.bottomMaxPrice = DEA;
            }
            if (DEA < _model.bottomMinPrice && DEA<CGFLOAT_MAX) {
                _model.bottomMinPrice = DEA;
            }
        }
        if (_model.stockIndexBottomType == FMStockIndexType_KDJ) {
            // 计算KDJ的最大最小值
            if (J > _model.bottomMaxPrice && M<CGFLOAT_MAX) {
                _model.bottomMaxPrice = J;
            }
            if (J < _model.bottomMinPrice && M<CGFLOAT_MAX) {
                _model.bottomMinPrice = J;
            }
        }
        if (_model.stockIndexBottomType == FMStockIndexType_RSI) {
            // 计算RSI的最大最小值
            if (rsi_1>_model.bottomMaxPrice && rsi_1<CGFLOAT_MAX) {
                _model.bottomMaxPrice = rsi_1;
            }
            if (rsi_2>_model.bottomMaxPrice && rsi_2<CGFLOAT_MAX) {
                _model.bottomMaxPrice = rsi_2;
            }
            if (rsi_3>_model.bottomMaxPrice && rsi_3<CGFLOAT_MAX) {
                _model.bottomMaxPrice = rsi_3;
            }
            if (rsi_1<_model.bottomMinPrice && rsi_1<CGFLOAT_MAX) {
                _model.bottomMinPrice = rsi_1;
            }
            if (rsi_2<_model.bottomMinPrice && rsi_2<CGFLOAT_MAX) {
                _model.bottomMinPrice = rsi_2;
            }
            if (rsi_3<_model.bottomMinPrice && rsi_3<CGFLOAT_MAX) {
                _model.bottomMinPrice = rsi_3;
            }
        }
        
        mchart = nil;
        item = nil;
    }
    
    // 人为加高
    CGFloat _subvalue = (_model.maxPrice - _model.minPrice) / kStageHorizontalLine;
    _model.maxPrice = _model.maxPrice + _subvalue/2;
    _model.minPrice = _model.minPrice - _subvalue/2;
    
    // 人为加高
    CGFloat _subvalue_bottom = (_model.bottomMaxPrice - _model.bottomMinPrice) / 2;
    _model.bottomMaxPrice = _model.bottomMaxPrice + _subvalue_bottom/2;
    _model.bottomMinPrice = _model.bottomMinPrice - _subvalue_bottom/2;
    
}




#pragma mark 更新坐标
-(NSMutableArray*)updateChangePointWithStartIndex:(int)startIndex EndIndex:(int)endIndex{
    
    _lastMaxValue = _model.maxPrice;
    _lastMinValue = _model.minPrice;
    NSMutableArray *points = [NSMutableArray new];
    CGFloat startPointX = startIndex*(_model.klineWidth + _model.klinePadding);
    CGFloat pointStartX = _model.offsetMiddle*(_model.klineWidth + _model.klinePadding) - _model.width/2;
    pointStartX = startPointX - pointStartX;
    if (!_model.isZooming) {
        pointStartX = (startIndex-_model.offsetStart)*(_model.klineWidth + _model.klinePadding);
    }
    if (_model.offsetStart == 0) {
        pointStartX = 0;
    }
    //NSLog(@"pointStartX:%f",pointStartX);
    DaysChartModel *mchart;
    NSDictionary *item;
    NSArray *prePoint = [NSArray new];
    int j = 0;
    for (int i = startIndex<0?0:startIndex; i<endIndex; i++) {
        if (i>=_model.prices.count) {
            break;
        }
        item = [_model.prices objectAtIndex:i];
        mchart = [[DaysChartModel alloc] initWithDic:item];
        if (mchart==nil || [mchart isEqual:[NSNull null]]) {
            j++;
            continue;
        }
        // 计算K线的坐标
        CGFloat heightvalue = [mchart.heightPrice floatValue];// 得到最高价
        CGFloat lowvalue = [mchart.lowPrice floatValue];// 得到最低价
        CGFloat openvalue = [mchart.openPrice floatValue];// 得到开盘价
        CGFloat closevalue = [mchart.closePrice floatValue];// 得到收盘价
        // 换算成实际的坐标
        CGFloat heightPointY = [self getPointYWithPrice:heightvalue];
        CGPoint heightPoint =  CGPointMake(pointStartX, heightPointY); // 最高价换算为实际坐标值
        CGFloat lowPointY = [self getPointYWithPrice:lowvalue];
        CGPoint lowPoint =  CGPointMake(pointStartX, lowPointY); // 最低价换算为实际坐标值
        CGFloat openPointY = [self getPointYWithPrice:openvalue];
        CGPoint openPoint =  CGPointMake(pointStartX, openPointY); // 开盘价换算为实际坐标值
        CGFloat closePointY = [self getPointYWithPrice:closevalue];
        CGPoint closePoint =  CGPointMake(pointStartX, closePointY); // 收盘价换算为实际坐标值
        
        /************************************************************************************
         计算指标坐标
         ************************************************************************************/
        CGPoint SMA_N1_P=CGPointMake(-1, -1),SMA_N2_P=CGPointMake(-1, -1) ,SMA_N3_P=CGPointMake(-1, -1),SMA_N4_P=CGPointMake(-1, -1),SMA_N5_P=CGPointMake(-1, -1);
        if (_model.stockIndexType==FMStockIndexType_SAM) {
            CGFloat SMA_N1_Y = [self getPointYWithPrice:[mchart.MA5 floatValue]];
            CGFloat SMA_N2_Y = [self getPointYWithPrice:[mchart.MA10 floatValue]];
            CGFloat SMA_N3_Y = [self getPointYWithPrice:[mchart.MA20 floatValue]];
            CGFloat SMA_N4_Y = [self getPointYWithPrice:[mchart.MA60 floatValue]];
            CGFloat SMA_N5_Y = [self getPointYWithPrice:[mchart.MA120 floatValue]];
            
            SMA_N1_P = CGPointMake(pointStartX, SMA_N1_Y);
            SMA_N2_P = CGPointMake(pointStartX, SMA_N2_Y);
            SMA_N3_P = CGPointMake(pointStartX, SMA_N3_Y);
            SMA_N4_P = CGPointMake(pointStartX, SMA_N4_Y);
            SMA_N5_P = CGPointMake(pointStartX, SMA_N5_Y);
        }
        
        // 计算EMA
        CGPoint EMA_P=CGPointMake(-1, -1);
        if (_model.stockIndexType==FMStockIndexType_EMA) {
            EMA_P = [self changeEMAPointWithModel:_model DaysChartModel:mchart StartX:pointStartX];
        }
        // 计算BOLL
        CGPoint BOLL_DOWNPoint=CGPointMake(-1, -1),BOLL_UPPoint=CGPointMake(-1, -1),BOLL_MIDDLEPoint=CGPointMake(-1, -1);
        if (_model.stockIndexType == FMStockIndexType_BOLL) {
            // 计算BOLL坐标
            BOLL_UPPoint = [self changeBOOLPointWithModel:_model Type:@"BOLL_UP" DaysChartModel:mchart StartX:pointStartX];
            BOLL_MIDDLEPoint = [self changeBOOLPointWithModel:_model Type:@"BOLL_MIDDLE" DaysChartModel:mchart StartX:pointStartX];
            BOLL_DOWNPoint = [self changeBOOLPointWithModel:_model Type:@"BOLL_DOWN" DaysChartModel:mchart StartX:pointStartX];
        }
        // 计算MACD坐标
        CGPoint MACD_DIFPoint=CGPointMake(-1, -1),MACD_DEAPoint=CGPointMake(-1, -1);
        NSArray *MACD_MPoint = [NSArray new];
        if (_model.stockIndexBottomType==FMStockIndexType_MACD) {
            MACD_DIFPoint = [self changeMACDPointWithModel:_model DaysChartModel:mchart Type:@"DIF" StartX:pointStartX];
            MACD_DEAPoint = [self changeMACDPointWithModel:_model DaysChartModel:mchart Type:@"DEA"StartX:pointStartX];
            MACD_MPoint = [self changeMACD_MPointWithModel:_model DaysChartModel:mchart StartX:pointStartX];
        }
        CGPoint KDJ_KPoint=CGPointMake(-1, -1),KDJ_DPoint=CGPointMake(-1, -1),KDJ_JPoint=CGPointMake(-1, -1);
        if (_model.stockIndexBottomType == FMStockIndexType_KDJ) {
            // 计算JDK坐标
            KDJ_KPoint = [self changeKDJPointWithModel:_model Type:@"K" DaysChartModel:mchart StartX:pointStartX];
            KDJ_DPoint = [self changeKDJPointWithModel:_model Type:@"D" DaysChartModel:mchart StartX:pointStartX];
            KDJ_JPoint = [self changeKDJPointWithModel:_model Type:@"J" DaysChartModel:mchart StartX:pointStartX];
        }
        CGPoint RSI_N1Point=CGPointMake(-1, -1),RSI_N2Point=CGPointMake(-1, -1),RSI_N3Point=CGPointMake(-1, -1);
        if (_model.stockIndexBottomType == FMStockIndexType_RSI) {
            // 计算RSI坐标
            RSI_N1Point = [self changeRSIPointWithModel:_model Type:@"RSI_1" DaysChartModel:mchart StartX:pointStartX];
            RSI_N2Point = [self changeRSIPointWithModel:_model Type:@"RSI_2" DaysChartModel:mchart StartX:pointStartX];
            RSI_N3Point = [self changeRSIPointWithModel:_model Type:@"RSI_3" DaysChartModel:mchart StartX:pointStartX];
        }
        
        // 计算天玑线
        BOOL isTianji = [self downFromTianjiData:_model DaysChartModel:mchart Days:i];
        if (isTianji) {
            // 做空信号
            // 震荡版
            if (_model.tianjiLineType==FMKLineTianjiLineType_Shock) {
                mchart.tianjiLineDirection = FMKLineTianjiLineDirection_Down;
                if (!_model.isHasLastTianji) {
                    // 只保存最后天玑线
                    [_model.lastTianjiLine removeAllObjects];
                    [_model.lastTianjiLine addObject:[NSNumber numberWithInt:j]];
                    [_model.lastTianjiLine addObject:NSStringFromCGPoint(heightPoint)];
                    [_model.lastTianjiLine addObject:mchart.time];
                    [_model.lastTianjiLine addObject:mchart];
                    [_model.lastTianjiLine addObject:[NSNumber numberWithInt:FMKLineTianjiLineDirection_Down]];
                }
            }
            // 趋势版
            if (_model.tianjiLineType==FMKLineTianjiLineType_Trend) {
                if (mchart.EMA_Tianji_1<mchart.EMA_Tianji_2) {
                    mchart.tianjiLineDirection = FMKLineTianjiLineDirection_Down;
                    if (!_model.isHasLastTianji) {
                        // 只保存最后天玑线
                        [_model.lastTianjiLine removeAllObjects];
                        [_model.lastTianjiLine addObject:[NSNumber numberWithInt:j]];
                        [_model.lastTianjiLine addObject:NSStringFromCGPoint(heightPoint)];
                        [_model.lastTianjiLine addObject:mchart.time];
                        [_model.lastTianjiLine addObject:mchart];
                        [_model.lastTianjiLine addObject:[NSNumber numberWithInt:FMKLineTianjiLineDirection_Down]];
                    }
                }
            }
            
            // NSLog(@"天玑线时间 空＝：%@",[LTUtils toDescriptionStringWithTimestamp:[mchart.time floatValue]]);
        }
        isTianji = [self upFromTianjiData:_model DaysChartModel:mchart Days:i];
        if (isTianji) {
            // 震荡版
            if (_model.tianjiLineType==FMKLineTianjiLineType_Shock) {
                mchart.tianjiLineDirection = FMKLineTianjiLineDirection_Up;
                if (!_model.isHasLastTianji) {
                    // 只保存最后天玑线
                    [_model.lastTianjiLine removeAllObjects];
                    [_model.lastTianjiLine addObject:[NSNumber numberWithInt:j]];
                    [_model.lastTianjiLine addObject:NSStringFromCGPoint(lowPoint)];
                    [_model.lastTianjiLine addObject:mchart.time];
                    [_model.lastTianjiLine addObject:mchart];
                    [_model.lastTianjiLine addObject:[NSNumber numberWithInt:FMKLineTianjiLineDirection_Up]];
                }
            }
            // 趋势版
            if (_model.tianjiLineType==FMKLineTianjiLineType_Trend) {
                if (mchart.EMA_Tianji_1>mchart.EMA_Tianji_2) {
                    mchart.tianjiLineDirection = FMKLineTianjiLineDirection_Up;
                    if (!_model.isHasLastTianji) {
                        // 只保存最后天玑线
                        [_model.lastTianjiLine removeAllObjects];
                        [_model.lastTianjiLine addObject:[NSNumber numberWithInt:j]];
                        [_model.lastTianjiLine addObject:NSStringFromCGPoint(lowPoint)];
                        [_model.lastTianjiLine addObject:mchart.time];
                        [_model.lastTianjiLine addObject:mchart];
                        [_model.lastTianjiLine addObject:[NSNumber numberWithInt:FMKLineTianjiLineDirection_Up]];
                    }
                }
            }
            // NSLog(@"天玑线时间 多＝：%@",[LTUtils toDescriptionStringWithTimestamp:[mchart.time floatValue]]);
            
        }
        
        
        
        
        // 更新最后一个天玑线
        if (_model.isHasLastTianji) {
            if(_model.lastTianjiLine.count>0){
                CGFloat t = [[_model.lastTianjiLine objectAtIndex:2]floatValue];
                if (t==[mchart.time floatValue]) {
                    [_model.lastTianjiLine replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:j]];
                }
            }
        }
        
        
        
        // k线坐标
        NSMutableArray *kArray = [[NSMutableArray alloc] initWithObjects:
                                  NSStringFromCGPoint(heightPoint),
                                  NSStringFromCGPoint(lowPoint),
                                  NSStringFromCGPoint(openPoint),
                                  NSStringFromCGPoint(closePoint),
                                  NSStringFromCGPoint(SMA_N1_P),
                                  NSStringFromCGPoint(SMA_N2_P),
                                  NSStringFromCGPoint(SMA_N3_P),
                                  NSStringFromCGPoint(SMA_N4_P),
                                  NSStringFromCGPoint(SMA_N5_P),
                                  NSStringFromCGPoint(EMA_P),
                                  NSStringFromCGPoint(BOLL_DOWNPoint),
                                  NSStringFromCGPoint(BOLL_MIDDLEPoint),
                                  NSStringFromCGPoint(BOLL_UPPoint),
                                  NSStringFromCGPoint(MACD_DIFPoint),
                                  NSStringFromCGPoint(MACD_DEAPoint),
                                  MACD_MPoint,
                                  NSStringFromCGPoint(KDJ_KPoint),
                                  NSStringFromCGPoint(KDJ_DPoint),
                                  NSStringFromCGPoint(KDJ_JPoint),
                                  NSStringFromCGPoint(RSI_N1Point),
                                  NSStringFromCGPoint(RSI_N2Point),
                                  NSStringFromCGPoint(RSI_N3Point),
                                  mchart,
                                  prePoint,
                                  nil];
        [points addObject:kArray]; // 把坐标添加进新数组
        if (i==_model.offsetStart) {
            _model.scrollOffset = CGPointMake(pointStartX, 0);
        }
        pointStartX += (_model.klineWidth + _model.klinePadding); // 生成下一个点的x轴
        // 保存上一个点
        prePoint = [[NSMutableArray alloc] initWithObjects:
                    NSStringFromCGPoint(heightPoint),
                    NSStringFromCGPoint(lowPoint),
                    NSStringFromCGPoint(openPoint),
                    NSStringFromCGPoint(closePoint),
                    NSStringFromCGPoint(SMA_N1_P),
                    NSStringFromCGPoint(SMA_N2_P),
                    NSStringFromCGPoint(SMA_N3_P),
                    NSStringFromCGPoint(SMA_N4_P),
                    NSStringFromCGPoint(SMA_N5_P),
                    NSStringFromCGPoint(EMA_P),
                    NSStringFromCGPoint(BOLL_DOWNPoint),
                    NSStringFromCGPoint(BOLL_MIDDLEPoint),
                    NSStringFromCGPoint(BOLL_UPPoint),
                    NSStringFromCGPoint(MACD_DIFPoint),
                    NSStringFromCGPoint(MACD_DEAPoint),
                    MACD_MPoint,
                    NSStringFromCGPoint(KDJ_KPoint),
                    NSStringFromCGPoint(KDJ_DPoint),
                    NSStringFromCGPoint(KDJ_JPoint),
                    NSStringFromCGPoint(RSI_N1Point),
                    NSStringFromCGPoint(RSI_N2Point),
                    NSStringFromCGPoint(RSI_N3Point),
                    nil];
        // 保存最后一个
        if (heightPoint.y>0) {
            _model.lastPoints = kArray;
        }
        kArray = nil;
        j++;
    }
    // 天玑线只计算一次
    if (_model.lastTianjiLine.count>0) {
        _model.isHasLastTianji = YES;
    }
    
    item = nil;
    mchart = nil;
    // 装进坐标库
    return points ;
    
}



#pragma mark *******************单步操作*******************
#pragma mark - 添加空KLine
-(NSMutableDictionary *)getEmptyKLine{
    NSMutableDictionary *newitem = [NSMutableDictionary new];
    [newitem setObject:[NSString stringWithFormat:@"%f",CGFLOAT_MAX] forKey:@"MACD_DIF"];
    [newitem setObject:[NSString stringWithFormat:@"%f",CGFLOAT_MAX] forKey:@"MACD_DEA"];
    [newitem setObject:[NSString stringWithFormat:@"%f",CGFLOAT_MAX] forKey:@"MACD_M"];
    [newitem setObject:[NSString stringWithFormat:@"%f",CGFLOAT_MAX] forKey:@"KDJ_K"];
    [newitem setObject:[NSString stringWithFormat:@"%f",CGFLOAT_MAX] forKey:@"KDJ_D"];
    [newitem setObject:[NSString stringWithFormat:@"%f",CGFLOAT_MAX] forKey:@"KDJ_J"];
    [newitem setObject:[NSString stringWithFormat:@"%f",CGFLOAT_MAX] forKey:@"RSI_1"];
    [newitem setObject:[NSString stringWithFormat:@"%f",CGFLOAT_MAX] forKey:@"RSI_2"];
    [newitem setObject:[NSString stringWithFormat:@"%f",CGFLOAT_MAX] forKey:@"RSI_3"];
    [newitem setObject:[NSString stringWithFormat:@"%f",CGFLOAT_MAX] forKey:@"BOLL_MIDDLE"];
    [newitem setObject:[NSString stringWithFormat:@"%f",CGFLOAT_MAX] forKey:@"BOLL_UP"];
    [newitem setObject:[NSString stringWithFormat:@"%f",CGFLOAT_MAX] forKey:@"BOLL_DOWN"];
    return newitem;
}
#pragma mark 获取配置文件
-(NSString*)getSeting:(NSString*)key{
    return [LTUtils getSeting:key];
}
#pragma mark 计算收盘所在y轴坐标
-(CGFloat)getPointYWithPrice:(CGFloat)price{
    CGFloat height = _model.height/3*2 - kStagePaddingTop - kStagePaddingBottom; // y的实际像素高度
    // 换算成实际的坐标
    CGFloat pointY = height * (1 - (price - _model.minPrice) / (_model.maxPrice - _model.minPrice)) + kStagePaddingTop;
    if (_model.type>0&&_model.kLineDirectionStyle==FMKLineDirection_Vertical) {
        height = _model.height/3*2 - kStagePaddingTop - SMAHeight-16;
        pointY = height * (1 - (price - _model.minPrice) / (_model.maxPrice - _model.minPrice)) + kStagePaddingTop +SMAHeight;
    }
    if (price<=0) {
        pointY = -1;
    }
    return pointY;
}
#pragma mark 计算幅图指标所在y轴坐标
-(CGFloat)getBottomPointYWithPrice:(CGFloat)price{
    CGFloat height = _model.height/3 - kStagePaddingTop; // y的实际像素高度
    // 换算成实际的坐标
    CGFloat pointY = height * (1 - (price - _model.minPrice) / (_model.maxPrice - _model.minPrice)) + kStagePaddingTop;
    return pointY;
}


#pragma mark 计算EMA坐标
-(CGPoint)changeEMAPointWithModel:(FMKLineModel*)model DaysChartModel:(DaysChartModel*)charModel StartX:(CGFloat)startX{
    
    CGFloat PointStartX = startX; // 起始点坐标
    CGFloat PointStartY = kStagePaddingTop;
    
    CGFloat currentValue = [charModel.EMA floatValue];// 得到前五天的均价价格
    
    if (currentValue>=CGFLOAT_MAX) {
        return CGPointMake(0, CGFLOAT_MAX);
    }
    // 换算成实际的坐标
    CGFloat yHeight = model.maxPrice - model.minPrice ; // y的价格高度
    CGFloat yViewHeight = model.height/3*2 - 2*PointStartY;// y的实际像素高度
    // 换算成实际的坐标
    CGFloat currentPointY = yViewHeight * (1 - (currentValue - model.minPrice) / yHeight) + PointStartY;
    if (model.type>0 && model.kLineDirectionStyle==FMKLineDirection_Vertical)
    {
        yViewHeight = model.height/3*2 - kStagePaddingTop - kStagePaddingBottom-SMAHeight;
        currentPointY = yViewHeight * (1 - (currentValue - model.minPrice) / yHeight) + PointStartY+SMAHeight;
    }
    if (currentValue==0) {
        currentPointY = -1;
    }
    
    CGPoint currentPoint =  CGPointMake(PointStartX, currentPointY); // 换算到当前的坐标值
    model = nil;
    charModel = nil;
    return currentPoint;
}

#pragma mark 计算BOLL坐标
/*
 BOLL_DOWN BOLL_UP BOLL_MIDDLE
 */
-(CGPoint)changeBOOLPointWithModel:(FMKLineModel*)model Type:(NSString*)type DaysChartModel:(DaysChartModel*)charModel StartX:(CGFloat)startX{
    CGFloat PointStartX = startX; // 起始点坐标
    CGFloat PointStartY = kStagePaddingTop;
    
    CGFloat currentValue = [charModel.BOLL_DOWN floatValue];// 得到前五天的均价价格
    if ([type isEqualToString:@"BOLL_DOWN"]) {
        currentValue = [charModel.BOLL_DOWN floatValue];
    }
    if ([type isEqualToString:@"BOLL_UP"]) {
        currentValue = [charModel.BOLL_UP floatValue];
    }
    if ([type isEqualToString:@"BOLL_MIDDLE"]) {
        currentValue = [charModel.BOLL_MIDDLE floatValue];
    }
    if (currentValue>=CGFLOAT_MAX) {
        return CGPointMake(0, CGFLOAT_MAX);
    }
    // 换算成实际的坐标
    CGFloat yHeight = model.maxPrice - model.minPrice ; // y的价格高度
    CGFloat yViewHeight = model.height/3*2 - kStagePaddingTop - kStagePaddingBottom;// y的实际像素高度
    
    // 换算成实际的坐标
    CGFloat currentPointY = yViewHeight * (1 - (currentValue - model.minPrice) / yHeight) + PointStartY;
    if (model.type>0 && model.kLineDirectionStyle==FMKLineDirection_Vertical)
    {
        yViewHeight = model.height/3*2 - kStagePaddingTop - kStagePaddingBottom-SMAHeight;
        currentPointY = yViewHeight * (1 - (currentValue - model.minPrice) / yHeight) + PointStartY+SMAHeight;
    }
    if (currentValue<=0) {
        currentPointY = -1;
    }
    model = nil;
    charModel = nil;
    CGPoint currentPoint =  CGPointMake(PointStartX, currentPointY); // 换算到当前的坐标值
    return currentPoint;
}

#pragma mark 计算MACD坐标
/*
 DIF DEA
 */
-(CGPoint)changeMACDPointWithModel:(FMKLineModel*)model DaysChartModel:(DaysChartModel*)charModel Type:(NSString*)type StartX:(CGFloat)startX{
    
    CGFloat PointStartX = startX;         // 起始点坐标
    
    CGFloat currentValue = 0;// 得到
    if ([type isEqualToString:@"DIF"]) {
        currentValue = [charModel.MACD_DIF floatValue];
    }
    if ([type isEqualToString:@"DEA"]) {
        currentValue = [charModel.MACD_DEA floatValue];
    }
    // 换算成实际的坐标
    CGFloat yHeight = model.bottomMaxPrice - model.bottomMinPrice ; // y的价格高度
    
    CGFloat yViewHeight = model.height/3-16;// y的实际像素高度
    // 换算成实际的坐标
    CGFloat currentPointY = yViewHeight * (1 - (currentValue - model.bottomMinPrice) / yHeight)+(_model.height/3*2+16);
    if(model.kLineDirectionStyle==FMKLineDirection_Vertical && model.type>0)
    {
        yViewHeight = model.height/3-SMAHeight;
        currentPointY = yViewHeight * (1 - (currentValue - model.bottomMinPrice) / yHeight)+(_model.height/3*2+SMAHeight);
    }
    
    if (![LTUtils isPureFloat:[NSString stringWithFormat:@"%f",currentValue]] || ![LTUtils isPureFloat:[NSString stringWithFormat:@"%f",currentPointY]]) {
        return CGPointMake(0, CGFLOAT_MAX);;
    }
    if (currentValue>=CGFLOAT_MAX) {
        return CGPointMake(0, CGFLOAT_MAX);;
    }
    
    CGPoint currentPoint =  CGPointMake(PointStartX, currentPointY); // 换算到当前的坐标值
    model = nil;
    charModel = nil;
    return currentPoint;
}
#pragma mark 单独计算MACD M值坐标
-(NSArray*)changeMACD_MPointWithModel:(FMKLineModel*)model DaysChartModel:(DaysChartModel*)charModel StartX:(CGFloat)startX{
    CGFloat PointStartX = startX;         // 起始点坐标
    CGFloat currentValue = 0;// 得到
    currentValue = [charModel.MACD_M floatValue];
    // 换算成实际的坐标
    CGFloat yHeight = model.bottomMaxPrice - model.bottomMinPrice ; // y的价格高度
    CGFloat yViewHeight = model.height/3-16;// y的实际像素高度
    // 换算成实际的坐标
    CGFloat currentPointY = yViewHeight * (1 - (currentValue - model.bottomMinPrice) / yHeight);
    if(model.kLineDirectionStyle==FMKLineDirection_Vertical)
    {
        yViewHeight = model.height/3-SMAHeight;
        currentPointY = yViewHeight * (1 - (currentValue - model.bottomMinPrice) / yHeight)+SMAHeight+kStagePaddingTop;
    }
    
    if (![LTUtils isPureFloat:[NSString stringWithFormat:@"%f",currentValue]] || ![LTUtils isPureFloat:[NSString stringWithFormat:@"%f",currentPointY]]) {
        return [NSArray new];
    }
    if (currentValue>=CGFLOAT_MAX) {
        return [NSArray new];
    }
    
    // 如果是M线则单独处理
    // 0点的位置
    CGFloat sub = (_model.height/3*2+16);
    if (model.kLineDirectionStyle==FMKLineDirection_Vertical)
    {
        sub=kStagePaddingTop+(_model.height/3*2+SMAHeight);
    }
    CGFloat startPointY = yViewHeight * (model.bottomMaxPrice - 0) / yHeight;
    CGPoint openPoint = CGPointMake(PointStartX, 0);
    CGPoint closePoint = CGPointMake(PointStartX, 0);
    CGPoint heightPoint = CGPointMake(PointStartX, 0);
    CGPoint lowPoint = CGPointMake(PointStartX, 0);
    if (currentValue>0.0) {
        // 在0点的上面
        CGFloat endPointY = startPointY * (1-(currentValue-0)/(model.bottomMaxPrice-0)) ;
        openPoint = CGPointMake(PointStartX, startPointY+sub);
        closePoint = CGPointMake(PointStartX, endPointY+sub);
        heightPoint = CGPointMake(PointStartX, endPointY);
        lowPoint = CGPointMake(PointStartX, startPointY);
    }else{
        // 在0点的下面
        CGFloat endPointY = startPointY + (yViewHeight - startPointY) * (1-(currentValue-model.bottomMinPrice)/(0-model.bottomMinPrice)) ;
        openPoint = CGPointMake(PointStartX, startPointY+sub);
        closePoint = CGPointMake(PointStartX, endPointY+sub);
        heightPoint = CGPointMake(PointStartX, endPointY);
        lowPoint = CGPointMake(PointStartX, startPointY);
    }
    
    // 实际坐标组装为数组
    NSArray *currentArray = [[NSArray alloc] initWithObjects:
                             NSStringFromCGPoint(heightPoint),
                             NSStringFromCGPoint(lowPoint),
                             NSStringFromCGPoint(openPoint),
                             NSStringFromCGPoint(closePoint),
                             [NSNumber numberWithBool:NO],
                             nil];
    model = nil;
    charModel = nil;
    return currentArray;
}

#pragma mark 把KDJ数据换算成实际的点坐标数组  K D J
-(CGPoint)changeKDJPointWithModel:(FMKLineModel*)model Type:(NSString*)type DaysChartModel:(DaysChartModel*)charModel StartX:(CGFloat)startX{
    
    CGFloat PointStartX = startX; // 起始点坐标
    CGFloat currentValue = 0;// 得到
    if ([type isEqualToString:@"K"]) {
        currentValue = [charModel.KDJ_K floatValue];
    }
    if ([type isEqualToString:@"D"]) {
        currentValue = [charModel.KDJ_D floatValue];
    }
    if ([type isEqualToString:@"J"]) {
        currentValue = [charModel.KDJ_J floatValue];
    }
    
    // 换算成实际的坐标
    // 换算成实际的坐标
    CGFloat yHeight = model.bottomMaxPrice - model.bottomMinPrice ; // y的价格高度
    CGFloat yViewHeight = model.height/3-16;// y的实际像素高度
    // 换算成实际的坐标
    CGFloat currentPointY = yViewHeight * (1 - (currentValue - model.bottomMinPrice) / yHeight)+(_model.height/3*2+16);
    if(model.kLineDirectionStyle==FMKLineDirection_Vertical && model.type>0)
    {
        yViewHeight = model.height/3-SMAHeight;
        currentPointY = yViewHeight * (1 - (currentValue - model.bottomMinPrice) / yHeight)+(_model.height/3*2+SMAHeight)+kStagePaddingTop;
    }
    
    if (![LTUtils isPureFloat:[NSString stringWithFormat:@"%f",currentValue]] || ![LTUtils isPureFloat:[NSString stringWithFormat:@"%f",currentPointY]]) {
        return CGPointMake(0, CGFLOAT_MAX);
    }
    if (currentValue>=CGFLOAT_MAX) {
        return CGPointMake(0, CGFLOAT_MAX);
    }
    if (currentValue==0) {
        currentPointY = CGFLOAT_MAX;
    }
    
    CGPoint currentPoint =  CGPointMake(PointStartX, currentPointY); // 换算到当前的坐标值
    model = nil;
    charModel = nil;
    return currentPoint;
}

#pragma mark 把RSI数据换算成实际的点坐标数组  RSI_1 RSI_2
-(CGPoint)changeRSIPointWithModel:(FMKLineModel*)model Type:(NSString*)type DaysChartModel:(DaysChartModel*)charModel StartX:(CGFloat)startX{
    
    CGFloat PointStartX = startX; // 起始点坐标
    CGFloat currentValue = 0;// 得到
    if ([type isEqualToString:@"RSI_1"]) {
        currentValue = [charModel.RSI_1 floatValue];
    }
    if ([type isEqualToString:@"RSI_2"]) {
        currentValue = [charModel.RSI_2 floatValue];
    }
    if ([type isEqualToString:@"RSI_3"]) {
        currentValue = [charModel.RSI_3 floatValue];
    }
    // 换算成实际的坐标
    CGFloat yHeight = model.bottomMaxPrice - model.bottomMinPrice ; // y的价格高度
    CGFloat yViewHeight = model.height/3-15;// y的实际像素高度
    // 换算成实际的坐标
    CGFloat currentPointY = yViewHeight * (1 - (currentValue - model.bottomMinPrice) / yHeight)+(_model.height/3*2+16);
    if(model.kLineDirectionStyle==FMKLineDirection_Vertical && model.type>0)
    {
        yViewHeight = model.height/3-SMAHeight;
        currentPointY = yViewHeight * (1 - (currentValue - model.bottomMinPrice) / yHeight)+(_model.height/3*2+SMAHeight)+kStagePaddingTop;
    }
    
    if (![LTUtils isPureFloat:[NSString stringWithFormat:@"%f",currentValue]] || ![LTUtils isPureFloat:[NSString stringWithFormat:@"%f",currentPointY]]) {
        return CGPointMake(0, CGFLOAT_MAX);
    }
    if (currentValue>=CGFLOAT_MAX) {
        return CGPointMake(0, CGFLOAT_MAX);
    }
    if (currentValue==0) {
        currentPointY = CGFLOAT_MAX;
    }
    
    CGPoint currentPoint =  CGPointMake(PointStartX, currentPointY); // 换算到当前的坐标值
    model = nil;
    charModel = nil;
    return currentPoint;
}

#pragma mark 计算天玑线做空信号
/*
 
 */

-(BOOL)downFromTianjiData:(FMKLineModel*)model DaysChartModel:(DaysChartModel*)charModel Days:(int)day{
    BOOL isDown = NO;
    // 最高价
    CGFloat heightPrice = [charModel.heightPrice floatValue];
    // 布林高轨
    CGFloat BOLL_Top = [charModel.BOLL_UP floatValue];
    // KDJ K值
    CGFloat KDJ_K = [charModel.KDJ_K floatValue];
    // 2小时前最高价
    CGFloat heightPrice_TwoHour_Front = [self getHeightPriceWithDays:day N:2 BackOrFront:YES];
    // 2小时后最高价
    CGFloat heightPrice_TwoHour_Back = [self getHeightPriceWithDays:day N:2 BackOrFront:NO];
    
    if (model.tianjiLineType ==FMKLineTianjiLineType_Shock) {
        if (heightPrice>=BOLL_Top &&
            KDJ_K>kStockTianjiKDJ_K_Max &&
            heightPrice>heightPrice_TwoHour_Front &&
            heightPrice>heightPrice_TwoHour_Back &&
            heightPrice_TwoHour_Back>0 &&
            heightPrice_TwoHour_Front>0) {
            
            isDown = YES;
        }
    }else{
        if (KDJ_K>kStockTianjiKDJ_K_Max &&
            heightPrice>heightPrice_TwoHour_Front &&
            heightPrice>heightPrice_TwoHour_Back &&
            heightPrice_TwoHour_Back>0 &&
            heightPrice_TwoHour_Front>0) {
            
            isDown = YES;
        }
    }
    
    
    return isDown;
}
#pragma mark 计算天玑线做多信号
/**
 震荡版
 【“在最低价位置画做多信号（下方信号）图标“应满足条件】
 最低价<=BOTTOM
 AND  K<30
 AND  最低价<2小时（对应的k线数据）前的最低价和1小时（对应的k线数据）前的最低价的较小值
 AND  最低价<2小时（对应的k线数据）后的最低价和1小时（对应的k线数据）后的最低价的较小值时,
 （并在对应K线的最低价位置画水平线——支撑线）
 趋势版
 均线1>均线2
 AND K<40
 AND  L<2日前的最低价和1日前的最低价的较小值
 AND  L<2日后的最低价和1日后的最低价的较小值
 */

-(BOOL)upFromTianjiData:(FMKLineModel*)model DaysChartModel:(DaysChartModel*)charModel Days:(int)day{
    BOOL isUp = NO;
    // 最低价
    CGFloat lowPrice = [charModel.lowPrice floatValue];
    if (ceil(lowPrice)==2201) {
        NSLog(@"");
    }
    // 布林高轨
    CGFloat BOLL_Bottom = [charModel.BOLL_DOWN floatValue];
    // KDJ K值
    CGFloat KDJ_K = [charModel.KDJ_K floatValue];
    // 2小时前较低价
    CGFloat lowPrice_TwoHour_Front = [self getLowPriceWithDays:day N:2 BackOrFront:YES];
    // 2小时后较低价
    CGFloat lowPrice_TwoHour_Back = [self getLowPriceWithDays:day N:2 BackOrFront:NO];
    
    if (model.tianjiLineType ==FMKLineTianjiLineType_Shock) {
        if (lowPrice<=BOLL_Bottom &&
            KDJ_K<kStockTianjiKDJ_K_Min &&
            lowPrice<lowPrice_TwoHour_Front &&
            lowPrice<lowPrice_TwoHour_Back &&
            lowPrice_TwoHour_Front<CGFLOAT_MAX &&
            lowPrice_TwoHour_Back<CGFLOAT_MAX) {
            
            isUp = YES;
        }
    }else{
        if (KDJ_K<kStockTianjiKDJ_K_Min &&
            lowPrice<lowPrice_TwoHour_Front &&
            lowPrice<lowPrice_TwoHour_Back &&
            lowPrice_TwoHour_Front<CGFLOAT_MAX &&
            lowPrice_TwoHour_Back<CGFLOAT_MAX) {
            
            isUp = YES;
        }
    }
    return isUp;
}
#pragma mark 取得临近N天(或者N时期)的最高价
/**
 @param days : 当前时间点
 @param N: 前几个时期或者后几个时期
 @param BackOrFront:前几个周期或者后几个周期
 */
-(CGFloat)getHeightPriceWithDays:(int)days N:(int)n BackOrFront:(BOOL)back
{
    int startIndex = days - n;
    int endIndex = days;
    if (back) {
        startIndex = days + 1;
        endIndex = days + n + 1;
    }
    CGFloat heightPrice = 0;
    if (endIndex>=_model.prices.count) {
        return heightPrice;
    }
    if (startIndex<0) {
        return heightPrice;
    }
    if ([[[_model.prices objectAtIndex:endIndex] objectForKey:@"closePrice"] floatValue]<=0) {
        return heightPrice;
    }
    // 计算周期内的较大值
    for (int i=startIndex; i<endIndex; i++) {
        NSDictionary *item = [_model.prices objectAtIndex:i];
        DaysChartModel *m = [[DaysChartModel alloc] initWithDic:item];
        CGFloat tempPrice = [m.heightPrice floatValue];
        if (tempPrice>heightPrice) {
            heightPrice = tempPrice;
        }
        m = nil;
        item = nil;
    }
    return heightPrice;
}
#pragma mark 取得临近N个周期的最低价
-(CGFloat)getLowPriceWithDays:(int)days N:(int)n BackOrFront:(BOOL)back
{
    int startIndex = days - n;
    int endIndex = days;
    if (back) {
        startIndex = days + 1;
        endIndex = days + n + 1;
    }
    CGFloat lowPrice = CGFLOAT_MAX;
    if (endIndex>=_model.prices.count) {
        return lowPrice;
    }
    if (startIndex<0) {
        return lowPrice;
    }
    if ([[[_model.prices objectAtIndex:endIndex] objectForKey:@"closePrice"] floatValue]<=0) {
        return lowPrice;
    }
    // 计算周期内的较小值
    for (int i=startIndex; i<endIndex; i++) {
        NSDictionary *item = [_model.prices objectAtIndex:i];
        DaysChartModel *m = [[DaysChartModel alloc] initWithDic:item];
        CGFloat tempPrice = [m.lowPrice floatValue];
        if (tempPrice<lowPrice) {
            lowPrice = tempPrice;
        }
        m = nil;
        item = nil;
    }
    return lowPrice;
}
@end
