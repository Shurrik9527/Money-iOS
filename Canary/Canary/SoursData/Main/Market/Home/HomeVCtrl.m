//
//  HomeVCtrl.m
//  Canary
//
//  Created by litong on 2017/5/8.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "HomeVCtrl.h"
#import "QuotationScrollView.h"
#import "PollADView.h"
#import "GainSectionView.h"
#import "NewsCellOne.h"
#import "NewsCellThree.h"
#import "NewsCellFour.h"
#import "GainVCtrl.h"
#import "GainModel.h"
#import "Quotation.h"
#import "LTSocketServe.h"
#import "PopADView.h"
#import "AppDelegate.h"
#import "ShareVCtrl.h"
#import "DataHundel.h"
#import "WebVCtrl.h"
#import "RechargeVCtrl.h"
#import "LoginVCtrl.h"
#import "WeiPanMarketViewController.h"
#import "ChatVC.h"
#import "MarketModel.h"
#import "ChanceModel.h"
#import "SocketModel.h"
#import "NetworkRequests.h"
#import "AsSocket.h"
#import "HomeMarketList+CoreDataClass.h"
#define addCellCount 3

@interface HomeVCtrl ()

// 行情数据数组
@property (nonatomic,strong) NSMutableArray *list;
// 交易机会数据数组
@property (nonatomic,strong) NSMutableArray *chanceArray;
@property (nonatomic,strong) UIButton *rightBt;
@property (nonatomic,strong) PollADView *pollADView;
@property (nonatomic,strong) GainSectionView *gainSectionView;
@property (nonatomic,strong) QuotationScrollView *quotationScrollView;
@property (nonatomic,strong) UIButton *activityBtn;

@end

@implementation HomeVCtrl

- (instancetype)init {
    self = [super init];
    if (self) {
        self.pageSize = 20;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.list = [NSMutableArray array];
    // 获取存在本地的行情数据
//    self.list = [MarketModel mj_objectArrayWithKeyValuesArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"market"]];
    NSArray * arr = [HomeMarketList searchAll];
    self.list = [NSMutableArray arrayWithArray:arr];
    NSLog(@"行情数据本地缓存%@", self.list);
    self.chanceArray = [NSMutableArray array];
    // socket
    [[AsSocket shareDataAsSocket] startConnectSocket];
    // navigation
    [self createNavBar];
    // 添加通知
    [self addObserver];
    //客服
//    [self getServerConfig:NO];
//    [self setupRightBt];
    // 轮播图
    [self createPollAdView];
    // 新手学堂 & 盈利榜
    [self createGainSectionView];
    // UITableView初始化
    [self createTableViewWithHeaderAndFooter];
    self.tableView.backgroundColor = LTBgColor;
    // 开户按钮
    [self createActivityBtn];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self removeObserver];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    // 更新socket数据
    [self updatasocket];
//    [self loadData];

    [self.pollADView start];
    [self createQuotationScrollView];
    [self configActivityBtn];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [PopADView shut];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NFC_SocketUpdateQuotations object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NFC_SocketUpdateQuotationsFailure object:nil];
    
    [self.pollADView stop];
    
}



#pragma mark - 通知相关
// 添加通知
- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickRightBt) name:NFC_PushToChatVC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickQuotationBtn:) name:NFC_ClickQuotationBtn object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickSupportNewsCell:) name:NFC_SupportNewsCell object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout) name:NFC_LocLogout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:NFC_LocLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeIsUp:) name:NFC_HomeTimeIsUp object:nil];
    
}

// 移除通知
- (void)removeObserver {
    NFC_RemoveAllObserver;
}

#pragma mark - 网络请求
- (void)loadData {
    if (self.pageNo == kStartPageNum) {//下拉，加载所有
        //滚动图
        [self reqPollADList];
        // 获取行情
        [self requestList];
        // 获取交易机会
//        [self TradingChance];
    }else{
        // 获取交易机会
//        [self TradingChance];
    }
    
//    [self reqNewsList];//新闻公告
}

#pragma mark - 客服

