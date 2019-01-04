//
//  FMStageView.m
//  golden_iphone
//
//  Created by dangfm on 15/6/11.
//  Copyright (c) 2015年 golden. All rights reserved.
//

#import "FMStageView.h"
#import "DaysChartModel.h"
#import "WeiPanPriceView.h"

@interface FMStageView()<UIScrollViewDelegate>{
    BOOL showVHLine;//是否显示十字线
    BOOL isLastItem;//当前显示的是否是最后一个item
}
@property(retain,nonatomic)FMBaseView *mainBox;                       // 前景
@property(retain,nonatomic)FMBaseView *dateBox;                       // 时间框
@property(retain,nonatomic)FMKLineModel *model;
@property(retain,nonatomic)FMBackgroundScrollView *backgroundView; // 背景
@property(retain,nonatomic)FMKLineChart *chart;                          //表
@property(retain,nonatomic)FMBaseLine *baseLine;                        //线
@property(retain,nonatomic)FMBaseView *touchView;                      //触碰view
@property(retain,nonatomic)FMBaseLine *kLine;
@property(retain,nonatomic)FMBaseView *leftTextViews;                 // 左边文字
@property(retain,nonatomic)FMBaseView *rightTextViews;                // 右边文字
@property(retain,nonatomic)FMBaseView *lineBox;                       // 装线
@property(retain,nonatomic)NSArray *points;
@property(assign,nonatomic)BOOL createFinished;
@property(assign,nonatomic)int scrollCount;            // 滚动次数
@property(assign,nonatomic)float lastScrollX;          // 最后一次滚动的x坐标

@property(retain,nonatomic)UIView *vLine;          // 竖线
@property(retain,nonatomic)UIImageView *hLine;     // 横线
@property(retain,nonatomic)UILabel *tips;          // 提示

@property(retain,nonatomic)UILabel *maxTips;          // 最大
@property(retain,nonatomic)UILabel *minTips;          // 最小
@property(retain,nonatomic)UILabel *maxTipsLine;          // 最大线条
@property(retain,nonatomic)UILabel *minTipsLine;          // 最小线条
@property(copy,nonatomic)NSString *maxValue;          // 最大
@property(copy,nonatomic)NSString *minValue;          // 最小

@property(retain,nonatomic)UILabel *dateTips;      // 日期提示
@property(assign,nonatomic)CGFloat topHeight;      // k线视图高度
@property(assign,nonatomic)CGFloat bottomHeight;   // 指标视图高度
@property(retain,nonatomic)UIView *topTipView;     // k线图顶部 指标信息显示区域
@property(retain,nonatomic)UIView *bottomTipView;  // 副图顶部指标信息显示
@property(retain,nonatomic)UIView *dayTipView;     // 日期时间信息显示
@property(retain,nonatomic)UIView *dragLineViews;  // 阻力线视图
@property(retain,nonatomic)UILabel *dragTip;       // 阻力线价格
@property(retain,nonatomic)DaysChartModel *currentDaysModel;


@property(retain,nonatomic)NSMutableArray *rightViews;            // 价格集合
@property(retain,nonatomic)NSMutableDictionary *indexViews;       // 指标文字集合

//daychart上下部分框
@property(retain,nonatomic)UIView *topBox;
@property(retain,nonatomic)UIView *bottomBox;

//微盘价格刷新view
@property(retain,nonatomic)WeiPanPriceView *priceView;
//百分比tip;
@property(retain,nonatomic)UILabel *rateTips;
@property(retain,nonatomic)NSMutableArray *timeArr;

@property(retain,nonatomic)NSOperationQueue *queue;
//手势
@property(retain,nonatomic)UILongPressGestureRecognizer *longPress;
@property(retain,nonatomic)UITapGestureRecognizer *tap;
@end

@implementation FMStageView
#define MaxLineWidth 8

-(void)dealloc
{
    _mainBox = nil;
    _backgroundView = nil;
    _model = nil;
    _chart = nil;
    [_queue cancelAllOperations];
    _queue=nil;
}

#pragma mark - initView
-(instancetype)initWithFrame:(CGRect)frame Model:(FMKLineModel*)model{
    if (self == [super initWithFrame:frame]) {
        _model = model;
        _createFinished = YES;
        _isBlackBG=NO;
        [self createKLineBox];
        NFC_AddObserver(NFC_WeipanRotation, @selector(reloadlineFrame));
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame Model:(FMKLineModel *)model KLineChart:(FMKLineChart *)chart{
    if (self == [super initWithFrame:frame]) {
        _model = model;
        _chart = chart;
        _createFinished = YES;
//        if (model.type<=0) {
//            showVHLine=NO;
//        }
        isLastItem=NO;
        [self createKLineBox];
        NFC_AddObserver(NFC_WeipanRotation, @selector(reloadlineFrame));
    }
    return self;
}
// 画k线框框
-(void)createKLineBox
{
    // 重新布置舞台
    [self createMainBox];
    // 布置背景
    [self createBackgroundViews];
    // k线图
[self createKlineChartView];
//if(_model.type<=0)[self createMinuteChartView];

}
// 画盒子
-(void)createMainBox
{
    if (!_mainBox)
    {
        // 点击手势
        if(!_tap)
        {
            _tap = [[UITapGestureRecognizer alloc] init];
            [_tap addTarget:self action:@selector(tapHandle:)];
            [self addGestureRecognizer:_tap];
            _tap = nil;
        }
        //长按手势
        if(!_longPress)
        {
            _longPress = [[UILongPressGestureRecognizer alloc] init];
            [_longPress addTarget:self action:@selector(longPressHandle:)];
            [_longPress setMinimumPressDuration:0.5f];
            [_longPress setAllowableMovement:50.0];
            [self addGestureRecognizer:_longPress];
            _longPress = nil;
        }
        
        if(!_mainBox)
        {
            _mainBox = [[FMBaseView alloc] initWithFrame:CGRectMake(0, 0, _model.width, _model.height)];
            [self addSubview:_mainBox];
        }
        if (_isBlackBG) {
            _mainBox.backgroundColor=KLineBoxBG;
        }
        else
        {
            _mainBox.backgroundColor = LTClearColor;
        }
        _mainBox.autoresizesSubviews = YES;
        _mainBox.clipsToBounds = YES;
        
        if (_model.type>0) {
            //K线上半部分 SMA5/SMA10/SMA20/SMA60/SMA120对应的图
            if (!_topBox)
            {
                _topBox = [self createBoxViewWithFrame:CGRectMake(0, 0, _model.width, _model.height/3*2) backgroundColor:KLineBoxBG];
                _topBox.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                [_mainBox addSubview:_topBox];
            }
            //竖屏时的_topBox
            if (_model.kLineDirectionStyle==FMKLineDirection_Vertical)
            {
                _topBox.frame=CGRectMake(0, SMAHeight, _model.width, _model.height/3*2-SMAHeight-16);
            }
            //            // 画中间的横线
            CGFloat w = _model.width;
            //            // 底部分割线
            CGFloat startY = (_model.height/3.0*2) + 16;
            CGFloat subHeight = (_model.height/3 - 15) / 2;
            //K线下半部分 MACD DIF DEA 对应的图
            if (!_bottomBox)
            {
                _bottomBox =[self createBoxViewWithFrame:CGRectMake(0, startY, _model.width, _model.height/3-16) backgroundColor:KLineBoxBG];
                _bottomBox.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                [_mainBox addSubview:_bottomBox];
            }
            //竖屏时的_topBox
            if (_model.kLineDirectionStyle==FMKLineDirection_Vertical)
            {
                startY = (_model.height/3.0*2) + SMAHeight;
                _bottomBox.frame=CGRectMake(0, startY, _model.width, _model.height/3.0-SMAHeight);
                subHeight = _bottomBox.frame.size.height/2.0;
            }
            //            // 副视图分割线
            for (int i=0; i<=2; i++) {
                FMBaseView *v = [self createSingleViewWithFrame:CGRectMake(0, (i*subHeight), w, kStageLineWidth) Color:kStageLineColor];
                v.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                [_bottomBox addSubview:v];
                v = nil;
            }
            _topBox = nil;
            _bottomBox = nil;
            
        }
        else
        {
            // 分时图的框框
            if (!_topBox)
            {
                _topBox =[self createBoxViewWithFrame:CGRectMake(0, 0, _model.width, _model.height) backgroundColor:LTClearColor];
                [_mainBox addSubview:_topBox];
            }
            if (!_lineBox) {
                _lineBox = [[FMBaseView alloc] initWithFrame:_topBox.frame];
                [_mainBox addSubview:_lineBox];
            }
            [self reloadlineFrame];
        }
        
    }
    else
    {
        _mainBox.frame = CGRectMake(0, 0, _model.width, _model.height);
    }
    //添加价格详情浮层
    if (_model.type>0)
    {
        [self createWeipanPriceView];
        _rateTips.hidden=YES;
        _dateTips.hidden=YES;
    }
    
    // 主图指标显示
    if (!_topTipView && _model.type>0) {
        _topTipView = [[UIView alloc] initWithFrame:CGRectMake(2, 0, _model.width, 12)];
        _topTipView.backgroundColor = KLineBoxBG;
        if(_isBlackBG)
        {
            _topTipView.backgroundColor = KLineBoxBG;
            self.backgroundColor=KLineBoxBG;
        }
        [self addSubview:_topTipView];
    }
    // 副图指标显示
    if (!_bottomTipView && _model.type>0) {
        _bottomTipView = [[UIView alloc] initWithFrame:CGRectMake(2, _model.height/3*2, _model.width, 12)];
        _bottomTipView.backgroundColor = KLineBoxBG;
        if(_isBlackBG)
        {
            _bottomTipView.backgroundColor = KLineBoxBG;
        }
        [self addSubview:_bottomTipView];
    }
    _bottomTipView.frame = CGRectMake(44, _model.height/3*2+1+SMAHeight, _model.width, 12);
    _topTipView.frame = CGRectMake(44, SMAHeight+1, _model.width/2, _topTipView.frame.size.height);
    if (_model.kLineDirectionStyle==FMKLineDirection_Horizontal)
    {
        _topTipView.frame = CGRectMake(_topTipView.frame.origin.x, 5, _model.width/2, _topTipView.frame.size.height);
        _bottomTipView.frame = CGRectMake(_bottomTipView.frame.origin.x, _model.height/3*2+16, _model.width/2, _bottomTipView.frame.size.height);
    }
    if (_isBlackBG)
    {
        _bottomTipView.backgroundColor = KLineBoxBG;
        _topTipView.backgroundColor=KLineBoxBG;
    }
    // 首次模型
    _points = [_model.points objectForKey:kStockPointsKey_KLine];
    int lastIndex = (int)_points.count-_model.rightEmptyKline-1;
    if (_model.offsetEnd<_points.count-1)
    {
        lastIndex = _model.offsetEnd;
    }
    if (lastIndex<=0) {
        lastIndex =0;
    }
    NSArray *last = [_points objectAtIndex:lastIndex];
    if ([last isNotNull]) {
        _currentDaysModel = (DaysChartModel*)[last objectAtIndex:last.count-2];
        last = nil;
    }
    
    // 界面视图更新放入线程
    if (!_queue)
    {
        _queue = [NSOperationQueue new];
        _queue.maxConcurrentOperationCount = 1;
    }
    [_queue cancelAllOperations];
    NSBlockOperation *opration = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateStockIndexTip];
            // 周边提示文字
            if(_model.type>0) [self createPriceTipViews];//非分时的文字
            if(_model.type==0)[self createMinutePriceTipView];//分时
        });
        
    }];
    [_queue addOperation:opration];
    opration = nil;
}

