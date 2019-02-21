//
//  WeiPanMarketViewController+ModelHelp.m
//  ixit
//
//  Created by Brain on 2016/11/27.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "WeiPanMarketViewController+ModelHelp.h"
#import "DataHundel.h"
#import "NetworkRequests.h"
@implementation WeiPanMarketViewController (ModelHelp)
-(void)configStockWithDic:(NSDictionary *)dic {
    if(!self.stockDish) {
        self.stockDish = [[QuotationDetailModel alloc] init];
    }
    [self.stockDish dataWithProductDic:dic];
}

-(void)initMinModel{
    CGFloat w = self.klinebox.frame.size.width;
    CGFloat h = self.klinebox.frame.size.height-16;
    // 横屏
    if (self.fmKlineDirectionStyle == FMKLineDirection_Horizontal)
    {
        w = self.klinebox.frame.size.width;
        h = self.klinebox.frame.size.height-16;
    }
    if(!self.minutemodel) {
        self.minutemodel = [[FMKLineModel alloc] init];
    }
    self.minutemodel.width = w;
    self.minutemodel.height = h;
    self.minutemodel.isShowSide = YES;
    self.minutemodel.isShowMiddleLine = YES;
    self.minutemodel.isHideLeft = NO;
    self.minutemodel.isShadow = YES;
    self.minutemodel.isStopDraw = NO;
    self.minutemodel.startTime = self.stockDish.start;
    self.minutemodel.endTime = self.stockDish.end;
    self.minutemodel.middleTime = self.stockDish.middle;
    self.minutemodel.klineWidth = 1;
    self.minutemodel.kLineDirectionStyle = self.fmKlineDirectionStyle;
    self.minutemodel.stockCode = self.code;
}
-(void)initDaysModel{
    if (!self.model) {
        self.model=[[FMKLineModel alloc]init];
    }
    CGFloat w = self.klinebox.frame.size.width;
    CGFloat h = self.klinebox.frame.size.height;
//    CGFloat x = 0;
//    CGFloat y = 0;
    // 横屏
    if (self.fmKlineDirectionStyle == FMKLineDirection_Horizontal) {
        w = self.klinebox.frame.size.width-kLineChartView_LeftNavViewWidth;
        h = self.klinebox.frame.size.height-15;
    }
    self.model.width = w;
    self.model.height = h;
    self.model.isShowSide = YES;
    self.model.isStopDraw = NO;
    self.model.isHideLeft=YES;
    self.model.type = 2;
    self.model.kLineDirectionStyle = self.fmKlineDirectionStyle;
    self.model.tianjiLineType = FMKLineTianjiLineType_None;
    self.model.stockCode = self.code;
    self.model.stockIndexType=sma_Index-98;
    self.model.stockIndexBottomType=macd_Index-104;
}
#pragma mark - update
-(void)updateMinModelWithStock:(QuotationDetailModel *)stock{
    
}
-(void)updateDaysModelWithStock:(QuotationDetailModel *)stock{
    
}