- (void)setupRightBt {
    //隐藏
    if(!_rightBt) {
        _rightBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.header addSubview:_rightBt];
        [_rightBt setImage:[UIImage imageNamed:@"live_btn_service"] forState:UIControlStateNormal];
        
        [_rightBt addTarget:self action:@selector(clickRightBt) forControlEvents:UIControlEventTouchUpInside];
        [_rightBt mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.right.equalTo(@(-LTAutoW(5)));
             make.width.equalTo(@44);
             make.height.equalTo(@44);
             make.centerY.equalTo(@0);
         }];
    }
}
//客服按钮点击方法 初始方法
- (void)getServerConfig:(BOOL)bl {
//    BOOL canPushServer = bl;
    WS(ws);
    //获取客服信息
    [ws showLoadingWithMsg:nil];
    [RequestCenter reqServerInfo:^(LTResponse *res)
     {
         [ws hideLoadingView];
         if (res.success) {
             [LTUser saveCustomerInfo:res.resDict];
             if (bl) {
                 [ws pushToServer];
             }
         }
         else
         {
             NSString *msg = res.message?res.message :@"客服异常，请稍后再试";
             [self.view showTip:msg];
         }
     }];
}

- (void)clickRightBt {
    [self getServerConfig:YES];
}

#pragma mark - NavBar
- (void)createNavBar {
    [self navTitle:@""];
    
    UIImageView *titleIV = [[UIImageView alloc] init];
    UIImage *img = [UIImage imageNamed:@"homeTitle"];
    if (kChangeImageColor) {
        img = [img changeColor:NavBarTitleCoror];
    }
    titleIV.image = img;
    CGFloat temp = 0.7;
    CGFloat imgW = img.size.width*temp;
    CGFloat imgH = img.size.height*temp;
    titleIV.frame = CGRectMake((ScreenW_Lit - imgW)/2.0, (NavBarH_Lit - imgH)/2.0, imgW, imgH);
    [self.header addSubview:titleIV];
    
#if useNewYearTheme
    //特殊处理颜色
    self.stateView.backgroundColor = NavBarBgCoror0;
    [self.header changeBgImage];
#else
    
#endif
}

#pragma mark - 滚图
- (void)createPollAdView {
    if (!_pollADView) {
        self.pollADView = [[PollADView alloc] initWithFrame:CGRectMake(0, 0, self.w_, [PollADView viewH])];
        WS(ws);
        self.pollADView.clickPollADView = ^(PollADModel *mo){
            [ws clickPollImage:mo];
        };
    }
    
}

#pragma mark - 轮播图点击
- (void)clickPollImage:(PollADModel *)mo {
    NSString *title = mo.bannerDesc;
    NSString *temp = mo.link;
    
    if ([LTUtils isIxitScheme:temp]) {
        [self skipWithStr:temp];
    } else {
        NSString *http = @"http://";
        if (![temp hasPrefix:http]) {
            temp = [NSString stringWithFormat:@"%@%@", http, temp];
        }
        WebVCtrl *ctrl = [[WebVCtrl alloc] initWithTitle:title url:[temp toURL]];
        ctrl.shareHasWechatTimelineAndWechatSession = YES;
        [ctrl configBackType:BackType_Dismiss];
        [self presentVC:ctrl];
    }
}