// 创建舞台背景
-(void)createBackgroundViews
{
    if (!_backgroundView)
    {
        _backgroundView = [[FMBackgroundScrollView alloc] initWithFrame:CGRectMake(0, 0, _model.width, _model.height) Model:_model];
        _backgroundView.delegate = self;
        _backgroundView.showsHorizontalScrollIndicator = NO;
        _backgroundView.showsVerticalScrollIndicator = NO;
        _backgroundView.clipsToBounds = YES;
        //NO 发送滚动的通知 但是就算手指移动 scroll也不会动了 YES 发送通知 scroll可以移动
        [_backgroundView setCanCancelContentTouches:YES];
        //[_backgroundView setBounces:NO];
        // NO 立即通知touchesShouldBegin:withEvent:inContentView 看是否滚动 scroll
        [_backgroundView setDelaysContentTouches:NO]; // 这句是关键，默认为YES，不设为NO则touchesShouldBegin:withEvent:inContentView:可能不被回调
        if (_isBlackBG) {
            _backgroundView.backgroundColor=KLineBoxBG;
        }
        _backgroundView.bounces=YES;
        [_mainBox addSubview:_backgroundView];
//        __unsafe_unretained FMStageView *sv = self;
        WS(sv);
        _backgroundView.zoomingBlock = ^(FMKLineModel*m,CGFloat scale)
        {
            // 放大
            [sv.chart updateWithModel:m];
        };
    }
    else
    {
        _backgroundView.frame = CGRectMake(0, 0, _model.width, _model.height);
        [_backgroundView updateWithModel:_model];
    }
}
////// 生成分时图线图
//-(void)createMinuteChartView
//{
//    if ([[NSString stringWithFormat:@"%f",_model.klineWidth] isEqualToString:@"nan"]) return;
//    if (!_kLine) {
//        _kLine = [[FMBaseLine alloc] initWithFrame:CGRectMake(0,0, _model.width, _model.height)
//                                             Model:_model
//                                          PointKey:kStockPointsKey_KLineMinute];
//        _kLine.backgroundColor = LTClearColor;
//        _kLine.userInteractionEnabled = NO;
//        [_mainBox addSubview:_kLine];
//    } else {
//        _kLine.frame = CGRectMake(0,0, _model.width, _model.height);
//        [_kLine updateWithModel:_model];
//    }
//}

// 生成k线图(类别非分时)
-(void)createKlineChartView
{
    if ([[NSString stringWithFormat:@"%f",_model.klineWidth] isEqualToString:@"nan"]) return;
    if (!_kLine) {
        _kLine = [[FMBaseLine alloc] initWithFrame:CGRectMake(0,0, _model.width, _model.height)
                                             Model:_model
                                          PointKey:kStockPointsKey_KLine];
        _kLine.backgroundColor = LTClearColor;
        _kLine.isBlack=YES;
        _kLine.userInteractionEnabled = NO;
        [_mainBox addSubview:_kLine];
        _kLine.frame = CGRectMake(0,0, _model.width, _model.height);
        [_kLine updateWithModel:_model];
    } else {
        _kLine.frame = CGRectMake(0,0, _model.width, _model.height);
        [_kLine updateWithModel:_model];
    }
}

//创建分时图价位视图
-(void)createMinutePriceTipView {
    if (!_leftTextViews) {
        _leftTextViews = [[FMBaseView alloc] initWithFrame:CGRectMake(0, 0, 50, _model.height)];
        [self addSubview:_leftTextViews];
    }
    if (!_rightTextViews) {
        _rightTextViews = [[FMBaseView alloc] initWithFrame:CGRectMake(_model.width+_leftTextViews.frame.size.width, 0, 40, _model.height)];
        [self addSubview:_rightTextViews];
    }
    if (!_dateBox) {
        _dateBox = [[FMBaseView alloc] initWithFrame:CGRectMake(0, _model.height, _model.width, 20)];
        _dateBox.backgroundColor = LTClearColor;
        if (_isBlackBG)
        {
            _dateBox.backgroundColor=KLineBoxBG;
        }
        [self addSubview:_dateBox];
    }
    _leftTextViews.frame = CGRectMake(0, 0, 50, _model.height);
    CGFloat rx = Screen_width-90;
    if (_model.kLineDirectionStyle==FMKLineDirection_Horizontal) {
        rx = Screen_height-90;
    }
    if (_isBlackBG)
    {
        rx = Screen_width-44;
        if (_model.kLineDirectionStyle==FMKLineDirection_Horizontal) {
            rx = Screen_height-44;
        }
    }
    _rightTextViews.frame = CGRectMake(rx, 0, 40, _model.height);
    _dateBox.frame = CGRectMake(0, _model.height, _model.width, 20);
    for (UILabel *l in _leftTextViews.subviews) {
        [l removeFromSuperview];
    }
    for (UILabel *l in _rightTextViews.subviews) {
        [l removeFromSuperview];
    }
    for (UIView *l in _dateBox.subviews) {
        [l removeFromSuperview];
    }
    for (UIView *l in _lineBox.subviews) {
        [l removeFromSuperview];
    }
    // 4根横线
    CGFloat smallValue = 0;
    
    if (_model.maxPrice<_model.yestodayClosePrice) {
        smallValue = _model.maxPrice;
        _model.maxPrice = 2*_model.yestodayClosePrice - smallValue;
    }else {
        smallValue = _model.yestodayClosePrice;
    }
    // 分段相差价格
    CGFloat _subvalue = fabs((_model.maxPrice - _model.yestodayClosePrice)/2) ;
    
    CGFloat _subDistance = (_model.height) / kStageMinuteHorizontalLine ;
    CGFloat x = 4;
    CGFloat y = 0;
    UIColor *color = LTKLineGreen;
    for (int i=0; i<=kStageMinuteHorizontalLine; i++) {
        y = i*_subDistance;
        color = LTKLineGreen;
        if (i<kStageMinuteHorizontalLine/2) {
            color = LTKLineRed;
        }
        if (i==kStageMinuteHorizontalLine/2) {
            color = kStageLeftTextColor;
        }
        
        // 框框周边
        CGFloat _v = _model.maxPrice - i*_subvalue;
//        NSLog(@"min _model.maxPrice=%.2f\n_model.minPrice=%.2f\n subv=%.2f",_model.maxPrice,_model.minPrice,_v);
        CGFloat _percentage = (_v - _model.yestodayClosePrice)/_model.yestodayClosePrice*100;
        if ([[NSString stringWithFormat:@"%f",_percentage] isEqualToString:@"nan"]) {
            _percentage = 0.00;
        }
        
        // 价格
        UILabel *_l = [[UILabel alloc] init];
        // 是否显示左边
        if (!_model.isHideLeft) {
            _l.text = [LTUtils decimalPriceWithCode:_model.stockCode floatValue:_v];
            _l.font = autoFontSiz(kStageLeftTextFontSize);
            _l.textColor = color;
            [_l sizeToFit];
            _l.backgroundColor = [UIColor clearColor];
            CGFloat ly = y;
            if (i==kStageMinuteHorizontalLine) {
                ly -= _l.frame.size.height;
            }else if(i>0){
                ly -= _l.frame.size.height/2;
            }
            _l.frame = CGRectMake(-_l.frame.size.width-x, ly, _l.frame.size.width, _l.frame.size.height);
            if (_isBlackBG) {
                _l.frame = CGRectMake(x, ly, _l.frame.size.width, _l.frame.size.height);
            }
            [_leftTextViews addSubview:_l];
            _l = nil;
        }
        // 是否显示右边
        if (!_model.isHideRight) {
            // 百分率
            _l = [[UILabel alloc] init];
            _l.text = [NSString stringWithFormat:@"%.2f%%",_percentage];
            _l.font = autoFontSiz(LTAutoW(kStageRightTextFontSize));
            _l.textColor = color;
            [_l sizeToFit];
            _l.backgroundColor = [UIColor clearColor];
            CGFloat ly = y;
            if (i==kStageMinuteHorizontalLine) {
                ly -= _l.frame.size.height;
            }else if(i>0){
                ly -= _l.frame.size.height/2;
            }
            _l.frame = CGRectMake(x, ly, _l.frame.size.width, _l.frame.size.height);
            if (_isBlackBG)
            {
                _l.frame = CGRectMake(4, ly, _l.frame.size.width, _l.frame.size.height);
            }
            [_rightTextViews addSubview:_l];
            _l = nil;
        }
        if (_model.isShowMiddleLine) {
            // 中间横线
        }
    }
    
    // 默认时间段显示
    NSArray *times = @[@"6:00",@"12:00",@"18:00",@"24:00",@"06:00"];
    if (_model.times)
    {
        times = nil;
        times = _model.times;
    }
    int vertical = (int)times.count - 1;
    _subvalue = _model.width / vertical;
    x = 0;
    y = _model.height;
    for (int i=0; i<=vertical; i++) {
        x = i*_subvalue;
        // 竖线
        if (i>0 && i<vertical)
        {
            [LTUtils drawLineAtSuperView:_lineBox andTopOrDown:0 andHeight:0 andColor:kStageLineColor andFrame:CGRectMake(x, 0, kStageLineWidth, y)];
        }
        // 时间段
        UILabel *_l = [[UILabel alloc] init];
        _l.text = [times objectAtIndex:i];
        if (i==0)
        {
            if(_isBlackBG)
            {
                NSString *dayStr = [NSString stringWithFormat:@" %@",[times objectAtIndex:i]];
                _l.text=dayStr;
            }
        }
        _l.font = [UIFont fontWithName:kFontName size:kStageLeftTextFontSize];
        _l.textColor = kStageLeftTextColor;
        [_l sizeToFit];
        _l.backgroundColor = [UIColor clearColor];
        if(i>0 && i<vertical) x = x-(_l.frame.size.width/2);
        if(i==vertical) x = x-(_l.frame.size.width);
        _l.frame = CGRectMake(x, 2, _l.frame.size.width, _l.frame.size.height);
        [_dateBox addSubview:_l];
        _l = nil;
    }
    // 画一根虚线
    if (_model.type<=0)
    {
        if (showVHLine && _isBlackBG==YES)
        {
//            CGPoint point = CGPointMake(_model.width-1, _model.height-1);
            //            [self createCrossLineWithTouchPoint:point];
        }
    }
    else
    {
        showVHLine=NO;
    }
}

