//
//
//  FMStock
//
//  Copyright (c) 2015年 yubo. All rights reserved.
//

#import "WeiPanMarketViewController.h"
#import "MeSettingVCtrl.h"
#import "WeiPanMarketViewController+ModelHelp.h"
#import "WeiPanMarketViewController+ChartHelp.h"
#import "WeiPanMarketViewController+PushRemindHelp.h"
#import "LitMaskView.h"
#import "RechargeVCtrl.h"
#import "NewBuyView.h"
#import "SellProductView.h"
#import "WarningView.h"
#import "AsSocket.h"
#import "DataHundel.h"
#import "DiscountFigureModel.h"
#import "NetworkRequests.h"
#import "WebView.h"
@interface WeiPanMarketViewController ()<UITableViewDataSource,UITableViewDelegate>

/** 持仓轮询timer */
@property (nonatomic,strong) NSTimer *holdListTimer;
@property (nonatomic,strong) SellProductView *sellProductView;

@property (nonatomic,assign) BOOL buyUp;
@property(strong,nonatomic)NewBuyView *buyView;

@property (nonatomic,strong) WarningView *warningView;//警告
@property (nonatomic,strong)NSMutableArray * dataArray;//装图数据的数组

@property (nonatomic,copy) NSString *marginLevel;//预付款比例


@end

@implementation WeiPanMarketViewController
static BOOL firstFlag = YES;
//蒙版名字---蒙版图片名字
#define MaskKey @"mask_market"
#pragma mark - system


#pragma mark - initview
- (instancetype)initWithCode:(NSString*)code exCode:(NSString*)excode title:(NSString*)title {
    self=[super init];
    if (self) {
        _titler = title;
        _code = code;
    //    _excode = excode;
        _excode = @"FXBTG";
        [self configInitDatas];
    }
    return self;
}

