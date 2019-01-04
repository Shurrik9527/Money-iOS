//
//  WeiPanMarketViewController+ChartHelp.m
//  ixit
//
//  Created by Brain on 2016/11/27.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "WeiPanMarketViewController+ChartHelp.h"
#import "WeiPanMarketViewController+ModelHelp.h"
#import "WeiPanMarketViewController+PushRemindHelp.h"
#import "FMStockIndexs.h"
@implementation WeiPanMarketViewController (ChartHelp)

#pragma mark - create chart
-(void)createDaysChart {
    [self removeChart];
    [self initDaysModel];
    self.dayschart = [[FMKLineChart alloc] initWithFrame:CGRectMake(0, 0, self.model.width, self.model.height) Model:self.model];
    self.dayschart.backgroundColor=KLineBoxBG;
    self.dayschart.isBlack=YES;
    [self.dayschart start];
    [self.klinebox addSubview:self.dayschart];
    WS(ws);
    // 手指滑动，更新盘口
    self.dayschart.crossLineTipBlock = ^(DaysChartModel *mchar,BOOL isfinish){
        ws.stockDish.open = mchar.openPrice;
        ws.stockDish.lastclose = mchar.closePrice;
        ws.stockDish.high = mchar.heightPrice;
        ws.stockDish.low = mchar.lowPrice;
        ws.stockDish.quotetime = [NSNumber numberWithDouble:[mchar.time integerValue]];
        if (mchar && !isfinish) {
        //    [ws updateHeaderView:YES];
            if (ws.fmKlineDirectionStyle==FMKLineDirection_Horizontal) {
                [ws.horizontalHeaderView updatePriceViewsWithDatas:mchar];
            }
        }else{
            mchar = nil;
            if (ws.fmKlineDirectionStyle==FMKLineDirection_Horizontal) {
                [ws.horizontalHeaderView updatePriceViewsWithDatas:mchar];
            }
        }
    };
    [self.candleList removeAllObjects];
    [self getDaysStockData];
    if(self.model.kLineDirectionStyle==FMKLineDirection_Vertical) {
        [self initSMAKindView];
        [self initMACDKindView];
    }
}
#pragma mark - update chart
-(void)updateMinuteChart {
    CGFloat w = self.klinebox.w_;
    CGFloat h = self.klinebox.h_-16;
    self.minutemodel.kLineDirectionStyle = self.fmKlineDirectionStyle;
    self.minutemodel.isStopDraw = NO;
    self.minutemodel.width = w;
    self.minutemodel.height = h;
    self.minutechart.frame = CGRectMake(0, 0, self.minutemodel.width, self.minutemodel.height);
    [self.minutechart updateWithModel:self.minutemodel];
    // 左边菜单
    [self createHorizontalIndexNavViews];
}
//接收到长链接数据刷新view
-(void)updateMinuteViewForSocket {
    NSString *timeStr = [NSString stringWithFormat:@"%@",self.stockDish.quotetime];
    timeStr=[timeStr substringToIndex:10];
    NSNumber *time = [NSNumber numberWithInteger:(timeStr.integerValue/60*60)];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         self.stockDish.sell,@"transationPrice",
                         self.stockDish.sell,@"closePrice",
                         @"0.0000",@"volume",
                         self.stockDish.high,@"heightPrice",
                         self.stockDish.low,@"lowPrice",
                         self.stockDish.open,@"openPrice",
                         time,@"time",
                         nil];
    
    NSNumber *lastTime =  [[self.priceList lastObject] objectForKey:@"time"];
    
    NSInteger timeNum = [LTUtils timeNumberWithType:self.type];
    NSInteger lastTimeNum = lastTime.integerValue/timeNum;
    if (time.integerValue/timeNum - lastTimeNum<1) {
        NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              self.stockDish.sell,@"transationPrice",
                              self.stockDish.sell,@"closePrice",
                              @"0.0000",@"volume",
                              self.stockDish.high,@"heightPrice",
                              self.stockDish.low,@"lowPrice",
                              self.stockDish.open,@"openPrice",
                              lastTime,@"time",
                              nil];
        [self.priceList replaceObjectAtIndex:self.priceList.count-1 withObject:dic1];
        dic=nil;
        dic1=nil;
    } else {
        [self.priceList addObject:dic];
        dic=nil;
    }
    self.minutemodel.prices = self.priceList;
    self.minutemodel.yestodayClosePrice = [self.stockDish.lastclose floatValue];
    self.minutemodel.startTime = self.stockDish.start;
    self.minutemodel.endTime = self.stockDish.end;
    self.minutemodel.middleTime = self.stockDish.middle;
    if ([self.minutechart respondsToSelector:@selector(updateWithModel:)]) {
        if (self.minutemodel) {
            [self.minutechart updateWithModel:self.minutemodel];
        }
        self.minutechart.backgroundColor=KLineBoxBG;
    }
    [self reqTickChartIsSuccess:YES];
}