//定义浮动价格视图
-(void)createWeipanPriceView
{
    if (!_priceView)
    {
        _priceView=[[WeiPanPriceView alloc]initWithFrame:CGRectMake(0, _topBox.frame.origin.y+SMAHeight, 88, 132)];
        _priceView.hidden=YES;
        [self insertSubview:_priceView atIndex:999];
    }
}
#pragma mark - 十字线
-(void)createCrossLineWithTouchPoint:(CGPoint)point
{
    CGFloat itemPointX = 0;
    CGPoint itemPoint=CGPointZero; // 当前位置 初始化
    NSArray *items; // 当前k线数据
    NSArray *points = [[NSArray alloc]init];
    
    if(_model.type<=0)
    {
        points = [_model.points objectForKey:kStockPointsKey_KLineMinute];
    }
    else
    {
        points = [_model.points objectForKey:kStockPointsKey_KLine];
    }
    if (points.count<=0)
    {
        return;
    }
    
    if (_model.type<=0)
    {
        CGFloat subNum=MAXFLOAT;
        NSInteger itemIndex=0;
        for (NSInteger i = points.count-1;i>=0;i--) {
            NSString *item = points[i];
            itemPoint = CGPointFromString(item);  // 收盘价的坐标
            itemPointX = itemPoint.x;
            CGFloat itemX = (CGFloat)itemPointX;
            CGFloat pointX = (CGFloat)point.x;//触摸点坐标
            //绝对值的坐标差
            CGFloat subPoint =fabs(itemX-pointX);
            
            if (subPoint <= subNum) {
                subNum=subPoint;
                itemIndex=i;
                items = @[item];
            }else{
                break;
            }
        }
        //点不在
        if (items==nil) {
            itemPoint = CGPointFromString([points lastObject]);
        }
        [self createCrossLineWithPoint:itemPoint Data:points];
        items = nil;
        
    }
    else
    {
//        int i = 0;
        CGFloat subNum=_model.klineWidth+_model.klinePadding;
        for (NSArray *item in points)
        {
            itemPoint = CGPointFromString([item objectAtIndex:3]);  // 收盘价的坐标
            itemPointX = itemPoint.x;
            CGFloat itemX = itemPointX;
            CGFloat pointX = (CGFloat)point.x;
            //NSLog(@"point.x==%f   itemX=%f  sub=%f",point.x,itemPoint.x,(self.model.klineWidth/2+self.model.klinePadding/2));
            if (itemX==pointX || (point.x-itemX<=(subNum) && point.x-itemX>0))
            {
                if (item==[points objectAtIndex:points.count-_model.leftEmptyKline-1]) {
                    isLastItem=YES;
                }else{
                    isLastItem=NO;
                }
                items = item;
                break;
            }
        }
        
        if (items.count>5 )
        {
            DaysChartModel *m = [items objectAtIndex:(items.count-2)];
            if (m.openPrice.floatValue<1)
            {
                isLastItem=YES;
                items=[points objectAtIndex:points.count-_model.leftEmptyKline-1];
                [self createCrossLineWithPoint:itemPoint Data:items];
                return;
            }
        }
        [self createCrossLineWithPoint:itemPoint Data:items];
        items = nil;
    }
    
}
// 画十字线
-(void)createCrossLineWithPoint:(CGPoint)point Data:(NSArray*)data
{
    //竖线
    if (!_vLine)
    {
        _vLine = [[UIView alloc] initWithFrame:CGRectMake(point.x-1/2, 0, 0.5, _model.height)];
        _vLine.backgroundColor = LTWhiteColor;
        [self addSubview:_vLine];
    }
    //横线
    if (!_hLine)
    {
        _hLine = [[UIImageView alloc] init];
        _hLine.backgroundColor = LTWhiteColor;
        _hLine.frame = CGRectMake(0, point.y, _model.width, 0.5);
        _hLine.autoresizesSubviews = YES;
        _hLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        [self addSubview:_hLine];
    }
    else
    {
        _hLine.hidden=NO;
    }
    if (!_tips)
    {
        _tips = [[UILabel alloc] initWithFrame:CGRectMake(0, SMAHeight, _dateTips.frame.size.width+10, 20)];
        _tips.font = [UIFont systemFontOfSize:LTAutoW(11)];
        _tips.textColor = LTTitleRGB;
        _tips.textAlignment=NSTextAlignmentCenter;
        _tips.layer.backgroundColor = LTWhiteColor.CGColor;
        [self addSubview:_tips];
    }
    if (!_rateTips)
    {
        if (_model.type<=0)
        {
            _rateTips = [[UILabel alloc] initWithFrame:CGRectMake(0, SMAHeight, _dateTips.frame.size.width+10, 20)];
            _rateTips.font = [UIFont systemFontOfSize:LTAutoW(11)];
            _rateTips.textColor = LTTitleRGB;
            _rateTips.textAlignment=NSTextAlignmentCenter;
            _rateTips.layer.backgroundColor = LTWhiteColor.CGColor;
            [self addSubview:_rateTips];
        }
    }
    else
    {
        if (_model.type>0)
        {
            _rateTips.hidden=YES;
        }
    }
    _vLine.frame = CGRectMake(point.x-1/2, 0, 0.5, _model.height);
    
    if (_model.type>0)
    {
        // 更新提示
        if (data.count>5)
        {
            DaysChartModel *m = [data objectAtIndex:(data.count-2)];
            // 更新右边价格提示
            [self setRightTipWithDatas:data];
            // 当前值
            _currentDaysModel = m;
            // 更新提示
            [self updateStockIndexTip];
            [_priceView configPriceInfoWithModel:_currentDaysModel];
            [self bringSubviewToFront:_priceView];
        }
        
    }
    else
    {
        CGRect hframe=_hLine.frame;
        hframe.origin.y=point.y;
        _hLine.frame=hframe;
        
        //竖屏显示dateTips
        if (!_dateTips && _model.kLineDirectionStyle==FMKLineDirection_Vertical)
        {
            if (_model.type<=0)
            {
                if (!_dateTips)
                {
                    _dateTips = [[UILabel alloc] initWithFrame:CGRectMake(point.x, 0, 100, 15)];
                    _dateTips.font = [UIFont systemFontOfSize:LTAutoW(11)];
                    _dateTips.textColor = LTTitleRGB;
                    _dateTips.textAlignment = NSTextAlignmentCenter;
                    _dateTips.layer.backgroundColor = LTWhiteColor.CGColor;
                    [self addSubview:_dateTips];
                }
            }
            
        }
        _dateTips.frame = CGRectMake(point.x-_dateTips.frame.size.width/2,0, _dateTips.frame.size.width, _dateTips.frame.size.height);
        [self setDateTipsWithPoint:point];
        [self setTipsTextWithPoint:point];
    }
    
}

#pragma mark - Tips
-(void)createSMATip
{
    NSString *SMA5 = @"SMA5=0.00";
    NSString *SMA10 = @"SMA10=0.00";
    NSString *SMA20 = @"SMA20=0.00";
    NSString *SMA60 = @"SMA60=0.00";
    NSString *SMA120 = @"SMA120=0.00";

    if (_currentDaysModel) {
        SMA5 = [NSString stringWithFormat:@"MA5=%@",[LTUtils priceFormat:_currentDaysModel.MA5]];
        SMA10 = [NSString stringWithFormat:@"MA10=%@",[LTUtils priceFormat:_currentDaysModel.MA10]];
        SMA20 = [NSString stringWithFormat:@"MA20=%@",[LTUtils priceFormat:_currentDaysModel.MA20]];
        SMA60 = [NSString stringWithFormat:@"MA60=%@",[LTUtils priceFormat:_currentDaysModel.MA60]];
        SMA120 = [NSString stringWithFormat:@"MA120=%@",[LTUtils priceFormat:_currentDaysModel.MA120]];
//        if([_currentDaysModel.MA5 floatValue]<0.01){
//            UILabel *l1=[_topTipView viewWithTag:1001];
//            UILabel *l2=[_topTipView viewWithTag:1002];
//            UILabel *l3=[_topTipView viewWithTag:1003];
//            UILabel *l4=[_topTipView viewWithTag:1004];
//            UILabel *l5=[_topTipView viewWithTag:1005];
//            SMA5=l1?l1.text:SMA5;
//            SMA10=l2?l2.text:SMA10;
//            SMA20=l3?l3.text:SMA20;
//            SMA60=l4?l4.text:SMA60;
//            SMA120=l5?l5.text:SMA120;
//        }
    }
    CGSize size = [self createLableWithSize:LTAutoW(kStageIndexTextFontSize) Color:kStockMA5Color Point:CGPointMake(4, 0) Text:SMA5 SuperView:_topTipView Tag:1001];
    size = [self createLableWithSize:LTAutoW(kStageIndexTextFontSize) Color:kStockMA10Color Point:CGPointMake(size.width+5, 0) Text:SMA10 SuperView:_topTipView Tag:1002];
    size = [self createLableWithSize:LTAutoW(kStageIndexTextFontSize) Color:kStockMA20Color Point:CGPointMake(size.width+5, 0) Text:SMA20 SuperView:_topTipView Tag:1003];
    size = [self createLableWithSize:LTAutoW(kStageIndexTextFontSize) Color:kStockMA60Color Point:CGPointMake(size.width+5, 0) Text:SMA60 SuperView:_topTipView Tag:1004];
    size = [self createLableWithSize:LTAutoW(kStageIndexTextFontSize) Color:kStockMA120Color Point:CGPointMake(size.width+5, 0) Text:SMA120 SuperView:_topTipView Tag:1005];

    if (_isBlackBG)
    {
        _topTipView.backgroundColor=LTClearColor;
    }
}