- (void)configInitDatas {
    _type = @"";
    _lastType = @"";
    _fmKlineDirectionStyle = FMKLineDirection_Vertical; // 默认竖屏
    _isRequestFinish = YES;
    _isTimeLoop = NO;
    sma_Index=101;
    macd_Index=104;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navTitle:_titler backType:BackType_PopVC];
    [self createTableView];
    [self createFooterView];
    [self createTransformButton];
    
    firstFlag = YES;
    if (usePushRemind) {
        self.holdList = [[NSMutableArray alloc]init];
        self.remindList=[[NSMutableArray alloc]init];
        self.dataArray = [NSMutableArray array];
        usePushRemind? [LitMaskView commonOneceMaskWithKey:MaskKey] :nil;
        [self createRemindView];
        [self createAddRemindView];
    }
    
    NFC_AddObserver(NFC_ReloadRemind, @selector(requestPushRemindList));
    NFC_AddObserver(NFC_LocLogin, @selector(loginSuccessed));
    NFC_AddObserver(NFC_AppWillEnterForeground, @selector(appWillEnterForeground));
    [self createWarningView];
    [self createBuyView];
    [self createSellView];
    
}
-(void)newRequest :(NSString * )timeStr
{
    long long now = [[NSDate date] timeIntervalSince1970] * 1000;
    long  long startTime =now - timeStr.longLongValue *60000 * 50;
    NSNumber *nowNumber = [NSNumber numberWithLongLong:now];
    NSNumber * StartNumber =[NSNumber numberWithLongLong:startTime];
    NSString* nowStr = [DataHundel ConvertStrToTime:nowNumber.stringValue];
    NSString * startStr =[DataHundel ConvertStrToTime:StartNumber.stringValue];
    NSString * url = [NSString stringWithFormat:@"%@%@",BasisUrl,@"/price/records"];
    NSDictionary * dic =@{@"server":@"DEMO",@"symbol":_code,@"startDate":startStr,@"endDate":nowStr,@"period":timeStr};
    [[NetworkRequests sharedInstance]GET:url dict:dic succeed:^(id data) {
        self.dataArray =[data objectForKey:@"dataObject"];
        [self.model.prices addObjectsFromArray:self.dataArray];
    } failure:^(NSError *error) {
        
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UMengEvent(page_product_detail);// 品种详情页面的事件统计
    [MobClick event:@"product_click" attributes:@{@"name" : [NSString stringWithFormat:@"%@_%@",_titler,_code]}];// 每个品种的查看次数
    if (_fmKlineDirectionStyle==FMKLineDirection_Horizontal) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    }
    if ([LTUser hasLogin]) {
        [self requestPushRemindList];
    }
    [self flagForMarket:YES];
    //长链接
    [self addNotification];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.headerview animationStop];
    
    [self canclePollingHoldList];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self flagForMarket:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setRemindConfigModel:(PushRemindConfigModel *)remindConfigModel {
    _remindConfigModel = remindConfigModel;
    
    self.myRemindView.remindConfigModel = _remindConfigModel;
    self.addRemindView.remindConfigModel = _remindConfigModel;
}
#pragma mark - 获取socket实时数据
-(BaseTableViewCell *)headerCell
{
    //上个页面传来的header上的数据
    KLineHeaderView * headerViewCell = [[KLineHeaderView alloc]init];
    if (_change.floatValue > 0) {
        headerViewCell.price.textColor = LTKLineRed;
         headerViewCell.change.textColor = LTKLineRed;
        headerViewCell.changerate.textColor = LTKLineRed;
    }else
    {
        headerViewCell.price.textColor = LTKLineGreen;
        headerViewCell.change.textColor = LTKLineGreen;
        headerViewCell.changerate.textColor = LTKLineGreen;
    }
    [headerViewCell.price countFrom:0.00 to:_price.doubleValue withDuration:0.4];
    headerViewCell.changerate.text = _changeCHa;
    headerViewCell.change.text = _change;
    NSString * timeStr =[NSString stringWithFormat:@"%@ %@",_dataStr, _timeStr];
    long long  haomiao_=  [DataHundel getZiFuChuan:timeStr];
    long long lastTime = haomiao_  +( 5 * 60*60*1000);
    NSNumber *longlongNumber = [NSNumber numberWithLongLong:lastTime];
    NSString *longlongStr = [longlongNumber stringValue];
    headerViewCell.time.text =[DataHundel convertime:longlongStr];
    NSString * percentage =[NSString stringWithFormat:@"%@%@%@",@"%0.",[NSString stringWithFormat:@"%ld",_digit],@"f"];
    headerViewCell.close_price.text = [NSString stringWithFormat:percentage,_close.floatValue];
    headerViewCell.heigt_price.text = [NSString stringWithFormat:percentage,_high.floatValue];
    headerViewCell.low_price.text = [NSString stringWithFormat:percentage,_low.floatValue];
    headerViewCell.open_price.text = [NSString stringWithFormat:percentage,_open.floatValue];
    //获取socket数据
    [[AsSocket shareDataAsSocket]setReturnValueBlock:^(NSMutableArray *socketArray) {
        if (socketArray.count > 0) {
            for (SocketModel * model in socketArray) {
                if ([model.symbol isEqualToString:self.code]) {
                    [headerViewCell upDataHeaderPrice:model];
                    [self.buyView addCode:self.code code_cn:self.titler prcieIn:model.buy_in priceOut:model.buy_out ];
                }
            }
        }
    }];
    return headerViewCell;
}

- (void)pushRecharge:(ExchangeType)exType {
    RechargeVCtrl *ctrl = [[RechargeVCtrl alloc] init];
    [self pushVC:ctrl];
}

//初始化SMA View
-(void)initSMAKindView {
    if (!_kind_SMA_View) {
        _kind_SMA_View=[[KLineSMAVerticalView alloc]initWithFrame:CGRectMake(0,self.header.frame.origin.y+self.header.frame.size.height+kLineChartHeaderViewHeight+36, Screen_width, SMAHeight)];
        WS(ws);
        _kind_SMA_View.SMAButtonBlock = ^(NSString* code) {
            [ws updateIndexViewWithCode:code];
        };
        if(ws.model.kLineDirectionStyle==FMKLineDirection_Horizontal) {
            ws.kind_SMA_View.hidden=YES;
        }
        [ws.view addSubview:ws.kind_SMA_View];
    } else {
        if (_model.kLineDirectionStyle==FMKLineDirection_Vertical) {
            _kind_SMA_View.frame=CGRectMake(0, kLineChartHeaderViewHeight+_klineNavView.frame.size.height+self.header.frame.origin.y+self.header.frame.size.height, Screen_width, SMAHeight);
        } else {
            _kind_SMA_View.hidden=YES;
        }
    }
}

//初始化MACD View
-(void)initMACDKindView {
    if (!_kind_MACD_View) {
        _kind_MACD_View=[[KLineMACDVerticalView alloc]initWithFrame:CGRectMake(0, 64+kLineChartHeaderViewHeight+36+2/3.0*_model.height, Screen_width, MACDHeight)];
        WS(kc);
        _kind_MACD_View.MACDButtonBlock = ^(NSString* code) {
            [kc updateIndexViewWithCode:code];
        };
        if(_model.kLineDirectionStyle==FMKLineDirection_Horizontal) {
            _kind_MACD_View.hidden=YES;
        }
        [self.view addSubview:_kind_MACD_View];
    } else {
        if (_model.kLineDirectionStyle==FMKLineDirection_Vertical) {
            _kind_MACD_View.frame=CGRectMake(0, 64+kLineChartHeaderViewHeight+_klineNavView.frame.size.height+2/3.0*_model.height, Screen_width, MACDHeight);
        } else {
            _kind_MACD_View.hidden=YES;
        }
    }
}

// table
-(void)createTableView
{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, self.header.frame.origin.y+self.header.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.header.frame.origin.y-self.header.frame.size.height - kLineChartFooterViewHeight) style:UITableViewStylePlain];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableview];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        [self createKlineBoxView];
    } else {
        _tableview.hidden = NO;
        _tableview.alpha = 1;
        if (self.fmKlineDirectionStyle==FMKLineDirection_Horizontal) {
            _tableview.frame = CGRectMake(0, kNavigationHeight, Screen_height, Screen_width-kNavigationHeight);
        }else{
            _tableview.frame = CGRectMake(0, self.header.frame.origin.y+self.header.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.header.frame.origin.y-self.header.frame.size.height - kLineChartFooterViewHeight);
        }
        // k线图
        [self createKlineBoxView];
        //左边菜单
        [self createHorizontalIndexNavViews];
        
    }
    _tableview.scrollEnabled = NO;
}