#pragma mark -获取轮播数据
- (void)reqPollADList {
    WS(ws);
    NSString * url = [NSString stringWithFormat:@"%@%@",BaseUrl,@"/banner/getList"];
    NSDictionary * dic = @{@"pageSize":@"5"};
    [[NetworkRequests sharedInstance]POST:url dict:dic succeed:^(id data) {
        NSLog(@"data === %@",data);
        NSArray * list = [data objectForKey:@"data"][@"list"];
        if (list.count > 0) {
            NSArray *resArr = [PollADModel objsWithList:list];
            [ws.pollADView refDatas:resArr];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 新手学堂&盈利榜

- (void)createGainSectionView {
    if (!_gainSectionView) {
        self.gainSectionView = [[GainSectionView alloc] initWithFrame:CGRectMake(0, 0, self.w_, [GainSectionView viewH])];
        WS(ws);
   //     新手学堂
        _gainSectionView.clickNewComerBtn = ^{
            [ws pushWeb:@"http://help.moyacs.com/index.html" title:@"新手学堂"];
        };
    //    盈利榜
        _gainSectionView.clickGainBtn = ^{
            GainVCtrl *ctrl = [[GainVCtrl alloc] init];
            [ws pushVC:ctrl];
        };
    }
}

#pragma mark 交易机会网络请求wz
- (void)TradingChance{
    [self showLoadingView];
    NSString * url = [NSString stringWithFormat:@"%@%@",BasisUrl,@"/chance"];
//    int i = self.pageNo;
    NSDictionary * dic =@{@"size":@10,
                          @"page":@(self.pageNo)
                          };
    
    [[NetworkRequests sharedInstance]POST:url dict:dic succeed:^(id data) {
//        NSLog(@"交易机会请求%@",data);
        if ([[data objectForKey:@"code"]integerValue] == 0) {
            
            NSMutableArray * dataArr = [data objectForKey:@"dataObject"];
            if (dataArr.count == 0) {
                [self.view showTip:@"没有了,加载不出来了"];
            }else{
                if (self.pageNo == kStartPageNum && self.chanceArray.count > 0) {//下拉，加载所有
                    [self.chanceArray removeAllObjects];
                }
                
                for (NSDictionary * dic in [data objectForKey:@"dataObject"]) {
                    [self.chanceArray addObject:[ChanceModel mj_objectWithKeyValues:dic]];
                }
                
                [self.tableView reloadData];
            }
            
            [self endHeadOrFootRef];
            [self hideLoadingView];
            
        }
    } failure:^(NSError *error) {
        NSLog(@"交易机会请求网络错误%@",error);
        [self endHeadOrFootRef];
        [self hideLoadingView];
    }];
}

//排行榜接口
- (void)reqRateList {
//    WS(ws);
//    [RequestCenter reqGainList:kStartPageNum completion:^(LTResponse *res) {
//        if (res.success) {
//            NSArray *arr = [GainModel objsWithList:res.resArr];
//            if (arr.count > 0) {
//                GainModel *mo = arr[0];
//                [ws refGainView:mo];
//            }
//        }
//        [ws endHeadOrFootRef];
//    }];
}

- (void)refGainView:(GainModel *)mo {
//    NSString *todayYMD = [[NSDate date] chinaYMDString];
//    NSString *moYMD = mo.closeDate;
//    if ([todayYMD isEqualToString:moYMD]) {
//        [_gainSectionView refGainLab:mo.nickName profitRate:mo.profitRate];
//    } else {
//        [_gainSectionView refGainLab:nil profitRate:nil];
//    }
}

#pragma mark 行情

- (void)createQuotationScrollView {
    if (!_quotationScrollView) {
        WS(ws);
        self.quotationScrollView = [[QuotationScrollView alloc] initWithFrame:CGRectMake(0, 0, self.w_, [QuotationScrollView viewH])];
        [self.quotationScrollView refDatas:self.list];
        _quotationScrollView.homeRefreshHttpDatas = ^{
            [ws requestList];
        };
    }
}


- (void)clickQuotationBtn:(NSNotification *)obj {
    Quotation *item = obj.object;
    if ([item isKindOfClass:[Quotation class]]) {
        UMengEventWithParameter(page_home, @"QuotationThreeView_code", item.code);
        WeiPanMarketViewController *ctrl = [[WeiPanMarketViewController alloc] initWithCode:item.code exCode:item.excode title:[item productNamed]];
        [self pushVC:ctrl];
    } else {
        [self.view showTip:@"数据错误..."];
    }
}
#pragma mark - 获取行情列表
-(void)requestList
{
    NSString * url = [NSString stringWithFormat:@"%@%@",BasisUrl,@"/price/symbols"];
    NSDictionary * dic =@{@"server":@"DEMO"};
    [[NetworkRequests sharedInstance]GET:url dict:dic succeed:^(id data) {
        NSLog(@"data === %@",data);
        if ([[data objectForKey:@"code"]integerValue] == 0) {
            
            if (self.list.count > 0) {
                [self.list removeAllObjects];
            }
            
            for (NSDictionary * dic in [data objectForKey:@"dataObject"]) {
                MarketModel * model = [MarketModel mj_objectWithKeyValues:dic];
                [self.list addObject:model];
                
                // 先查询表里面是否有数据没有的话 执行添加数据库
                if ([HomeMarketList searchAll].count == 0) {
                    [HomeMarketList AddData:model];
                }else{
                    // 查找数据库里面是否有值
                    NSArray * arr = [HomeMarketList searchConditions:model];
                    // 如果没事执行添加, 如果有执行修改
                    if (arr.count == 0) {
                        [HomeMarketList AddData:model];
                    }else{
                        [HomeMarketList andkey:model];
                    }
                }
                
            }
            NSLog(@"list ==== %@",self.list);
              [self.quotationScrollView refDatas:self.list];
//            [DataHundel shareDataHundle].marketArrat =[NSMutableArray arrayWithArray:self.list];
//            [[NSUserDefaults standardUserDefaults] setObject:[data objectForKey:@"dataObject"] forKey:@"market"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 更新socket数据
-(void)updatasocket
{
    WS(ws);
    [[AsSocket shareDataAsSocket] setReturnValueBlock:^(NSMutableArray *socketArray) {
        [ws.quotationScrollView socketdata:socketArray];
//        NSLog(@"首页socket数据打印%@",socketArray);
    }];
}


#pragma mark 新闻、策略、公告
// 行情网络请求
- (void)reqNewsList {
    NSString * url = [NSString stringWithFormat:@"%@%@",BasisUrl,@"//chance"];
    NSDictionary * dic =@{@"size":@"20",@"page":@"1"};
    [[NetworkRequests sharedInstance]POST:url dict:dic succeed:^(id data) {
        NSArray * array =[data objectForKey:@"dataObject"];
        if (array.count > 0) {
            if (self.pageNo == kStartPageNum) {
                [self.list removeAllObjects];
            }
         //   [self configNewsDatas:array];
            [self.tableView reloadData];
        }

    } failure:^(NSError *error) {

    }];
}

- (void)configNewsDatas:(NSArray *)arr {
    NSMutableArray *mos = [NSMutableArray array];
    NewsModel *oldMO = nil;

    if (_list.count > 0) {
        [mos addObjectsFromArray:[_list lastObject]];
        [_list removeLastObject];
        if (mos.count > 0) {
            oldMO = mos[0];
        }
    }

    NSInteger i = 0;
    NSInteger arrCount = arr.count;

    for (NewsModel *mo in arr) {

        if (!oldMO) {
            [mos addObject:mo];
        } else {
            if ([[oldMO createTimeYMD] isEqualToString:[mo createTimeYMD]]) {
                [mos addObject:mo];

            } else {
                NSArray *temp = [NSArray arrayWithArray:mos];
                [_list addObject:temp];
                [mos removeAllObjects];

                [mos addObject:mo];
            }
        }
        oldMO = mo;

        i++;

        if (i == arrCount) {
            NSArray *temp = [NSArray arrayWithArray:mos];
            [_list addObject:temp];
            [mos removeAllObjects];
        }
    }
}

#pragma mark - 活动
// 开户活动按钮
- (void)createActivityBtn {
    CGFloat wh = 44;
    CGFloat btmMar = 44 + TabBarH_Lit;
    CGFloat rightMar = 16;
    self.activityBtn = [UIButton btnWithTarget:self action:@selector(activityBtnAction) frame:CGRectMake(ScreenW_Lit - rightMar - wh, ScreenH_Lit - btmMar - wh, wh, wh)];
    [_activityBtn setNorImageName:@"activity_openAccount"];
    [self.view addSubview:_activityBtn];
    [self configActivityBtn];
}
// 开户活动点击方法
- (void)activityBtnAction {
    if (![self checkLocHasLogin]) {
        return;
    }
    NSInteger state = UD_CardDistStatus;
    if (state == 0) {
        [self configActivityBtn];
        return;
    }
    if (state == 1 || state == 3) {//1：认证失败，，3：认证中
        [self pushCertResultVC];
    }
    else if (state == 2) {//2：资料未认证
        [self pushCertVC];
    }
}

- (void)configActivityBtn {
//    NSInteger state = UD_CardDistStatus;
//    BOOL hidden = (state == 4);
//    _activityBtn.hidden = hidden;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section >= addCellCount) {
        return self.chanceArray.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *identifier=@"HomeCell0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell addSubview:_pollADView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 1) {
        static NSString *identifier=@"HomeCell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell addSubview:_gainSectionView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    else if (indexPath.section == 2) {
        static NSString *identifier=@"HomeCell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell addSubview:_quotationScrollView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    else {

        static NSString *identifier=@"NewsCellFour";
        NewsCellFour *cell = (NewsCellFour *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[NewsCellFour alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        ChanceModel * model = self.chanceArray[indexPath.row];
        cell.chanceModel = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // 轮播图高度
        return [PollADView viewH];
    }
    else if (indexPath.section == 1) {
        // 新手学堂&盈利榜高度
        return [GainSectionView viewH];
    }
    else if (indexPath.section == 2) {
        // 行情高度
        return [QuotationScrollView viewH];
    }
    else {
        return 200;
    }
}

static CGFloat HeaderSectionH = 22;
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectZero;
    if (section < addCellCount) {
        return view;
    }

    // 加个判断更改头部高度
    CGFloat highly = 2;
    if (section == 3) {
        highly = 20.0;
        NSString * time = @"2016 -4-10";
        view.frame = CGRectMake(0, 0, self.w_, LTAutoW(HeaderSectionH));
        view.backgroundColor = LTBgColor;
        
        UILabel *lab = [[UILabel alloc] init];
        //LTAutoW(HeaderSectionH)
        lab.frame = CGRectMake(LTAutoW(kLeftMar), highly, 200,20);
        lab.font = autoFontSiz(12);
        lab.textColor = LTSubTitleColor;
        if (section == 3) {
            NSString *temp = @"交易机会";
            time = [NSString stringWithFormat:@"%@ %@", temp, @""];
            NSAttributedString *ABStr = [time ABStrColor:LTTitleColor font:autoBoldFontSiz(15) range:NSMakeRange(0, temp.length)];
            lab.attributedText = ABStr;
        } else {
            lab.text = time;
        }
        
        [view addSubview:lab];
        
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    // wz
    if (section == 0) {
        return 0;
    }else if (section == 1){
        return 0;
    }else if (section == 2){
        return 0;
    }else if (section == 3){
        return 47;
    }else{
        return 20;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 列表详情跳转
    NSInteger section = indexPath.section;
    if (section < addCellCount) {
        return;
    }
    NSInteger row = indexPath.row;
    section-=addCellCount;
    ChanceModel *mo = _chanceArray[row];
    /**
     先放百度链接
     */
    NSString *url = @"https://www.baidu.com";

    if (notemptyStr(url)) {
        WebVCtrl *ctrl = [[WebVCtrl alloc] initWithADTitle:@"百度" url:[url toURL]];
        [ctrl configBackType:BackType_Dismiss];
        [self presentVC:ctrl];
    }
}

#pragma mark  通知方法实现


- (void)timeIsUp:(NSNotification *)obj {
    NSIndexPath *ipath = obj.object;
    NSInteger section = ipath.section-addCellCount;
    NSInteger row = ipath.row;
    
    NSMutableArray *sectionArr = [NSMutableArray arrayWithArray:_list[section]];
    [sectionArr removeObjectAtIndex:row];
    
    if (sectionArr.count > 0) {
        [_list replaceObjectAtIndex:section withObject:sectionArr];
    } else {
        [_list removeObjectAtIndex:section];
    }
    [self.tableView reloadData];
}

- (void)userLogout {
    [self reqNewsList];
}
- (void)userLogin {
    [self reqNewsList];
}

#pragma mark - utils
- (void)skipWithStr:(NSString *)str {
    
    if ([LTUser hasLogin]) {
        if ([LTUtils schemeRegister:str]) {
            [self.view showTip:@"您已注册"];
        }
    };
    
    // 跳转到注册页面（已登录状态跳转到交易界面）
    if (![LTUser hasLogin] || [LTUtils schemeRegister:str]) {
        UMengEventWithParameter(page_home, @"loopImageView", @"register");
        LoginVCtrl *ctrl = [[LoginVCtrl alloc] init];
        [self pushVC:ctrl];
    }
    
    else {
        
        if ([LTUtils schemeCashin:str]) {// 充值界面
            UMengEventWithParameter(page_home, @"loopImageView", @"cashin");
            
            BOOL tokenTimeout = [self checkTimeOut];
            if (tokenTimeout) {
                return;
            }
            RechargeVCtrl *ctrl = [[RechargeVCtrl alloc] init];
            [ctrl configBackType:BackType_Dismiss];
            [self presentVC:ctrl];
        }
        
        else if ([LTUtils schemeTrade:str]) {// 交易界面
            UMengEventWithParameter(page_home, @"loopImageView", @"trade");
            [AppDelegate selectTabBarIndex:TabBarType_Deal];
        }
        
        else if ([LTUtils schemeShare:str]) {// 分享页面
            UMengEventWithParameter(page_home, @"loopImageView", @"share");
            ShareVCtrl *ctrl = [[ShareVCtrl alloc] initWithBackType:BackType_Dismiss];
            [self presentVC:ctrl];
        }
        
        //看行情界面
        else if ([LTUtils schemeMarket:str]) {
            [AppDelegate selectTabBarIndex:TabBarType_Market];
        }
        
        else if ([LTUtils schemeLiveList:str]) {
            UMengEventWithParameter(page_home, @"loopImageView", @"liveList");
            [self.view showTip:@"暂无直播"];
//            [AppDelegate selectTabBarIndex:TabBarType_Live];
        }
    }
}

@end