-(void)createEMATip
{
    NSString *EMA20 = @"EMA20=0.00";
    if (_currentDaysModel)
    {
        EMA20 = [NSString stringWithFormat:@"EMA20=%@",[LTUtils priceFormat:_currentDaysModel.EMA]];
//        if([_currentDaysModel.EMA floatValue]<0.01){
//            UILabel *l = (UILabel*)[_topTipView viewWithTag:1004];
//            EMA20=l?l.text:EMA20;
//        }
    }
    [self createLableWithSize:LTAutoW(kStageIndexTextFontSize) Color:kStockEMAColor Point:CGPointMake(4, 0) Text:EMA20 SuperView:_topTipView Tag:1004];
    if (_isBlackBG)
    {
        _topTipView.backgroundColor=LTClearColor;
    }
}
-(void)createBOLLTip
{
    NSString *Boll = @"BOLL(0.00,0.00)";
    if (_currentDaysModel)
    {
        Boll = [NSString stringWithFormat:@"BOLL(%@,%@)",[LTUtils priceFormat:_currentDaysModel.BOLL_DOWN],[LTUtils priceFormat:_currentDaysModel.BOLL_UP]];
//        if([_currentDaysModel.BOLL_UP floatValue]<0.01 || [_currentDaysModel.BOLL_DOWN floatValue]<0.01){
//            UILabel *l = (UILabel*)[_topTipView viewWithTag:1005];
//            Boll=l?l.text:Boll;
//        }
    }
    [self createLableWithSize:LTAutoW(kStageIndexTextFontSize) Color:kStageRightTextColor Point:CGPointMake(4, 0) Text:Boll SuperView:_topTipView Tag:1005];
    if (_isBlackBG)
    {
        _topTipView.backgroundColor=LTClearColor;
    }
}
//MACD DIF DEA MACD图
-(void)createMACDTip
{
    NSString *MACD = [NSString stringWithFormat:@"MACD(%@,%@,%@)",[LTUtils getSeting:@"MACD_P"],[LTUtils getSeting:@"MACD_N1"],[LTUtils getSeting:@"MACD_N2"]];
    NSString *DIF = @"DIF=0.00";
    NSString *DEA = @"DEA=0.00";
    NSString *M = @"MACD=0.00";
    UIColor *color = LTKLineGreen;
    if (_currentDaysModel) {
        DIF = [NSString stringWithFormat:@"DIF=%@",[LTUtils decimalPriceWithCode:_model.stockCode floatValue:_currentDaysModel.MACD_DIF.floatValue]];
        DEA = [NSString stringWithFormat:@"DEA=%@",[LTUtils decimalPriceWithCode:_model.stockCode floatValue:_currentDaysModel.MACD_DEA.floatValue]];
        M = [NSString stringWithFormat:@"MACD=%@",[LTUtils decimalPriceWithCode:_model.stockCode floatValue:_currentDaysModel.MACD_M.floatValue]];
        if ([_currentDaysModel.MACD_M floatValue]>0) {
            color = LTKLineRed;
        }
//        if ([_currentDaysModel.MACD_DIF floatValue]<0.01) {
//            UILabel *l1=[_bottomTipView viewWithTag:1006];
//            UILabel *l2=[_bottomTipView viewWithTag:1007];
//            UILabel *l3=[_bottomTipView viewWithTag:1008];
//            UILabel *l4=[_bottomTipView viewWithTag:1009];
//            MACD=l1?l1.text:MACD;
//            DIF=l2?l2.text:DIF;
//            DEA=l3?l3.text:DEA;
//            M=l4?l4.text:M;
//        }
    }
    CGSize size = [self createLableWithSize:LTAutoW(kStageIndexTextFontSize) Color:LTSubTitleRGB Point:CGPointMake(4, 0) Text:MACD SuperView:_bottomTipView Tag:1006];
    size = [self createLableWithSize:LTAutoW(kStageIndexTextFontSize) Color:kStockMACD_DIFColor Point:CGPointMake(size.width+5, 0) Text:DIF SuperView:_bottomTipView Tag:1007];
    size = [self createLableWithSize:LTAutoW(kStageIndexTextFontSize) Color:kStockMACD_DEAColor Point:CGPointMake(size.width+5, 0) Text:DEA SuperView:_bottomTipView Tag:1008];
    size = [self createLableWithSize:LTAutoW(kStageIndexTextFontSize) Color:color Point:CGPointMake(size.width+5, 0) Text:M SuperView:_bottomTipView Tag:1009];
    if (_isBlackBG)
    {
        _bottomTipView.backgroundColor=LTClearColor;
    }
}
-(void)createKDJTip
{
    NSString *KDJ = @"KDJ";
    NSString *K = [NSString stringWithFormat:@"K(%@)=0.00",[LTUtils getSeting:@"KDJ_N"]];
    NSString *D = [NSString stringWithFormat:@"D(%@)=0.00",[LTUtils getSeting:@"KDJ_N"]];
    NSString *J = [NSString stringWithFormat:@"J(%@)=0.00",[LTUtils getSeting:@"KDJ_N"]];
    
    if (_currentDaysModel) {
        K = [NSString stringWithFormat:@"K(%@)=%@",[LTUtils getSeting:@"KDJ_N"],[LTUtils priceFormat:_currentDaysModel.KDJ_K]];
        D = [NSString stringWithFormat:@"D(%@)=%@",[LTUtils getSeting:@"KDJ_N"],[LTUtils priceFormat:_currentDaysModel.KDJ_D]];
        J = [NSString stringWithFormat:@"J(%@)=%@",[LTUtils getSeting:@"KDJ_N"],[LTUtils priceFormat:_currentDaysModel.KDJ_J]];
//        if ([_currentDaysModel.KDJ_K floatValue]<0.01) {
//            UILabel *l1=[_bottomTipView viewWithTag:1020];
//            UILabel *l2=[_bottomTipView viewWithTag:1021];
//            UILabel *l3=[_bottomTipView viewWithTag:1022];
//            K=l1?l1.text:K;
//            D=l2?l2.text:D;
//            J=l3?l3.text:J;
//        }
        
    }
    CGSize size = [self createLableWithSize:LTAutoW(kStageIndexTextFontSize) Color:kStageRightTextColor Point:CGPointMake(4, 0) Text:KDJ SuperView:_bottomTipView Tag:1020];
    size = [self createLableWithSize:LTAutoW(kStageIndexTextFontSize) Color:kStockKDJ_KColor Point:CGPointMake(size.width+5, 0) Text:K SuperView:_bottomTipView Tag:1021];
    size = [self createLableWithSize:LTAutoW(kStageIndexTextFontSize) Color:kStockKDJ_DColor Point:CGPointMake(size.width+5, 0) Text:D SuperView:_bottomTipView Tag:1022];
    size = [self createLableWithSize:LTAutoW(kStageIndexTextFontSize) Color:kStockKDJ_JColor Point:CGPointMake(size.width+5, 0) Text:J SuperView:_bottomTipView Tag:1023];
    
    if (_isBlackBG)
    {
        _bottomTipView.backgroundColor=LTClearColor;
    }
    
}
-(void)createRSITip
{
    NSString *RSI = @"RSI";
    NSString *N1 = [NSString stringWithFormat:@"R(%@)=0.00",[LTUtils getSeting:@"RSI_N1"]];
    NSString *N2 = [NSString stringWithFormat:@"R(%@)=0.00",[LTUtils getSeting:@"RSI_N2"]];
    NSString *N3 = [NSString stringWithFormat:@"R(%@)=0.00",[LTUtils getSeting:@"RSI_N3"]];
    
    if (_currentDaysModel)
    {
        N1 = [NSString stringWithFormat:@"R(%@)=%@",[LTUtils getSeting:@"RSI_N1"],[LTUtils priceFormat:_currentDaysModel.RSI_1]];
        N2 = [NSString stringWithFormat:@"R(%@)=%@",[LTUtils getSeting:@"RSI_N2"],[LTUtils priceFormat:_currentDaysModel.RSI_2]];
        N3 = [NSString stringWithFormat:@"R(%@)=%@",[LTUtils getSeting:@"RSI_N3"],[LTUtils priceFormat:_currentDaysModel.RSI_3]];
//        if ([_currentDaysModel.RSI_1 floatValue]<0.01) {
//            UILabel *l1=[_bottomTipView viewWithTag:1010];
//            UILabel *l2=[_bottomTipView viewWithTag:1011];
//            UILabel *l3=[_bottomTipView viewWithTag:1012];
//            N1=l1?l1.text:N1;
//            N2=l2?l2.text:N2;
//            N3=l3?l3.text:N3;
//        }
    }
    CGSize size = [self createLableWithSize:LTAutoW(kStageIndexTextFontSize) Color:kStageRightTextColor Point:CGPointMake(4, 0) Text:RSI SuperView:_bottomTipView Tag:1010];
    size = [self createLableWithSize:LTAutoW(kStageIndexTextFontSize) Color:kStockRSI_N1Color Point:CGPointMake(size.width+5, 0) Text:N1 SuperView:_bottomTipView Tag:1011];
    size = [self createLableWithSize:LTAutoW(kStageIndexTextFontSize) Color:kStockRSI_N2Color Point:CGPointMake(size.width+5, 0) Text:N2 SuperView:_bottomTipView Tag:1012];
    size = [self createLableWithSize:LTAutoW(kStageIndexTextFontSize) Color:kStockRSI_N3Color Point:CGPointMake(size.width+5, 0) Text:N3 SuperView:_bottomTipView Tag:1013];
    if (_isBlackBG)
    {
        _bottomTipView.backgroundColor=LTClearColor;
    }
}