// 底部导航
-(void)createFooterView {
    
    if (!_footerview) {
        _footerview = [[KChatLineFootView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-kLineChartFooterViewHeight, self.view.frame.size.width, kLineChartFooterViewHeight)];
        [self.view addSubview:_footerview];
        WS(ws);
        _footerview.kChatLineFootViewBlock = ^(NSString *buttonName){
            if ([buttonName isEqualToString:@"买涨"]) {
                JudgeUserCanUseDeal;
                [ws pushToOrderView:YES];// 点击跳转订单页
            }
            else if ([buttonName isEqualToString:@"买跌"]) {
                JudgeUserCanUseDeal;
                [ws pushToOrderView:NO];// 点击跳转订单页
            }
            else if ([buttonName isEqualToString:@"平仓"]) {
                JudgeUserCanUseDeal;
                [ws showSellProduct];// 出现平仓列表
            }
            else if ([buttonName isEqualToString:@"暂无持仓"]) {
                //无点击事件
            }
            else if ([buttonName isEqualToString:@"查看持仓"]) {
                //token过期时
                [ws checkTimeOut:^{
                } failure:nil];
            }
            else if ([buttonName isEqualToString:@"前往交易大厅"]) {
                //                kPublicData.isChangeToDeal=YES;
                [ws pushToDealViewController];// 点击跳转订单页
            }
        };
        NSString *onlyKey = [NSString stringWithFormat:@"%@|%@",_excode,_code];
        NSString *codes = [LTUser homeProductListString];
        if ([codes contains:onlyKey]) {
            _footerview.viewTyp = KChatLineFootViewType_BuyAndClose;
        } else {
            _footerview.viewTyp = KChatLineFootViewType_GoDeal;
        }
        
    } else {
        if (self.fmKlineDirectionStyle==FMKLineDirection_Vertical) {
            _footerview.hidden = NO;
            _footerview.alpha = 0;
            WS(ws);
            [UIView animateWithDuration:0.3 animations:^{
                ws.footerview.frame = CGRectMake(0, self.view.frame.size.height-kLineChartFooterViewHeight, self.view.frame.size.width, kLineChartFooterViewHeight);
                ws.footerview.alpha = 1;
            } completion:nil];
        }
    }
}
// 单独为横屏创建头部
-(void)createHorizontalHeaderView {
    if (!_horizontalHeaderView) {
        _horizontalHeaderView = [[KLineSelectIndexHView alloc] initWithFrame:CGRectMake(0, 0, Screen_height, kNavigationHeight) Title:_titler];
        [self.view addSubview:_horizontalHeaderView];
        // 点击返回按钮
        WS(ws);
        _horizontalHeaderView.clickReturnBackButtonBlock = ^{
            [ws returnBack];
        };
        _horizontalHeaderView.clickTypeButtonBlock = ^(KLineSelectIndexHView*view,NSArray*countrys,BOOL isSelected){
            if (countrys.count>0) {
                NSString *selectvalue = [countrys firstObject];
                // 横屏时，每个K线周期的点击次数
                [MobClick event:@"kline_cycle_horizontal" attributes:@{@"timezoom":selectvalue}];
                ws.lastType = ws.type;
                ws.type = selectvalue;
                _isTimeLoop = NO;
                // 更新竖屏视图的按钮高亮
                [ws.klineNavView updateHighlightsButtonsWithType:selectvalue];
                [ws createDaysChart];
            }
        };
        _horizontalHeaderView.clickIndexButtonBlock = ^(KLineSelectIndexHView*view,NSArray*countrys,BOOL isSelected){
            if (countrys.count>0) {
                NSString *selectvalue = [countrys firstObject];
                // 横屏时，每种指标的点击次数
                [MobClick event:@"kline_type_horizontal" attributes:@{@"index":selectvalue}];
                // 更新指标视图
                [ws updateIndexViewWithCode:selectvalue];
            }
            else
            {
                [ws updateIndexViewWithCode:@"CLEAR"];
            }
        };
    }
    if (self.fmKlineDirectionStyle==FMKLineDirection_Horizontal) {
        [_horizontalHeaderView updateZoushiTitleWithType:_type];
        // 更新价格涨跌幅
        [_horizontalHeaderView updateTitlesPrice:_stockDish];
        _horizontalHeaderView.frame = CGRectMake(0, -kNavigationHeight, Screen_height, kNavigationHeight);
        _horizontalHeaderView.alpha = 0;
        WS(ws);
        [UIView animateWithDuration:0.3 animations:^{
            ws.horizontalHeaderView.frame = CGRectMake(0,0, Screen_height, kNavigationHeight);
            ws.horizontalHeaderView.alpha = 1;
        }];
    }
}