-(void)updateDaysChart {
    CGFloat w = self.klinebox.w_;
    CGFloat h = self.klinebox.frame.size.height;
    CGFloat x = 0;
    CGFloat y = 0;
    // 横屏
    if (self.fmKlineDirectionStyle == FMKLineDirection_Horizontal) {
        w = Screen_height-kLineChartView_LeftNavViewWidth;
        h = Screen_width-kNavigationHeight-kLineChart_nav_height;
    }
    self.model.width = w;
    self.model.height = h;
    self.model.isReset = YES;
    self.model.isStopDraw = NO;
    self.model.kLineDirectionStyle = self.fmKlineDirectionStyle;
    self.model.tianjiLineType = FMKLineTianjiLineType_None;
    self.model.isHasLastTianji = NO;
    self.dayschart.frame = CGRectMake(x, y, self.model.width, self.model.height);

    [self.dayschart updateWithModel:self.model];
    self.klinebox.backgroundColor=KLineBoxBG;
    self.dayschart.backgroundColor=KLineBoxBG;
    self.dayschart.isBlack=YES;
    // 左边菜单
    [self createHorizontalIndexNavViews];
}
#pragma mark - socket update
-(void)updateDaysViewForSocket {
    //获取时间间隔
    NSInteger timeNum =  [LTUtils timeNumberWithType:self.type];
    if (timeNum>=60*60*24*7) {
        return;
    }
    //获取最后一个数据
    NSDictionary *lastDic=[self.candleList lastObject];
    if (![kPublicData isNull:lastDic] && self.model.isFinished) {
        return;
    }
    
    //获取当前时间
    NSString *timeStr = [NSString stringWithFormat:@"%@",self.stockDish.quotetime];
    timeStr=[timeStr substringToIndex:10];
    BOOL isAdd=[self isAddTimeCacular];
    
    NSString *open=[lastDic objectForKey:@"open"];
    NSString *heigh=self.stockDish.sell.floatValue>[[lastDic objectForKey:@"high"] floatValue]?self.stockDish.sell :[lastDic objectForKey:@"high"];
    NSString *low=self.stockDish.sell.floatValue<[[lastDic objectForKey:@"low"] floatValue]?self.stockDish.sell :[lastDic objectForKey:@"low"];
    NSString *lastTimeStr=[lastDic objectForKey:@"time"];

    NSString *close=self.stockDish.sell;
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    if (isAdd) {
        NSDictionary *lastDic=[self.candleList lastObject];//获取最后一个数据
        NSString *lastTime =  [lastDic objectForKey:@"time"];//对比时间差
        NSInteger lastTimeNum = [LTUtils timeformat_shortTime:lastTime];
        NSInteger newTime = lastTimeNum + timeNum;
        
        NSString *timeStr = [NSString stringWithFormat:@"%@",self.stockDish.quotetime];
        timeStr=[timeStr substringToIndex:10];
        NSInteger timeDouble = timeStr.doubleValue;
        NSString *time = [LTUtils timeFormat_ShortHourStyle:timeStr.doubleValue];
        if (newTime>timeDouble) {
            NSInteger n = (timeDouble-lastTimeNum)/timeNum+1;
            newTime =lastTimeNum +n*timeNum;
        }
        time = [LTUtils timeFormat_ShortHourStyle:newTime];

        //添加
        [dic setObject:self.stockDish.sell forKey:@"open"];
        [dic setObject:self.stockDish.sell forKey:@"high"];
        [dic setObject:self.stockDish.sell forKey:@"low"];
        [dic setObject:close forKey:@"close"];
        [dic setObject:@"0.0000" forKey:@"volume"];
        [dic setObject:time forKey:@"time"];
        [self candleListWithLastData:dic isAdd:YES];
    }else {
        //替换
        [dic setObject:open forKey:@"open"];
        [dic setObject:heigh forKey:@"high"];
        [dic setObject:low forKey:@"low"];
        [dic setObject:close forKey:@"close"];
        [dic setObject:@"0.0000" forKey:@"volume"];
        [dic setObject:lastTimeStr forKey:@"time"];
        [self candleListWithLastData:dic isAdd:NO];
    }
    
    NSDictionary *data = [FMKLineModel dictWithList:self.candleList type:self.type];
    
    // 缓存处理
    NSMutableArray *list = [NSMutableArray arrayWithArray:[data arrayFoKey:@"list"]];
    NSMutableDictionary *item=[list lastObject];
//    NSMutableDictionary *item = [FMStockIndexs klineItemWithArray:list Dictionary:[list lastObject] index:list.count-1 KDJ:nil];
    
    NSMutableArray *prices=[[NSMutableArray alloc]init];
    NSMutableArray *newArr=[[NSMutableArray alloc]initWithArray:self.model.prices];
    for(NSMutableDictionary *dic in newArr) {
        if (![[dic objectForKey:@"MACD_DIF"]isEqualToString:[NSString stringWithFormat:@"%f",CGFLOAT_MAX]]) {
            [prices addObject:dic];
        }
    }
    
    NSMutableDictionary *KDJ = [FMStockIndexs getKDJMap:list];
    item = [FMStockIndexs klineItemWithArray:prices Dictionary:item index:prices.count-1 KDJ:KDJ];
    NSDictionary *ld=[self.candleList lastObject];
    NSString *lt = [ld stringFoKey:@"t"];
    NSLog(@"ld = %@   lt = %f",ld,[LTUtils timeformat_shortTime:lt]);

    if (isAdd) {
        if (prices.count>=300) {
            [prices removeObjectAtIndex:0];
        }
        [prices addObject:item];
    }else {
        [prices replaceObjectAtIndex:prices.count-1 withObject:item];
    }
//    if (timeNum<=60) {
//        if (timesub <timeNum) {
//            [prices replaceObjectAtIndex:prices.count-1 withObject:item];
//        } else {
//            [prices removeObjectAtIndex:0];
//            [prices addObject:item];
//        }
//    } else if (timeNum == 60*60*24){
//        [prices replaceObjectAtIndex:prices.count-1 withObject:item];
//    } else {
//        if (timesub <0) {
//            [prices replaceObjectAtIndex:prices.count-1 withObject:item];
//        } else {
//            [prices removeObjectAtIndex:0];
//            [prices addObject:item];
//        }
//    }
    for (int i=0; i<self.model.leftEmptyKline; i++) {
        NSDictionary *emptyKline = [self getEmptyKLine];
        [prices insertObject:emptyKline atIndex:0];
        [prices addObject:emptyKline];
    }
    self.model.prices=prices;
    [self.dayschart updateWithModel:self.model];
    
    [self.tableview.header endRefreshing];
    [self.transform stop];
    self.klineNavView.isFinish = YES;
}
-(void)removeChart {
    if (self.dayschart) {
        [self.dayschart removeFromSuperview];
        self.dayschart = nil;
        self.model = nil;
    }
    if (self.minutechart) {
        [self.minutechart removeFromSuperview];
        self.minutechart = nil;
        self.minutemodel = nil;
    }
}
#pragma mark - utils
//填充空K
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
//candleList替换或者添加操作。
-(void)candleListWithLastData:(NSDictionary *)dic isAdd:(BOOL)isAdd{
    if (isAdd) {
        NSLog(@"time = %@",[dic stringFoKey:@"t"]);
        [self.candleList addObject:dic];
        if (self.candleList.count>300) {
            [self.candleList removeObjectAtIndex:0];
        }
    }else{
        NSLog(@"last time = %@",[dic stringFoKey:@"t"]);
        [self.candleList replaceObjectAtIndex:self.candleList.count-1 withObject:dic];
    }
}
//通过计算时间得出是添加YES还是替换NO数据
-(BOOL)isAddTimeCacular{
    BOOL isAdd=NO;
    if (self.candleList.count>0) {
        NSInteger timeNum = [LTUtils timeNumberWithType:self.type];//根据type计算出每个项之间的时间差为多少
        //获取当前时间
        NSString *timeStr = [NSString stringWithFormat:@"%@",self.stockDish.quotetime];
        timeStr=[timeStr substringToIndex:10];
        NSString *time = [LTUtils timeforMin:[timeStr doubleValue]];
        NSDictionary *lastDic=[self.candleList lastObject];//获取最后一个数据
        NSString *lastTime =  [lastDic objectForKey:@"t"];//对比时间差
        NSInteger lastTimeNum = [LTUtils timeformat_shortTime:lastTime];
        if (timeNum==60*60*24) {
            lastTime=[lastTime substringWithRange:NSMakeRange(lastTime.length-5, 5)];
            lastTime = [NSString stringWithFormat:@"%@ 00:00",lastTime];
            lastTimeNum=[LTUtils timeformat_shortTime:lastTime];
        }
        NSInteger timeCount = timeStr.integerValue;
        NSInteger timesub= timeCount - lastTimeNum;
        NSLog(@" time = %@ lastTime = %@ timesub = %li",time,lastTime , timesub);
        if(timeNum<=60){//1分
            if (timesub <timeNum) {
                isAdd=NO;
            } else {
                isAdd=YES;
            }
        } else if (timeNum == 60*60*24){//日线只替换
            isAdd=NO;
        } else {//其他类型
            if (timesub <0) {
                isAdd=NO;
            } else {
                isAdd=YES;
            }
        }
    }else{
        //无数据时直接添加
        isAdd=YES;
    }
    return isAdd;
}

-(NSInteger)lastTimeNum{
    NSDictionary *lastDic=[self.candleList lastObject];
    NSString *lastTime =  [lastDic objectForKey:@"t"];
    NSInteger lastTimeNum = [LTUtils timeformat_shortTime:lastTime];
    NSInteger timeNum =  [LTUtils timeNumberWithType:self.type];
    if (timeNum==60*60*24) {
        lastTime=[lastTime substringWithRange:NSMakeRange(lastTime.length-5, 5)];
        lastTime = [NSString stringWithFormat:@"%@ 00:00",lastTime];
        lastTimeNum=[LTUtils timeformat_shortTime:lastTime];
    }
    return lastTimeNum;
}
@end