//创建图标周边文字
-(void)createPriceTipViews
{
    if (!_createFinished)
    {
        return;
    }
    if (!_leftTextViews)
    {
        _leftTextViews = [[FMBaseView alloc] initWithFrame:CGRectMake(0, 0, 30, _model.height)];
        _leftTextViews.backgroundColor=LTClearColor;
        [self addSubview:_leftTextViews];
    }
    if (!_rightTextViews)
    {
        _rightTextViews = [[FMBaseView alloc] initWithFrame:CGRectMake(_model.width-34, 0, 30, _model.height)];
        [self addSubview:_rightTextViews];
    }
    _leftTextViews.frame = CGRectMake(4, 0, 36, _model.height);
    
    if (_model.kLineDirectionStyle==FMKLineDirection_Horizontal)
    {
        _leftTextViews.frame = CGRectMake(4, 0, 30, _model.height);
        _rightTextViews.frame = CGRectMake(0, 0, 40, _model.height);
    }
    else
    {
        _leftTextViews.frame = CGRectMake(4, SMAHeight, 30, _model.height*2/3.0-SMAHeight-16);
        _rightTextViews.frame=CGRectMake(2, 2/3.0*_model.height+SMAHeight, 40, _model.height/3.0-SMAHeight);
    }
    
    // 分段相差价格
    CGFloat _subvalue = (_model.maxPrice - _model.minPrice) / kStageHorizontalLine;
    CGFloat _subDistance = (_model.height/3*2 - 20) / kStageHorizontalLine ;
    CGFloat y = 0;
    CGFloat x = 4;
    CGFloat top = 0;
    if (_model.kLineDirectionStyle==FMKLineDirection_Vertical)
    {
        _subDistance = (_model.height/3*2 - SMAHeight-16) / kStageHorizontalLine;
        top=SMAHeight;
    }
    else
    {
        top=4;
    }
    if (!_rightViews) {
        _rightViews = [NSMutableArray new];
    }
    for (int i=0; i<=kStageHorizontalLine; i++) {
        y = i*_subDistance+top;
        if (!_model.isShowSide)
        {
            if (i>0 && i<kStageHorizontalLine) {
                continue;
            }
        }
        // 框框周边
        CGFloat _v = _model.maxPrice - i*_subvalue;
//        NSLog(@"_model.maxPrice=%.2f\n_model.minPrice=%.2f\n subv=%.2f",_model.maxPrice,_model.minPrice,_v);
        // 价格
        UILabel *_l;
        if (i<_rightViews.count) {
            _l= [_rightViews objectAtIndex:i];
        }
        
        if (_l==nil)
        {
            _l = [[UILabel alloc] init];
            [_rightViews addObject:_l];
            [self addSubview:_l];
        }
        _l.text = [LTUtils decimalPriceWithCode:_model.stockCode floatValue:_v];
        _l.font = autoFontSiz(LTAutoW(kStageRightTextFontSize));
        _l.textColor = kStageLeftTextColor;
        if (_isBlackBG)
        {
            _l.textColor = LTWhiteColor;
        }
        _l.frame = CGRectMake(x+_rightTextViews.frame.origin.x, y-_l.frame.size.height/2, _l.frame.size.width, _l.frame.size.height);
        [_l sizeToFit];
        _l.backgroundColor = [UIColor clearColor];
        
        if (_isBlackBG)
        {
            if(i==0)
            {
                _l.frame = CGRectMake(x, y, _l.frame.size.width, _l.frame.size.height);
            }
            else if(i==kStageHorizontalLine)
            {
                _l.frame = CGRectMake(x, y-_l.frame.size.height, _l.frame.size.width, _l.frame.size.height);
            }
            else
            {
                _l.frame = CGRectMake(x, y-_l.frame.size.height/2.0, _l.frame.size.width, _l.frame.size.height);
            }
        }
        _l = nil;
    }
    
    // 底部分段相差价格
    _subvalue = (_model.bottomMaxPrice - _model.bottomMinPrice) / 2;
    _subDistance = (_model.height/3-16) / 2 ;
    y = (_model.height/3*2)+16;
    top = (_model.height/3*2)+16;
    if (_model.kLineDirectionStyle==FMKLineDirection_Vertical) {
        _subDistance = (_model.height/3- SMAHeight) / 2 ;
        top = (_model.height/3*2)+SMAHeight;
    }
    for (int i=0; i<=2; i++) {
        y = top+i*_subDistance;
        // 框框周边
        CGFloat _v = _model.bottomMaxPrice - i*_subvalue;
        // 价格
        UILabel *_l;
        if ((i+kStageHorizontalLine+1)<_rightViews.count)
        {
            _l= [_rightViews objectAtIndex:i+kStageHorizontalLine+1];
        }
        if (_l==nil) {
            _l = [[UILabel alloc] init];
            [_rightViews addObject:_l];
            [self addSubview:_l];
        }
        _l.text = [LTUtils priceFormat:[NSString stringWithFormat:@"%f",_v]];
        _l.font = autoFontSiz(LTAutoW(kStageRightTextFontSize));
        _l.textColor = LTSubTitleRGB;
        if (_isBlackBG)
        {
            _l.textColor = LTWhiteColor;
        }
        [_l sizeToFit];
        _l.backgroundColor = [UIColor clearColor];
        if (i==2) {
            y = y - _l.frame.size.height;
        }
        if (i==1) {
            y = y - _l.frame.size.height/2.0;
        }
        _l.frame = CGRectMake(x+_rightTextViews.frame.origin.x, y, _l.frame.size.width, _l.frame.size.height);
        _l = nil;
        
    }
    // 右边提示
    [self setRightTipWithDatas:nil];
    // 天玑线阻力线
    [self showDragLineViews];
    _createFinished = YES;
}

#pragma mark - untils
// 创建一个文本
-(CGSize)createLableWithSize:(CGFloat)size Color:(UIColor*)color Point:(CGPoint)point Text:(NSString*)text SuperView:(UIView *)view Tag:(NSInteger)tag{
    
    UILabel *l;
    l = (UILabel*)[view viewWithTag:tag];
    if (!l) {
        l = [[UILabel alloc] init];
        view.backgroundColor=LTClearColor;
        [view addSubview:l];
    }
    l.tag = tag;
    l.text = text;
    l.textColor = color;
    l.backgroundColor=LTClearColor;
    l.font = autoFontSiz(size);
    l.frame = CGRectMake(point.x, point.y, self.frame.size.width, 0);
    [l sizeToFit];
    CGSize sizes = CGSizeMake(l.frame.size.width+l.frame.origin.x, l.frame.size.height);
    return sizes;
}

//返回view
-(UIView *)createBoxViewWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor
{
    UIView *view=[[UIView alloc]init];
    view.frame=frame;
    view.backgroundColor=backgroundColor;
    view.backgroundColor = KLineBoxBG;
    view.layer.borderColor = kStageLineColor.CGColor;
    view.layer.borderWidth = kStageLineWidth;
    view.contentMode = UIViewContentModeRedraw;
    view.autoresizesSubviews = YES;
    
    return view;
}
//返回label
-(UILabel *)createLabWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor
{
    UILabel *lab=[[UILabel alloc]init];
    lab.frame=frame;
    lab.backgroundColor=backgroundColor;
    return lab;
}
// 画一个视图
-(FMBaseView*)createSingleViewWithFrame:(CGRect)frame Color:(UIColor*)color{
    FMBaseView *v = [[FMBaseView alloc] initWithFrame:frame];
    v.backgroundColor = color;
    return v;
}