-(void)getDaysStockData
{
    long long now = [[NSDate date] timeIntervalSince1970] * 1000;
    long  long startTime =now - self.type.longLongValue * 60000 * 50;
    NSNumber *nowNumber = [NSNumber numberWithLongLong:now];
    NSNumber * StartNumber =[NSNumber numberWithLongLong:startTime];
    NSString* nowStr = [DataHundel ConvertStrToTime:nowNumber.stringValue];
    NSString * startStr =[DataHundel ConvertStrToTime:StartNumber.stringValue];
    NSString * endStr = nowStr;
    NSString * url = [NSString stringWithFormat:@"%@%@?symbol=%@&startDate=%@&endDate=%@&period=1&server=DEMO",@"http://47.91.164.170:8012",@"/price/records",self.code,startStr,endStr];
    NSLog(@"urlllll ===== %@",url);
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

//    NSString * url = @"http://47.91.164.170:8012/price/records?symbol=USDJPY&startDate=25-01-2019%2012:26:51&endDate=25-01-2019%2013:16:51&period=1&server=DEMO";
//    NSDictionary * dic =@{@"server":@"DEMO",@"symbol":self.code,@"startDate":startStr,@"endDate":nowStr,@"period":self.type};
    [[NetworkRequests sharedInstance] GET:url dict:nil succeed:^(id data) {
        NSLog(@"resssss = %@",data);
        NSMutableArray * dataArray =[NSMutableArray array];
        if ([[data objectForKey:@"dataObject"] isEqual:[NSNull null]]) {
            return ;
        }
        dataArray = [data objectForKey:@"dataObject"];
        if (self.candleList) {
            [self.candleList removeAllObjects];
            self.candleList= nil;
        }
        self.candleList = [NSMutableArray arrayWithArray:dataArray];
        if (dataArray.count > 0) {
            [self hideLoadingView];
            NSDictionary *data = [FMKLineModel dictWithList:self.candleList type:self.type];
            // 缓存处理
            [self getDaysCacheWithDic:data];
            NSMutableArray *list = [NSMutableArray arrayWithArray:[data arrayFoKey:@"list"]];
            self.model.prices = list;
            self.model.klineType = self.type;
            if ([self.dayschart respondsToSelector:@selector(updateWithModel:)]) {
                self.dayschart.isBlack = YES;
                [self.dayschart updateWithModel:self.model];
            }
            list = nil;
            [self.tableview.header endRefreshing];
            [self.transform stop];
            self.klineNavView.isFinish = YES;
        } else {
            [self.tableview.header endRefreshing];
            [self.transform stop];
            self.klineNavView.isFinish = YES;
            [self.dayschart error];
        }
    } failure:^(NSError *error) {

    }];

    
//    WS(ws);
//    [RequestCenter requestKChartWithExcode:ws.excode code:ws.code type:ws.type completion:^(LTResponse *res) {
//
//        NSDictionary *dict = res.resDict;
//        if (ws.candleList) {
//            [ws.candleList removeAllObjects];
//            ws.candleList=nil;
//        }
//        NSArray *candle = [dict arrayFoKey:@"candle"];
//
//        ws.candleList=[[NSMutableArray alloc]initWithArray:candle];
//
//        if (candle.count > 0) {
//            [ws hideLoadingView];
//            NSDictionary *data = [FMKLineModel dictWithList:ws.candleList type:ws.type];
//            // 缓存处理
////            [ws getDaysCacheWithDic:data];
//            NSMutableArray *list = [NSMutableArray arrayWithArray:[data arrayFoKey:@"list"]];
//            ws.model.prices = list;
//            ws.model.klineType= ws.type;
//            if ([ws.dayschart respondsToSelector:@selector(updateWithModel:)]) {
//                ws.dayschart.isBlack=YES;
//                [ws.dayschart updateWithModel:ws.model];
//            }
//            list = nil;
//            [ws.tableview.header endRefreshing];
//            [ws.transform stop];
//            ws.klineNavView.isFinish = YES;
//        } else {
//            [ws.tableview.header endRefreshing];
//            [ws.transform stop];
//            ws.klineNavView.isFinish = YES;
//            [ws.dayschart error];
//        }
//    }];
}
//获取缓存数据
-(void)getDaysCacheWithDic:(NSDictionary*)dic{
    NSString *path = @"stocks";
    NSString *filename = [NSString stringWithFormat:@"stock_%@_%@_%@_cache",self.excode, self.type,self.code];
    //获取应用程序沙盒的Library目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/Caches/%@",path]];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    BOOL isdirectory = YES;
    if (![filemanager fileExistsAtPath:path isDirectory:&isdirectory]) {
        [filemanager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //得到完整的文件名
    NSString *fullFileName=[path stringByAppendingPathComponent:filename];
    
    // 检查文件修改时间
    double timeout = 5*60; // 5分钟更新一遍
    NSError *error = nil;
    NSDictionary *fileAttributes = [filemanager attributesOfItemAtPath:fullFileName error:&error];
    NSDate *fileModDate = [fileAttributes objectForKey:NSFileModificationDate];
    // 缓存时间
    double subtime = fabs([LTUtils compareWithTime:fileModDate TimeTow:[NSDate date]]);
    
//    double subt = fabs([fileModDate timeIntervalSinceNow]);
    
    NSDictionary *cachedic = [LTUtils readCacheWithFileName:filename Path:@"stocks"];
    if (dic) {
        // 保存缓存
        [LTUtils createCacheWithFileName:filename Path:@"stocks" Content:dic];
        
    }
    else{
        // 缓存超时或者没有缓存就请求网络
        if (subtime>timeout)
        {
            [self getDaysStockData]; // 请求网络
        }
        else
        {
            if (cachedic) {
                [self.dayschart start];
                NSMutableArray *list = [cachedic objectForKey:@"list"];
                self.model.prices = list;
                [self.dayschart updateWithModel:self.model];
                [self.tableview reloadData];
                list = nil;
            }
            self.klineNavView.isFinish = YES;
        }
    }
    
    filename = nil;
    filemanager = nil;
    fileAttributes = nil;
    fileModDate = nil;
    cachedic = nil;
    path = nil;
    fullFileName = nil;
}

@end