//创建全屏旋转按钮
-(void)createTransformButton {
    // 更多按钮
    if (!_moreBtn && usePushRemind) {
        UIImage *bgimg = [UIImage imageNamed:@"moreIcon"];
        UIImageView *img=[self createImgWithImage:bgimg
                                            frame:CGRectMake(self.header.frame.size.width-36, 12, 20, 20)];
        [self.header addSubview:img];
        _moreBtn = [self createBtnWithFrame:CGRectMake(self.header.frame.size.width-40, 0, 40,44)];
        [_moreBtn setTitleColor:LTTitleRGB forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(showMoreView) forControlEvents:UIControlEventTouchUpInside];
        img.center=_moreBtn.center;
        [self.header addSubview:_moreBtn];
    }
    
    // 旋转按钮
    if (!_transBtn && !usePushRemind) {
        UIImage *bgimg = [UIImage imageNamed:@"chart_btn_viewchange"];
        UIImageView *img=[self createImgWithImage:bgimg
                                            frame:CGRectMake(self.header.frame.size.width-36, 12, 20, 20)];
        [self.header addSubview:img];
        _transBtn = [self createBtnWithFrame:CGRectMake(self.header.frame.size.width-40, 0, 40,44)];
        [_transBtn setTitleColor:LTTitleRGB forState:UIControlStateNormal];
        [_transBtn addTarget:self action:@selector(changeViewDirection) forControlEvents:UIControlEventTouchUpInside];
        img.center=_transBtn.center;
        [self.header addSubview:_transBtn];
    }
}
// 创建k线图表
-(void)createKlineBoxView {
    CGFloat h = _tableview.frame.size.height - kLineChartHeaderViewHeight - kLineChart_nav_height;
    if (!_klinebox) {
        _klinebox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, h)];
        _klinebox.backgroundColor =  KLineBoxBG;
    } else {
        /*********************
         横竖屏切换逻辑
         *********************/
        _klinebox.hidden = NO;
        _klinebox.alpha  = 1;
        if (self.fmKlineDirectionStyle == FMKLineDirection_Horizontal) {
            _klinebox.frame = CGRectMake(0, 0, Screen_height, Screen_width-kNavigationHeight-kLineChart_nav_height);
        } else {
            _klinebox.frame = CGRectMake(0, 0, self.view.frame.size.width, h);
        }
        _type = _lastType;
        [self updateDaysChart];
    }
}
// 创建横屏的指标菜单
-(void)createHorizontalIndexNavViews
{
    CGFloat padding = 0;
    if (!_klineHorizontalIndexNavView) {
        _klineHorizontalIndexNavView = [[KLineHorizontalIndexNavView alloc] initWithFrame:CGRectMake(Screen_height, kNavigationHeight, kLineChartView_LeftNavViewWidth-padding, Screen_width-kNavigationHeight-kLineChart_nav_height)];
        [self.view addSubview:_klineHorizontalIndexNavView];
        // 点击指标
        WS(ws);
        _klineHorizontalIndexNavView.clickKLineHorizontalNavButtonBlock = ^(NSString* code) {
            [ws updateIndexViewWithCode:code];
        };
    }
    WS(ws);
    if (self.fmKlineDirectionStyle==FMKLineDirection_Horizontal) {
        _klineHorizontalIndexNavView.hidden = NO;
        // 动画呈现
        [UIView animateWithDuration:0.2 animations:^{
            ws.klineHorizontalIndexNavView.frame = CGRectMake(Screen_height-kLineChartView_LeftNavViewWidth, kNavigationHeight, kLineChartView_LeftNavViewWidth-padding, Screen_width-kNavigationHeight-kLineChart_nav_height);
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            ws.klineHorizontalIndexNavView.frame = CGRectMake(Screen_height + kLineChartView_LeftNavViewWidth, kNavigationHeight, kLineChartView_LeftNavViewWidth-padding, Screen_width-kNavigationHeight-kLineChart_nav_height);
        } completion:^(BOOL isfinish){
            ws.klineHorizontalIndexNavView.hidden = YES;
        }];
        
    }
}
-(UIButton *)createBtnWithFrame:(CGRect)frame {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    return btn;
}
-(UIImageView *)createImgWithImage:(UIImage *)image frame:(CGRect)frame {
    UIImageView *imgV = [[UIImageView alloc]init];
    imgV.frame=frame;
    if (kChangeImageColor) {
        image = [image changeColor:NavBarSubCoror];
    }
    imgV.contentMode =  UIViewContentModeCenter;
    imgV.image=image;
    return imgV;
}
-(void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateQuotations:) name:NFC_SocketUpdateQuotations object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateQuotationsError:) name:NFC_SocketUpdateQuotationsFailure object:nil];
}
-(void)removeNotification {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


//通知：成功接收到行情
- (void)updateQuotations:(NSNotification *)obj {
    NSArray *arr = obj.object;
    
    for (NSDictionary *dict in arr) {
        BOOL bl = [dict boolFoKey:@"success"];
        NSString *type = [dict stringFoKey:@"type"];
        if (bl && [type isEqualToString:kResQP]) {
            NSDictionary *dic = [dict dictionaryFoKey:@"data"];
            if (!_stockDish && ![dic isNull]) {
                return;
            }
            NSString *low=[dic stringFoKey:@"low"];//最低
            NSString *high=[dic stringFoKey:@"top"];//最高
            NSString *open=[dic stringFoKey:@"open"];//今开
            NSString *close=[dic stringFoKey:@"last_close"];//昨收
            NSString *sell=[dic stringFoKey:@"sell"];//当前价位
            
            BOOL lowflag = !notemptyStr(low);
            BOOL highflag = !notemptyStr(high);
            BOOL sellflag = !notemptyStr(sell);
            BOOL openflag = !notemptyStr(open);
            BOOL closeflag = !notemptyStr(close);
            
            if ( !([[dic stringFoKey:@"excode"] isEqualToString:_excode] && [[dic stringFoKey:@"code"] isEqualToString:_code])
                || lowflag
                || highflag
                || sellflag
                || openflag
                || closeflag) {
                NSLog(@"dic======%@",dic);
                return;
            }
            [_stockDish dataWithProductDic:dic];
        }
    }
    [self.headerview startAnimation];
    if (_type.length<=0) {
    //    [self updateHeaderView:YES];
        if (_minutemodel.prices.count!=0)//没有价格就重新请求分时数据
        {
            [self updateMinuteViewForSocket];//拼接分时数据
        }
    }
    else{
     //   [self updateHeaderView:NO];
        if (_model.prices.count!=0)
        {
            [self updateDaysViewForSocket];//拼接K线数据
        }
    }
}
//长连接通知：获取行情失败
- (void)updateQuotationsError:(NSNotification *)obj {
    NSArray *arr = obj.object;
    for (NSDictionary *dict in arr) {
        BOOL bl = [dict boolFoKey:@"success"];
        NSString *type = [dict stringFoKey:@"type"];
        if (!bl && [type isEqualToString:kResQP]) {
            NSString *codes = [NSString stringWithFormat:@"%@|%@",_excode,_code];
            [LTSocketServe sendRTC:codes];
        }
    }
}

#pragma mark - actions_pushToVC
// 跳转交易大厅
-(void)pushToDealViewController {
    [self.navigationController popViewControllerAnimated:YES];
    [AppDelegate selectTabBarIndex:2];
}
// 跳转到直播室
- (void)pushToLiveView {
    UMengEvent(UM_MarketDetail_Live);
    [AppDelegate selectTabBarIndex:3];
    [self.navigationController popViewControllerAnimated:NO];
}

//充值
-(void)recharge
{
    RechargeVCtrl *rechargeVC = [[RechargeVCtrl alloc] init];
    [self pushToViewController:rechargeVC];
}
- (void)pushToViewController:(UIViewController *)controller {
    [self pushVC:controller];
}



#pragma mark - actions_btnClick
//从后台唤醒
-(void)appWillEnterForeground {
    [self clickNavHandleWithButtonType:_type];
}
// 点击周期导航按钮
-(void) clickNavHandleWithButtonType:(NSString*)typestr{
    _lastType = typestr;
    _type = typestr;
    _isTimeLoop = NO;
        [self createDaysChart];
}

//  切换横屏
-(void)changeViewDirection {
    // 绘画停止信号
    _model.isStopDraw = YES;
    _minutemodel.isStopDraw = YES;
    if (self.fmKlineDirectionStyle==FMKLineDirection_Vertical) {//竖屏->横屏
        _warningView.hidden = YES;
        if (_model || _minutemodel) {
            self.fmKlineDirectionStyle = FMKLineDirection_Horizontal;
            [self viewsChangeHorizontalAnimation];
        }
        [self.klineHorizontalIndexNavView reloadSelectWithTag:sma_Index macdTag:macd_Index];
    } else {//横屏->竖屏
        [self availableAdvance];
        self.fmKlineDirectionStyle = FMKLineDirection_Vertical;
        // 转成竖屏
        [self viewsChangeVerticalAnimation];
        [_kind_SMA_View reloadSelectWithTag:sma_Index];
        [_kind_MACD_View reloadSelectWithTag:macd_Index];
    }
    NFC_PostName(NFC_WeipanRotation);//刷新横竖线
}
//返回
-(void)returnBack {
    if (self.fmKlineDirectionStyle==FMKLineDirection_Horizontal) {
        [self changeViewDirection];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)showMoreView{
    [self configPopTable];
}
#pragma mark - actions_view function
-(void)hideKindViewControl {
    BOOL flag = YES;
    BOOL hflag = YES;
    //竖屏
    if(_fmKlineDirectionStyle==FMKLineDirection_Vertical) {
        if (![_type isEqualToString:@""]) {
            flag=NO;
        }
    }
    else{
        if (![_type isEqualToString:@""]) {
            hflag=NO;
        }
    }
    _kind_SMA_View.hidden=flag;
    _kind_MACD_View.hidden=flag;
    _klineHorizontalIndexNavView.hidden=hflag;
}

//重置SMA MACD View 选中
-(void)reloadSelect {
    sma_Index=101;
    macd_Index=104;
    [_kind_SMA_View reloadSelectWithTag:101];
    [_kind_MACD_View reloadSelectWithTag:104];
}
- (void)reqTickChartIsSuccess:(BOOL)bl {
    _isRequestFinish = YES;
    _isTimeLoop = YES;
    [_tableview.header endRefreshing];
    [_transform stop];
    _klineNavView.isFinish = YES;
    if (!bl) {
        [_minutechart error];
    }
}
// 通过指标代号更新指标
-(void)updateIndexViewWithCode:(NSString*)code {
    if ([code isEqualToString:@"SMA"]) {
        _model.stockIndexType = FMStockIndexType_SAM;
        sma_Index=101;
        [_dayschart updateWithModel:_model];
    }
    if ([code isEqualToString:@"EMA"]) {
        _model.stockIndexType = FMStockIndexType_EMA;
        sma_Index=102;
        [_dayschart updateWithModel:_model];
    }
    if ([code isEqualToString:@"BOLL"]) {
        _model.stockIndexType = FMStockIndexType_BOLL;
        sma_Index=103;
        [_dayschart updateWithModel:_model];
    }
    if ([code isEqualToString:@"MACD"]) {
        _model.stockIndexBottomType = FMStockIndexType_MACD;
        macd_Index=104;
        [_dayschart updateWithModel:_model];
    }
    if ([code isEqualToString:@"KDJ"]) {
        _model.stockIndexBottomType = FMStockIndexType_KDJ;
        macd_Index=105;
        [_dayschart updateWithModel:_model];
    }
    if ([code isEqualToString:@"RSI"]) {
        _model.stockIndexBottomType = FMStockIndexType_RSI;
        macd_Index=106;
        [_dayschart updateWithModel:_model];
    }
    if ([code isEqualToString:@"CLEAR"]) {
        _model.stockIndexBottomType = FMStockIndexType_MACD;
        sma_Index=101;
        macd_Index=104;
        _model.stockIndexType = -1;
        [_dayschart updateWithModel:_model];
    }
}
// 旋转横屏动画
-(void)viewsChangeHorizontalAnimation {
    //设置应用程序的状态栏到指定的方向
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
    [self hideKindViewControl];
    //隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    // 动画隐藏其他视图
    CGFloat upHeight = 0;
    _horizontalHeaderView.alpha = 0;
    WS(ws);
    [UIView animateWithDuration:.3 animations:^{
        [ws.tableview moveRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] toIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
        // 头部向上一点并隐藏
        ws.headerview.frame = CGRectMake(0, (ws.headerview.frame.origin.y), Screen_height, 0);
        NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:0 inSection:0];
        NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
        [ws.tableview reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        // 面板导航栏
        ws.klineNavView.frame = CGRectMake(ws.klineNavView.frame.origin.x, (ws.klineNavView.frame.origin.y), Screen_height, ws.klineNavView.frame.size.height);
        ws.tableview.frame = CGRectMake(0, ws.tableview.frame.origin.y-upHeight, Screen_height, ws.tableview.frame.size.height+upHeight);
        // 头部尾部
        ws.header.frame = CGRectMake(ws.header.frame.origin.x, (ws.header.frame.origin.y-upHeight), Screen_height, ws.header.frame.size.height);
        ws.header.alpha = 0;
        ws.stateView.frame = CGRectMake(ws.stateView.frame.origin.x, (ws.stateView.frame.origin.y-upHeight), Screen_height, ws.stateView.frame.size.height);
        ws.stateView.alpha = 0;
        ws.footerview.frame = CGRectMake(ws.footerview.frame.origin.x, (ws.footerview.frame.origin.y+upHeight), Screen_height, ws.footerview.frame.size.height);
        
        ws.view.transform = CGAffineTransformIdentity;
        ws.view.transform = CGAffineTransformMakeRotation(M_PI/2);
        ws.view.bounds = CGRectMake(0.0, 0.0, Screen_height, Screen_width);
        // 横屏头部
        [ws createHorizontalHeaderView];
        [ws createTableView];
    } completion:nil];
    
}
// 旋转竖屏动画
-(void)viewsChangeVerticalAnimation {
    //设置应用程序的状态栏到指定的方向
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    //隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    //显示竖直指标
    [self hideKindViewControl];
    self.stateView.alpha = 1;
    self.header.alpha = 1;
    _tableview.hidden = NO;
    _tableview.alpha = 1;
    _headerview.alpha = 1;
    WS(ws);
    [UIView animateWithDuration:.3 animations:^{
        ws.headerview.frame = CGRectMake(0, 0, Screen_width, kLineChartHeaderViewHeight);
        NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:0 inSection:0];
        NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
        [ws.tableview reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        [ws.tableview moveRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] toIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
        // 头部向上一点并隐藏
        ws.horizontalHeaderView.frame = CGRectMake(ws.horizontalHeaderView.frame.origin.x, -kNavigationHeight, ws.horizontalHeaderView.frame.size.width, kNavigationHeight);
        ws.klineHorizontalIndexNavView.frame = CGRectMake(Screen_width +kLineChartView_LeftNavViewWidth, kNavigationHeight, kLineChartView_LeftNavViewWidth, Screen_width-kNavigationHeight-kLineChart_nav_height);
        // 重新排列
        ws.view.transform = CGAffineTransformMakeRotation(0.0f);
        ws.view.frame = CGRectMake(0, 0, Screen_width, Screen_height);
        // 表格
        // 头部尾部
        ws.header.frame = CGRectMake(ws.header.frame.origin.x, (ws.stateView.frame.size.height), ws.header.frame.size.width, ws.header.frame.size.height);
        
        ws.stateView.frame = CGRectMake(ws.stateView.frame.origin.x, 0, ws.header.frame.size.width, self.stateView.frame.size.height);
        
        [ws createTableView];
        [ws createFooterView];
    } completion:nil];
    if(_model.kLineDirectionStyle==FMKLineDirection_Vertical) {
        [self initSMAKindView];
        [self initMACDKindView];
    }
}
-(void)flagForMarket:(BOOL)isShow{
    NSString *key = [NSString stringWithFormat:@"%@_%@_MarketIsPresent",self.excode,self.code];
    if (isShow) {
        UD_SetObjForKey(@"1", key);
    }else{
        UD_SetObjForKey(@"0", key);
    }
    
    }

#pragma mark - tableDlegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat h = 0;
    if (self.fmKlineDirectionStyle==FMKLineDirection_Horizontal) {
        if (indexPath.row==1) {
            h = Screen_width-kNavigationHeight-kLineChart_nav_height;
        }
        if (indexPath.row==2) {
            h = kLineChart_nav_height;
        }
    } else {
        if (indexPath.row==0) {
            h = kLineChartHeaderViewHeight;
        }
        if (indexPath.row==1) {
            h = kLineChart_nav_height;
        }
        if (indexPath.row==2) {
            h = tableView.frame.size.height - kLineChartHeaderViewHeight - kLineChart_nav_height;
        }
    }
    return h;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

#pragma mark - 重用池
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [NSString stringWithFormat:@"klinecell_%ld",(long)indexPath.row];
    if (self.fmKlineDirectionStyle == FMKLineDirection_Horizontal) {
        if (indexPath.row==1) {
            cellIdentifier = @"klinecell_2";
        }
        if (indexPath.row==2) {
            cellIdentifier = @"klinecell_1";
        }
    }
    BaseTableViewCell *cell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        if (indexPath.row==0) {
            cell = [[KLineHeaderView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        if (indexPath.row==1) {
            _klineNavView = [[WeiPanKChartNavigationView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            _klinebox.backgroundColor = KLineBoxBG;
            cell = _klineNavView;
            [self clickNavHandleWithButtonType:@"10"];
            // 点击导航按钮
            WS(ws);
            _klineNavView.clickNavButtonBlock = ^(WeiPanKChartNavigationView* nav,NSString* typestr) {
                BOOL isCheckLoginPass = YES;
                ws.type=typestr;
                [ws hideKindViewControl];
                
                //处理点击状态
                [ws reloadSelect];
                [ws.klineHorizontalIndexNavView reloadSelect];
                if (isCheckLoginPass) {
                    [ws clickNavHandleWithButtonType:typestr];
                }
            };
        }
        if (indexPath.row==2) {
            cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:_klinebox];
        }
    }
    if (indexPath.row==0) {
        _headerview = (KLineHeaderView*)cell;
        cell =   [self headerCell];
    }
    if (indexPath.row==1 && self.fmKlineDirectionStyle==FMKLineDirection_Horizontal) {
        [cell.contentView addSubview:_klinebox];
    }
    
    if (_klineNavView) {
        if (self.fmKlineDirectionStyle==FMKLineDirection_Horizontal) {
            [_klineNavView updateViews:CGRectMake(0, 0, Screen_height-kLineChartView_LeftNavViewWidth, _klineNavView.h_)];
        }
        else {
            [_klineNavView updateViews:CGRectMake(0, 0, Screen_width, _klineNavView.h_)];
        }
        [_klineNavView updateHighlightsButtonsWithType:_lastType];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(BOOL)tableView:(UITableView *) tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;//打开编辑
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;//允许移动
}

#pragma mark - 建仓
- (void)createBuyView {
    if (!_buyView) {
        _buyView = [[NewBuyView alloc] init];
        _buyView.code = self.code;
        _buyView.code_cn = self.code_cn;
        _buyView.stops_level = self.stops_level;
        _buyView.dataly = self.digit;
        _buyView.closePrice = self.close;
        _buyView.change = self.change;
        [self.view addSubview:_buyView];

        WS(ws);
        [_buyView setBuyFinish:^(){
            [ws.view showTip:@"建仓成功"];
            [ws.buyView showView:NO];
        }];
        [_buyView setPrensentBlock:^{
            WebView * webView =[[WebView alloc]init];
            [ws presentVC:webView];
        }];
    }
}
//买涨买跌
- (void)pushToOrderView:(BOOL)buyUp {
    _buyUp = YES;
    BuyType buyType = buyUp ? BuyType_Up : BuyType_Down;
    [_buyView buyType:buyType];
    [_buyView showView:YES];
    [self.view bringSubviewToFront:_buyView];
    [_buyView showView:YES];
    [self.view bringSubviewToFront:_buyView];
}

//显示建仓成功
- (void)showSuccessView {
    UIView *successV= [[UIApplication sharedApplication].keyWindow viewWithTag:9999];
    if (!successV) {
        successV =[LTAlertView successViewWithMsg:@"建仓成功"];
        successV.tag=9999;
        successV.center=self.view.center;
        [[UIApplication sharedApplication].keyWindow addSubview:successV];
    }
    successV.hidden=NO;
    [self performSelector:@selector(hideSuccessView) withObject:nil afterDelay:1.5];
}

//隐藏建仓成功
- (void)hideSuccessView {
    UIView *successV= [[UIApplication sharedApplication].keyWindow viewWithTag:9999];
    successV.hidden=YES;
    [successV removeFromSuperview];
    successV=nil;
}



#pragma mark - 持仓
- (void)createSellView {
    if (!_sellProductView) {
        self.sellProductView = [[SellProductView alloc] initWithContentY:(ScreenH_Lit - kBuyViewH)];
        [self.view addSubview:self.sellProductView];
        
        WS(ws);
        [self.sellProductView setShutView:^(ExchangeType exType) {
            [ws canclePollingHoldList];
        }];
        
        [self.sellProductView setSellFinish:^(NSString *msg,NSString *code) {
            [ws.view showSuccessWithTitle:msg];
        }];
    }
}


- (void)showSellProduct {
    
    BOOL canNotNext = [self checkTimeOut];
    if (canNotNext) { return; }
    
    [self.sellProductView refDatas:self.holdList];
    [self.sellProductView showView:YES];
    
    if (self.holdList.count > 0) {
        [self pollingHoldList];
    } else {
        [self.footerview changeThirdBtnWithText:@"暂无持仓"];
    }
}

//持仓轮询
- (void)pollingHoldList {
    [self canclePollingHoldList];
    NSLog(@"持仓轮询开启11111111111");
    self.holdListTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(loadHoldDatasPolling) userInfo:nil repeats:YES];
}

//取消持仓轮询
- (void)canclePollingHoldList {
    if (self.holdListTimer) {
        NSLog(@"持仓轮询关闭000000000");
        [self.holdListTimer setFireDate:[NSDate distantFuture]];
        [self.holdListTimer invalidate];
        self.holdListTimer = nil;
    }
}

- (void)loginSuccessed {
}

#pragma mark - 警告提醒

- (void)createWarningView {
    CGFloat y = NavBarTop_Lit + kLineChartHeaderViewHeight + kLineChart_nav_height;
    self.warningView = [WarningView orangeView:y];
    self.warningView.hidden = YES;
    [self.view addSubview:_warningView];
}

- (void)availableAdvance {
    //预付款比例
    NSString *marginLevel = _marginLevel;
    CGFloat marginLevelf = [marginLevel floatValue];
    if (marginLevelf <= 150 && marginLevelf>100) {
        NSString *contractExpire = [NSString stringWithFormat:@"爆仓警告：净值/已用预付款 = %.0f%%，已接近100%%爆仓线，入金或减仓，减免风险",marginLevelf];
        [self showWarningView:contractExpire];
    } else {
        [self showWarningView:nil];
    }
    
}

- (void)showWarningView:(NSString *)contractExpire {
    if (contractExpire) {
        self.warningView.hidden = NO;
        self.warningView.content = contractExpire;
        self.warningView.imgName = IN_OutOfStock;
    } else {
        self.warningView.hidden = YES;
        self.warningView.content = @"";
        self.warningView.imgName = @"";
    }
}

-(void)dealloc{
    [self removeNotification];
    //data
    _titler=nil;
    _excode=nil;
    _code=nil;
    
    _lastData = nil;
    [_candleList removeAllObjects];
    _candleList=nil;
    [_priceList removeAllObjects];
    _priceList=nil;
    [_productList removeAllObjects];
    _productList=nil;
    
    _dayschart = nil;
    _model = nil;
    _minutechart = nil;
    _minutemodel = nil;
    _stockDish = nil;
    //view
    _tableview=nil;
    _headerview = nil;
    _footerview = nil;
    _horizontalHeaderView=nil;
    _klineNavView=nil;
    _kind_SMA_View=nil;
    _kind_MACD_View=nil;
    _transform = nil;
    _transBtn=nil;
    //    _liveBtn=nil;
    _morePopView=nil;
    _moreBtn=nil;
    
    [_remindList removeAllObjects];
    _remindList=nil;
    _remindConfigModel=nil;
    NFC_RemoveObserver(NFC_ReloadRemind);
    NFC_RemoveObserver(NFC_WeipanRotation);
    NFC_RemoveObserver(NFC_AppWillEnterForeground);
}





@end