#pragma mark - set Data
//设置K线图背景色
-(void)setIsBlackBG:(BOOL)isBlackBG
{
    _isBlackBG=isBlackBG;
    _backgroundView.backgroundColor=KLineBoxBG;
}
//设置最值
-(void)setPointForMostValue
{
    if (_model.type<=0)
    {
        [self setMostValueTipShow:NO];
        return;
    }
    CGPoint maxPoint=CGPointMake(0, 0);
    CGPoint minPoint=CGPointMake(0, 0);
    CGPoint itemPoint;
    
    //最值
    CGFloat maxPrice=0;
    CGFloat minPrice=INT_MAX;
    NSArray *points = [_model.points objectForKey:kStockPointsKey_KLine];
    for (NSArray *item in points)
    {
        itemPoint = CGPointFromString([item objectAtIndex:3]);  // 收盘价的坐标
        DaysChartModel *m = [item objectAtIndex:(item.count-2)];
        if (m.heightPrice.floatValue>maxPrice)
        {
            maxPrice=m.heightPrice.floatValue;
            maxPoint=CGPointFromString([item objectAtIndex:0]);
            _maxValue=m.heightPrice;
        }
        
        if (m.lowPrice.floatValue<minPrice && m.lowPrice.floatValue>0)
        {
            minPrice=m.lowPrice.floatValue;
            minPoint=CGPointFromString([item objectAtIndex:1]);
            _minValue=m.lowPrice;
        }
    }
    [self setMaxTipsWithPoint:maxPoint];
    [self setMinTipsWithPoint:minPoint];
}
// set Tip Text
-(void)setTipsTextWithPoint:(CGPoint)point
{
    if (_model.type>0)
    {
        CGFloat pxNum = _model.height*2/3.0-20-SMAHeight;//总像素
        CGFloat px = point.y- _topBox.frame.origin.y+SMAHeight;
        CGFloat pxValue = (_model.maxPrice-_model.minPrice)/pxNum;//每个px高度的值
        
        if (_model.kLineDirectionStyle==FMKLineDirection_Vertical)
        {
            pxNum = _model.height*2/3.0-16-(_topBox.frame.origin.y+SMAHeight);//总像素
            pxValue = (_model.maxPrice-_model.minPrice)/pxNum;//每个px高度的值
            px = _hLine.frame.origin.y- (_topBox.frame.origin.y+SMAHeight);
        }
        else
        {
            pxNum = _model.height*2/3.0-16-_topBox.frame.origin.y;//总像素
            pxValue = (_model.maxPrice-_model.minPrice)/pxNum;//每个px高度的值
            px = _hLine.frame.origin.y- _topBox.frame.origin.y;
        }
        CGFloat tipsValue=_model.maxPrice-pxValue*px;
        if (tipsValue<_model.minPrice)
        {
            tipsValue=_model.minPrice;
        }
        else if (tipsValue>_model.maxPrice)
        {
            tipsValue=_model.maxPrice;
        }
        _tips.text = [NSString stringWithFormat:@"%.5f",tipsValue];
    }
    else
    {
        CGFloat itemPointX = 0;
        CGPoint itemPoint; // 当前位置
        NSArray *items; // 当前k线数据
        NSArray *points = [_model.points objectForKey:kStockPointsKey_KLineMinute];
        //初始化一个point的sub值
        CGFloat subNum=_model.klineWidth+_model.klinePadding;
        if (subNum<1) {
            subNum=1;
        }
        //初始化一个point的下标
        NSInteger pointIndex = points.count-1;
        BOOL isBreak = NO;
        for (NSInteger i=points.count-1; i>=0; i--)
        {
            NSString *item=points[i];
            itemPoint = CGPointFromString(item);  // 坐标
            itemPointX = itemPoint.x;
            CGFloat itemX = (CGFloat)itemPointX;
            CGFloat pointX = (CGFloat)point.x;
            //计算绝对值
            CGFloat sub = fabs(itemX-pointX);
            //分时坐标绝对值差在1内
            if (itemX==pointX || sub<=subNum )
            {
                if (subNum>sub)
                {
                    NSLog(@"itemX=%.3f pointX=%.3f i=%li",itemX,pointX,i);
                    subNum=sub;
                    pointIndex=i;
                    isBreak=YES;
                }
            }
            else
            {
                if (isBreak) {
                    NSString *item1=points[pointIndex];
                    NSLog(@"item1X=%@",item1);
                    items = @[item1];
                    NSString *priceStr=[_model.prices[pointIndex] objectForKey:@"closePrice"];
                    _tips.text = [NSString stringWithFormat:@"%.5f",priceStr.floatValue];
                    [_tips sizeToFit];
                    break;
                }
            }
            
        }
        if (!_rateTips)
        {
            _rateTips = [[UILabel alloc] initWithFrame:CGRectMake(0, SMAHeight, _dateTips.frame.size.width+10, 20)];
            _rateTips.font = [UIFont systemFontOfSize:LTAutoW(11)];
            _rateTips.textColor = LTTitleRGB;
            _rateTips.textAlignment=NSTextAlignmentCenter;
            _rateTips.layer.backgroundColor = LTWhiteColor.CGColor;
            [self addSubview:_rateTips];
        }
        
        _tips.frame = CGRectMake(0, point.y-_tips.frame.size.height/2.0, _tips.frame.size.width, _tips.frame.size.height);
        _hLine.frame=CGRectMake(0, point.y, _model.width, 0.5);
        _rateTips.text=[NSString stringWithFormat:@"%.2f%%",(_tips.text.floatValue-_model.yestodayClosePrice)/_model.yestodayClosePrice*100];
        [_rateTips sizeToFit];
        _rateTips.frame = CGRectMake(_model.width-_rateTips.frame.size.width, point.y-_rateTips.frame.size.height/2.0, _rateTips.frame.size.width, _rateTips.frame.size.height);
    }
    
    
}
-(void)setDateTipsWithPoint:(CGPoint)point
{
    if(!_dateTips)
    {
        _dateTips = [[UILabel alloc] initWithFrame:CGRectMake(point.x, 0, 100, 15)];
        _dateTips.font = [UIFont systemFontOfSize:LTAutoW(11)];
        _dateTips.textColor = LTTitleRGB;
        _dateTips.textAlignment = NSTextAlignmentCenter;
        _dateTips.layer.backgroundColor = LTWhiteColor.CGColor;
        [self addSubview:_dateTips];
    }
    CGFloat itemPointX = 0;
    CGPoint itemPoint; // 当前位置
    NSArray *items; // 当前k线数据
    NSArray *points = [_model.points objectForKey:kStockPointsKey_KLineMinute];
    //初始化一个point的sub值
    CGFloat subNum=_model.klineWidth+_model.klinePadding;
    if(subNum<1){
        subNum=1;
    }
    //初始化一个point的下标
    NSInteger pointIndex = points.count-1;
    BOOL isBreak = NO;
    for (NSInteger i=points.count-1; i>=0; i--)
    {
        NSString *item=points[i];
        itemPoint = CGPointFromString(item);  // 坐标
        itemPointX = itemPoint.x;
        
        if (_model.type>0) {
            CGFloat itemX = (CGFloat)itemPointX;
            CGFloat pointX = (CGFloat)point.x;
            if (itemX==pointX ||(itemX- point.x<=(subNum) &&itemX -point.x>0 ))
            {
                items = @[item];
                NSString *priceStr=[_model.prices[i] objectForKey:@"closePrice"];
                _tips.text = [NSString stringWithFormat:@"%.5f",priceStr.floatValue];
                [_tips sizeToFit];
                NSNumber *time = [_model.prices[i] objectForKey:@"time"];
                
                if ([kPublicData isNull:time]) {
                    _dateTips.text =[LTUtils timeFormat_ShortHourStyle:time.integerValue];
                } else {
                    if (kPublicData.timeList.count>0) {
                        NSString *timeNum=kPublicData.timeList[i];
                        _dateTips.text =[LTUtils timeFormat_ShortHourStyle:timeNum.integerValue];
                        NSLog(@"timeTips=%@",[LTUtils timeFormat_ShortHourStyle:timeNum.integerValue]);
                    }
                }
                break;
            }
        }
        else
        {
            CGFloat itemX = (CGFloat)itemPointX;
            CGFloat pointX = (CGFloat)point.x;
            CGFloat sub = fabs(itemX-pointX);
            //分时坐标点差值在_model.klineWidth+_model.klinePadding以内
            if (itemX==pointX || sub<subNum) {
                //计算绝对值
                if (subNum>sub) {
                    NSLog(@"itemX=%.3f pointX=%.3f",itemX,pointX);
                    subNum=sub;
                    pointIndex=i;
                    isBreak=YES;
                }
            }
            else
            {
                if (isBreak) {
                    NSString *item1=points[pointIndex];
                    NSLog(@"item1X=%@",item1);
                    items = @[item1];
                    NSString *priceStr=[_model.prices[pointIndex] objectForKey:@"closePrice"];
                    _tips.text = [NSString stringWithFormat:@"%.5f",priceStr.floatValue];
                    [_tips sizeToFit];
                    NSNumber *time = [_model.prices[pointIndex] objectForKey:@"time"];
                    if ([kPublicData isNull:time]) {
                        _dateTips.text =[LTUtils timeFormat_ShortHourStyle:time.integerValue];
                        NSLog(@"timeTips=%@,%@",time,[LTUtils timeFormat_ShortHourStyle:time.integerValue]);
                    }else
                    {
                        if (kPublicData.timeList.count>0)
                        {
                            NSString *timeNum=kPublicData.timeList[pointIndex];
                            _dateTips.text =[LTUtils timeFormat_ShortHourStyle:timeNum.integerValue];
                        }
                    }
                    break;
                }
            }
            
        }
        
    }
    if (items==nil)
    {
        NSNumber *time = [[_model.prices lastObject] objectForKey:@"time"];
        if ([kPublicData isNull:time])
        {
            _dateTips.text =[LTUtils timeFormat_ShortHourStyle:time.integerValue];
        }
        else
        {
            if (kPublicData.timeList.count>0)
            {
                NSString *timeNum=[kPublicData.timeList lastObject];
                _dateTips.text =[LTUtils timeFormat_ShortHourStyle:timeNum.integerValue];
                NSLog(@"dateTips.text=%@",_dateTips.text);
                NSLog(@"lastTimeObject.text=%@",timeNum);
            }
        }
    }
    [_dateTips sizeToFit];
    CGRect frame = _dateTips.frame;
    if (point.x>=_dateTips.frame.size.width/2.0 && point.x<=(_model.width-_dateTips.frame.size.width/2.0))
    {
        frame.origin.x=point.x-_dateTips.frame.size.width/2.0;
    }
    else
    {
        if (point.x<_dateTips.frame.size.width/2.0)
        {
            frame.origin.x=0;
        }
        if (point.x>(_model.width-_dateTips.frame.size.width/2.0))
        {
            frame.origin.x=_model.width-_dateTips.frame.size.width;
        }
    }
    _dateTips.frame=frame;
}
//设置daysChart右边的tips的价格
-(void)setRightTipWithDatas:(NSArray*)datas
{
    if (!datas) {
        //[self removeCrossLine];
        return;
    }
    CGFloat h = 20;
    
    DaysChartModel *m;
    CGPoint point;
    
    if (!_tips)
    {
        _tips = [[UILabel alloc] initWithFrame:CGRectMake(_model.width-_dateTips.frame.size.width+10, SMAHeight, _dateTips.frame.size.width+10, h)];
        _tips.font = [UIFont systemFontOfSize:LTAutoW(11)];
        _tips.textColor = LTTitleRGB;
        _tips.textAlignment=NSTextAlignmentCenter;
        _tips.layer.backgroundColor = LTWhiteColor.CGColor;
        [self addSubview:_tips];
    }
    if (datas.count>2)
    {
        m = [datas objectAtIndex:(datas.count-2)];
        point = CGPointFromString([datas objectAtIndex:3]);
    }
    else
    {
        if (_model.lastPoints.count>0)
        {
            m = [_model.lastPoints objectAtIndex:(_model.lastPoints.count-2)];
            point = CGPointFromString([_model.lastPoints objectAtIndex:3]);
        }
    }
    m = nil;
}

#pragma mark - maxValueTips
//设置最大值的point
-(void)setMaxTipsWithPoint:(CGPoint)point
{
    if(!_maxTipsLine)
    {
        _maxTipsLine=[[UILabel alloc]init];
        _maxTipsLine.frame=CGRectMake(point.x, point.y, _model.klineWidth+2, 1);
        _maxTipsLine.backgroundColor=GRAYCOL;
        [self addSubview:_maxTipsLine];
    }
    
    if (!_maxTips)
    {
        _maxTips=[[UILabel alloc]init];
        _maxTips.frame=CGRectMake(point.x, point.y, 100, 20);
        _maxTips.font=autoFontSiz(12);
        _maxTips.textColor=LTWhiteColor;
        _maxTips.backgroundColor=LTSubTitleRGB;
        [self addSubview:_maxTips];
    }
    if (_model.type>0)
    {
        [self setMostValueTipShow:YES];
    }
    else
    {
        [self setMostValueTipShow:NO];
    }
    _maxTips.text=[NSString stringWithFormat:@"%g",_maxValue.floatValue];
    [_maxTips sizeToFit];
    //朝向标记
    BOOL leftFlag=[self returnTipsLeftFlagWithPoint:point];
    [self setTipsFrameWithPoint:point isMax:YES isLeft:leftFlag];
}
//设置最小值point
-(void)setMinTipsWithPoint:(CGPoint)point
{
//    NSLog(@"min.x=%f  min.y=%f",point.x,point.y);
    if(!_minTipsLine)
    {
        _minTipsLine=[[UILabel alloc]init];
        _minTipsLine.frame=CGRectMake(point.x, point.y, _model.klineWidth+2, 1);
        _minTipsLine.backgroundColor=GRAYCOL;
        [self addSubview:_minTipsLine];
    }
    if (!_minTips)
    {
        _minTips=[[UILabel alloc]init];
        _minTips.frame=CGRectMake(point.x, point.y, 100, 20);
        _minTips.font=autoFontSiz(12);
        _minTips.textColor=LTWhiteColor;
        _minTips.backgroundColor=LTSubTitleRGB;
        [self addSubview:_minTips];
    }
    if (_model.type>0)
    {
        [self setMostValueTipShow:YES];
    }
    else
    {
        [self setMostValueTipShow:NO];
    }
    _minTips.text=[NSString stringWithFormat:@"%g",_minValue.floatValue];
    [_minTips sizeToFit];
    //朝向标记
    BOOL leftFlag=[self returnTipsLeftFlagWithPoint:point];
    [self setTipsFrameWithPoint:point isMax:NO isLeft:leftFlag];
    
}
//设置是否显示最值tips
-(void)setMostValueTipShow:(BOOL)isShow
{
    _maxTips.hidden=!isShow;
    _maxTipsLine.hidden=!isShow;
    _minTips.hidden=!isShow;
    _minTipsLine.hidden=!isShow;
}

/**
 *  设置最大最小值的tips位置方法
 *
 *  @param point  最大/最小的price对应坐标点
 *  @param ismax  是否是最大
 *  @param isleft price对应坐标点是否在左边
 */
-(void)setTipsFrameWithPoint:(CGPoint)point
                       isMax:(BOOL)ismax
                      isLeft:(BOOL)isleft
{
    if (ismax)
    {
        if (isleft)
        {
            _maxTipsLine.frame=CGRectMake(point.x-MaxLineWidth, point.y, MaxLineWidth, 1);
            _maxTips.frame=CGRectMake(_maxTipsLine.frame.origin.x-_maxTips.frame.size.width, _maxTipsLine.frame.origin.y-_maxTips.frame.size.height/2, _maxTips.frame.size.width, _maxTips.frame.size.height);
        }
        else
        {
            _maxTipsLine.frame=CGRectMake(point.x, point.y, MaxLineWidth, 1);
            _maxTips.frame=CGRectMake(_maxTipsLine.frame.origin.x+MaxLineWidth, _maxTipsLine.frame.origin.y-_maxTips.frame.size.height/2, _maxTips.frame.size.width, _maxTips.frame.size.height);
        }
    }
    else
    {
        [_minTips sizeToFit];
        if (isleft)
        {
            _minTipsLine.frame=CGRectMake(point.x-MaxLineWidth, point.y, MaxLineWidth, 1);
            _minTips.frame=CGRectMake(_minTipsLine.frame.origin.x-_minTips.frame.size.width, _minTipsLine.frame.origin.y-_minTips.frame.size.height/2, _minTips.frame.size.width, _minTips.frame.size.height);
        }
        else
        {
            _minTipsLine.frame=CGRectMake(point.x, point.y, MaxLineWidth, 1);
            _minTips.frame=CGRectMake(_minTipsLine.frame.origin.x+MaxLineWidth, _minTipsLine.frame.origin.y-_minTips.frame.size.height/2, _minTips.frame.size.width, _minTips.frame.size.height);
        }
    }
}
#pragma mark - remove view
// 移除十字线
-(void)removeCrossLine
{
    [_hLine removeFromSuperview];
    [_vLine removeFromSuperview];
    [_tips removeFromSuperview];
    [_dateTips removeFromSuperview];
    _hLine = nil;
    _vLine = nil;
    _tips = nil;
    _dateTips = nil;
    // 手指移开的时候恢复显示最后一根k线的指标提示
    [self setRightTipWithDatas:nil];
    // 更新指标提示
    [self updateStockIndexTip];
    // 传递更新
    if (_chart.crossLineTipBlock)
    {
        _chart.crossLineTipBlock(_currentDaysModel,YES);
    }
}


-(void)removeStockIndexTip{
    for (UIView *view in _topTipView.subviews) {
        [view removeFromSuperview];
    }
    for (UIView *view in _bottomTipView.subviews) {
        [view removeFromSuperview];
    }
}
// 移除阻力线
-(void)removeDregViews{
    if (_dragLineViews) {
        [_dragLineViews removeFromSuperview];
    }
    if (_dragTip) {
        [_dragTip removeFromSuperview];
    }
    _dragTip = nil;
    _dragLineViews = nil;
}

#pragma mark - action
-(void)updateWithModel:(FMKLineModel *)model{
    _model=nil;
    _model = model;
    [self createKLineBox];
    [self setPointForMostValue];
    if(showVHLine && isLastItem){
        NSArray *data;
        NSArray *points = [[NSArray alloc]init];
        points = [_model.points objectForKey:kStockPointsKey_KLine];
        data=[points objectAtIndex:points.count-_model.leftEmptyKline-1];
        DaysChartModel *m = [data objectAtIndex:(data.count-2)];
        _currentDaysModel = m;
        [_priceView configPriceInfoWithModel:_currentDaysModel];
    }
}
//moveHVLine
-(void)moveHVLineWithPoint:(CGPoint)point
{
    [self createCrossLineWithTouchPoint:point];
    if (_model.type<=0)
    {
        return;
    }
    if (!_hLine)
    {
        _hLine = [[UIImageView alloc] init];
        _hLine.backgroundColor = LTWhiteColor;
        if (_model.type>0)
        {
            _hLine.frame = CGRectMake(0, point.y, _model.width, 0.5);
        }
        _hLine.autoresizesSubviews = YES;
        _hLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        [self addSubview:_hLine];
    }
    
    CGRect hframe=_hLine.frame;
    
    if((NSInteger)point.y>=_model.height*2/3.0-16)
    {
        hframe.origin.y = _model.height*2/3.0-16;
    }
    else
    {
        hframe.origin.y = (NSInteger)point.y;
    }
    
    
    if (_model.kLineDirectionStyle==FMKLineDirection_Vertical)
    {
        if((NSInteger)point.y<=SMAHeight)
        {
            hframe.origin.y = SMAHeight;
        }
    }
    else
    {
        if((NSInteger)point.y<=0)
        {
            hframe.origin.y = 0;
        }
        
    }
    if (_model.type>0)
    {
        _hLine.frame=hframe;
    }
    
    if (point.x>_model.width/2.0)
    {
        NSLog(@"right");
        _tips.frame=CGRectMake(_model.width-_tips.frame.size.width, _tips.frame.origin.y, _tips.frame.size.width, _tips.frame.size.height);
        if (_model.kLineDirectionStyle==FMKLineDirection_Vertical)
        {
            _priceView.frame=CGRectMake(0, _topBox.frame.origin.y+SMAHeight, _priceView.frame.size.width, _priceView.frame.size.height);
        }
        else
        {
            _priceView.frame=CGRectMake(0, _topBox.frame.origin.y, _priceView.frame.size.width, _priceView.frame.size.height);
        }
    }
    else
    {
        NSLog(@"left");
        
        _tips.frame=CGRectMake(0, _tips.frame.origin.y, _tips.frame.size.width, _tips.frame.size.height);
        
        if (_model.kLineDirectionStyle==FMKLineDirection_Vertical)
        {
            _priceView.frame=CGRectMake(_model.width-_priceView.frame.size.width, _topBox.frame.origin.y+SMAHeight, _priceView.frame.size.width, _priceView.frame.size.height);
        }
        else
        {
            _priceView.frame=CGRectMake(_model.width-_priceView.frame.size.width, _topBox.frame.origin.y, _priceView.frame.size.width, _priceView.frame.size.height);
        }
    }
    [self moveTipsWithPoint:point];
    if (_model.type>0)
    {
        _priceView.hidden=NO;
        [self bringSubviewToFront:_priceView];
    }
}
// moveTips
-(void)moveTipsWithPoint:(CGPoint)point
{
    CGRect frame = _tips.frame;
    if((NSInteger)point.y>=_model.height*2/3.0-20-_tips.frame.size.height)
    {
        frame.origin.y = _model.height*2/3.0-20-_tips.frame.size.height;
    }
    else
    {
        frame.origin.y = (NSInteger)point.y-_tips.frame.size.height/2.0;
    }
    if (_model.kLineDirectionStyle==FMKLineDirection_Vertical)
    {
        if((NSInteger)point.y<=SMAHeight+frame.size.height)
        {
            frame.origin.y = SMAHeight;
        }
    }
    else
    {
        if ((NSInteger)point.y<=_tips.frame.size.height/2.0)
        {
            frame.origin.y= 0;
        }
    }
    _tips.frame=frame;
    
    [self setTipsTextWithPoint:point];
    [_tips sizeToFit];
    
    if (point.x>_model.width/2.0)
    {
        NSLog(@"right");
        _tips.frame=CGRectMake(_model.width-_tips.frame.size.width, _tips.frame.origin.y, _tips.frame.size.width, _tips.frame.size.height);
        if (_model.kLineDirectionStyle==FMKLineDirection_Vertical)
        {
            _priceView.frame=CGRectMake(0, _topBox.frame.origin.y+SMAHeight, _priceView.frame.size.width, _priceView.frame.size.height);
        }
        else
        {
            _priceView.frame=CGRectMake(0, _topBox.frame.origin.y, _priceView.frame.size.width, _priceView.frame.size.height);
        }
    }
    else
    {
        NSLog(@"left");
        _tips.frame=CGRectMake(0, _tips.frame.origin.y, _tips.frame.size.width, _tips.frame.size.height);
        if (_model.kLineDirectionStyle==FMKLineDirection_Vertical)
        {
            _priceView.frame=CGRectMake(_model.width-_priceView.frame.size.width, _topBox.frame.origin.y+SMAHeight, _priceView.frame.size.width, _priceView.frame.size.height);
        }
        else
        {
            _priceView.frame=CGRectMake(_model.width-_priceView.frame.size.width, _topBox.frame.origin.y, _priceView.frame.size.width, _priceView.frame.size.height);
        }
    }
}

-(BOOL)returnTipsLeftFlagWithPoint:(CGPoint)point
{
    BOOL leftFlag=NO;//tips朝向标记
    if (point.x>=_model.width/2.0)//坐标点在右边，tips左朝向.反之亦然
    {
        leftFlag=YES;
    }
    return leftFlag;
}
// 画虚线
- (UIImage*)dottedImageWithStartPoint:(CGPoint)startPoint EndPoint:(CGPoint)endPoint Width:(int)width {
    //NSLog(@"draw start.....");
    CGRect rect = CGRectMake(0, startPoint.y, _model.width, 1);
    UIGraphicsBeginImageContext(rect.size);
    //UIGraphicsBeginImageContextWithOptions(rect.size, YES, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, width);
    // 如果是虚线
    CGFloat lengths[] = {3,3};
    CGContextSetLineDash(context, 0, lengths, 2);  //画虚线
    CGContextSetStrokeColorWithColor(context, kStockDottedLineColor.CGColor);
    const CGPoint point[] = {startPoint,endPoint};
    CGContextStrokeLineSegments(context, point, 2);  // 绘制
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
// 渐变涂层
- (CAGradientLayer *)dragLayerWithFrame:(CGRect)frame
{
    CAGradientLayer *newShadow = [[CAGradientLayer alloc] init];
    CGRect newShadowFrame = frame;
    newShadow.frame = newShadowFrame;
    newShadow.startPoint = CGPointMake(0, 1);
    newShadow.endPoint = CGPointMake(1, 1);
    //添加渐变的颜色组合
    CGColorRef startColor = [kStockTianjiLine_DregColor colorWithAlphaComponent:0].CGColor;
    CGColorRef endColor = kStockTianjiLine_DregColor.CGColor;
    newShadow.colors = [NSArray arrayWithObjects:(__bridge id)(startColor),endColor,nil];
    return newShadow;
}

// 计算时间
-(NSString *)calculateTimeWithEndMintue:(NSInteger)endTime
{
    NSInteger hour = endTime/60;
    if (hour>=24)
    {
        hour=hour-24;
    }
    NSInteger min = endTime%60;
    NSString *timeStr=[NSString stringWithFormat:@"%.2li:%.2li",hour,min];
    return timeStr;
}
-(void)showDragLineViews{
    if (_model.tianjiLineType==FMKLineTianjiLineType_None) {
        return;
    }
    NSMutableArray *lastTianji = _model.lastTianjiLine;
    if (lastTianji.count<=0) {
        return;
    }
    int index = [[lastTianji firstObject] intValue];
    // 往前移动两个周期
    if (_model.tianjiLineType==FMKLineTianjiLineType_Shock) {
        // 趋势版不用提前
        index += 2;
    }
    
    if (index>=_points.count) {
        [self removeDregViews];
        return;
    }
    NSArray *nextPoint = [_points objectAtIndex:index];
    CGPoint point = CGPointFromString([nextPoint objectAtIndex:0]);
    FMKLineTianjiLineDirection _lineDirection = [[lastTianji lastObject] intValue];
    if (_lineDirection==FMKLineTianjiLineDirection_None) {
        return;
    }
    CGFloat padding = 0;
    NSString *_text = @"阻力";
    CGFloat x = point.x ;//+ 2*(_model.klineWidth + _model.klinePadding);
    if (x+_model.klinePadding+_model.klineWidth>=_model.width || x-20<=0 || point.y<=0) {
        [self removeDregViews];
        return;
    }
    point = CGPointMake(x, point.y-padding);
    if (_lineDirection==FMKLineTianjiLineDirection_Up) {
        _text = @"支撑";
        point = CGPointFromString([nextPoint objectAtIndex:1]);
        point = CGPointMake(x, point.y+padding);
    }
    
    if (!_dragLineViews) {
        _dragLineViews = [[UIView alloc] initWithFrame:CGRectMake(point.x-15, point.y, _model.width-point.x+15, 1)];
        
        [self addSubview:_dragLineViews];
        _dragTip = [[UILabel alloc] init];
        _dragTip.font = [UIFont systemFontOfSize:LTAutoW(11)];
        _dragTip.textColor = [UIColor whiteColor];
        _dragTip.layer.cornerRadius = 3;
        _dragTip.clipsToBounds = YES;
        _dragTip.textAlignment = NSTextAlignmentCenter;
        _dragTip.backgroundColor = kStockTianjiLine_DregColor;
        [self addSubview:_dragTip];
    }
    //NSLog(@"阻力线：%@",NSStringFromCGPoint(point));
    DaysChartModel *cm = [nextPoint objectAtIndex:nextPoint.count-2];
    if (_lineDirection==FMKLineTianjiLineDirection_Down)
    {
        // 最高价
        _dragTip.text = [NSString stringWithFormat:@"%@ %@",_text,cm.heightPrice];
    }
    else
    {
        // 最低价
        _dragTip.text = [NSString stringWithFormat:@"%@ %@",_text,cm.lowPrice];
    }
    
    [_dragTip sizeToFit];
    
    _dragLineViews.frame = CGRectMake(point.x-15, point.y, _model.width-point.x+15, 1);
    for (CAGradientLayer *l in _dragLineViews.layer.sublayers) {
        [l removeFromSuperlayer];
    }
    [_dragLineViews.layer addSublayer:[self dragLayerWithFrame:_dragLineViews.bounds]];
    
    CGFloat w = Screen_width;
    if (_model.kLineDirectionStyle==FMKLineDirection_Horizontal) {
        w = Screen_height-50;
    }
    _dragTip.frame = CGRectMake(w-_dragTip.frame.size.width-5, point.y-_dragTip.frame.size.height/2-6, _dragTip.frame.size.width+10, _dragTip.frame.size.height+10);
    cm = nil;
}
-(void)reloadlineFrame{
    if (_model.type==0) {//分时的时候才执行
        // 画中间的横线
        CGFloat y = 0;
        CGFloat w = _model.width;
        CGFloat subHeight = (_model.height) / kStageMinuteHorizontalLine;
        // 横线
        for (int i=1; i<=kStageMinuteHorizontalLine; i++) {
            if (i==2) {
                continue;
            }
            FMBaseView *v =[self viewWithTag:7000+i];
            if (!v) {
                v= [self createSingleViewWithFrame:CGRectMake(0, y+(i*subHeight), w, kStageLineWidth) Color:kStageLineColor];
                [self addSubview:v];
                v.tag=7000+i;
            }else{
                v.frame=CGRectMake(0, y+(i*subHeight), w, kStageLineWidth);
            }
        }
        //竖线
        CGFloat subW=_model.width/(_model.times.count-1);
        for (int i=1; i<_model.times.count-1; i++) {
            FMBaseView *v =[self viewWithTag:8000+i];
            if (!v) {
                FMBaseView *v = [self createSingleViewWithFrame:CGRectMake(i*subW,0, kStageLineWidth, _model.height) Color:kStageLineColor];
                [self addSubview:v];
                v.tag=8000+i;
            }else{
                v.frame=CGRectMake(i*subW,0, kStageLineWidth, _model.height);
            }
        }
    }
}
#pragma mark - GestureRecognizer 手势
//点击手势
-(void)tapHandle:(UITapGestureRecognizer*)tap
{
    showVHLine=!showVHLine;
    //获取触点
    CGPoint touchViewPoint = [tap locationInView:self];
    
    if (!_hLine)
    {
        _hLine = [[UIImageView alloc] init];
        _hLine.backgroundColor = LTWhiteColor;
        if (_model.type>0)
        {
            _hLine.frame = CGRectMake(0, touchViewPoint.y, _model.width, 0.5);
        }
        _hLine.autoresizesSubviews = YES;
        _hLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        [self addSubview:_hLine];
    }
    else
    {
        if(_model.type>0)
        {
            _hLine.frame = CGRectMake(0, touchViewPoint.y, _model.width, 0.5);
        }
    }
    [self moveTipsWithPoint:touchViewPoint];
    [self moveHVLineWithPoint:touchViewPoint];
    
    if (showVHLine)
    {
        [self createCrossLineWithTouchPoint:touchViewPoint];
        if(_model.type>0)
        {
            _priceView.hidden=NO;
        }
        else
        {
            _dateTips.hidden=NO;
            _rateTips.hidden=NO;
        }
        _hLine.hidden=NO;
        _vLine.hidden=NO;
        _tips.hidden=NO;
    }
    else
    {
        _hLine.hidden=YES;
        _vLine.hidden=YES;
        _dateTips.hidden=YES;
        _tips.hidden=YES;
        _priceView.hidden=YES;
        _rateTips.hidden=YES;
    }
}

// 长按手势 - 生成十字线
-(void)longPressHandle:(UILongPressGestureRecognizer*)longResture
{
    //获取触点
    CGPoint touchViewPoint = [longResture locationInView:self];
    //NSLog(@"press:%@", NSStringFromCGPoint(touchViewPoint));
    // 手指长按开始时更新一遍
    if(longResture.state == UIGestureRecognizerStateBegan){
        showVHLine=YES;
        _hLine.hidden=NO;
        _vLine.hidden=NO;
        _dateTips.hidden=NO;
        _tips.hidden=NO;
        if(_model.type>0)
        {
            _priceView.hidden=NO;
        }
        [self createCrossLineWithTouchPoint:touchViewPoint];
    }
    // 手指移动时候开始显示十字线
    if (longResture.state == UIGestureRecognizerStateChanged)
    {
        _hLine.frame = CGRectMake(0, touchViewPoint.y, _model.width, 0.5);
        CGRect tipsFrame=_tips.frame;
        tipsFrame.origin.y=touchViewPoint.y-tipsFrame.size.height/2.0;
        _tips.frame=tipsFrame;
        [self moveTipsWithPoint:touchViewPoint];
        [self moveHVLineWithPoint:touchViewPoint];
        [self createCrossLineWithTouchPoint:touchViewPoint];
    }
    
    // 手指离开的时候移除十字线
    if (longResture.state == UIGestureRecognizerStateEnded){
    }
}

#pragma mark - scrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 重置
    _model.isZooming = NO;
    _scrollCount = 0;
    _lastScrollX = scrollView.contentOffset.x;
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    // 记录滚动结束
    _scrollCount = -1;
}
// 滚动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollX = scrollView.contentOffset.x;
    //NSLog(@"scrollX=%f",scrollX);
    // 分时图 ｜ 停止绘画 ｜ 放大过程中 都停止滚动
    if ( _model.isStopDraw || _model.isZooming)
    {
        return;
    }
    if (showVHLine)
    {
        CGPoint touchViewPoint = [scrollView.panGestureRecognizer locationInView:self];
        NSLog(@"touchViewPoint={%.2f,%.2f},",touchViewPoint.x,touchViewPoint.y);
        if (_model.type>0)
        {
            [self moveHVLineWithPoint:touchViewPoint];
        }
        else
        {
            [self createCrossLineWithTouchPoint:touchViewPoint];
        }
        return;
    }
    if([[NSString stringWithFormat:@"_model.klineWidth = %f",_model.klineWidth] isEqualToString:@"nan"]) return;
    if (scrollX<=0)
    {
        //NSLog(@"scrollX=%f",scrollX);
        _kLine.frame = CGRectMake(-scrollX, 0, _model.width, _model.height);
    }
    if (scrollX>=(_backgroundView.contentSize.width-_model.width))
    {
        _kLine.frame = CGRectMake(-(scrollX-(_backgroundView.contentSize.width-_model.width)), 0, _model.width, _model.height);
    }
    
    if (scrollX>=_lastScrollX)
    {
        _model.scrollDerectionType = FMKLineScrollLeft;
    }
    else
    {
        _model.scrollDerectionType = FMKLineScrollRight;
    }
    _lastScrollX = scrollX;
    //当前x不为scrollview最后一屏时(右滑)
    if (scrollX>=0 &&_model.offsetStart>=0 &&
        scrollX<=(scrollView.contentSize.width-scrollView.frame.size.width))
    {
        int offsetCount = floor((scrollX) / (_model.klineWidth+_model.klinePadding))+1;
        if (offsetCount<=0) {
            offsetCount = 0;
        }
        _model.offsetStart = offsetCount>=0&&offsetCount<_model.prices.count?offsetCount:_model.offsetStart;
        int pointCounts = floor((_model.width) / (_model.klineWidth + _model.klinePadding))+1;
        if (_model.prices.count<=0) {
            pointCounts = 0;
        }
        if (_model.offsetStart<0) {
            // 数据偏移起始位置
            _model.offsetStart = (int)_model.prices.count - pointCounts;
        }
        _model.offsetEnd = _model.offsetStart + pointCounts+1;
        // 更新中间点位置
        int sub = (_model.offsetEnd-_model.offsetStart+1);
        int middleIndex = _model.offsetStart+sub/2;
        _model.offsetMiddle = middleIndex;
        if (_model.offsetStart!=_model.offsetLastStart)
        {
            NSLog(@"更新=%f",scrollX);
            _model.offsetLastStart = _model.offsetStart;
            NSLog(@"_model.priceCount=%li",_model.prices.count);
            NSLog(@"_model.pointsCount=%li",[[_model.points objectForKey:kStockPointsKey_KLine] count]);
            // 更新局部数据
            [_chart updateWithModel:_model];
        }
    }
    _model.scrollOffset = scrollView.contentOffset;
}

-(void)updateStockIndexTip
{
    // 移除
    [self removeStockIndexTip];
    // 判断主图指标类型并更新显示提示
    if (_model.stockIndexType==FMStockIndexType_SAM) {
        [self createSMATip];
    }
    if (_model.stockIndexType==FMStockIndexType_EMA) {
        [self createEMATip];
    }
    if (_model.stockIndexType==FMStockIndexType_BOLL) {
        [self createBOLLTip];
    }
    // 判断幅图指标类型并更新显示提示
    if (_model.stockIndexBottomType==FMStockIndexType_MACD) {
        [self createMACDTip];
    }
    if (_model.stockIndexBottomType==FMStockIndexType_KDJ) {
        [self createKDJTip];
    }
    if (_model.stockIndexBottomType==FMStockIndexType_RSI) {
        [self createRSITip];
    }
    
}

@end
