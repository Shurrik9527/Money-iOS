//
//  MineVCtrl.m
//  Canary
//
//  Created by litong on 2017/5/8.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "MineVCtrl.h"
#import "MeHeaderView.h"
#import "MeSectionView.h"
#import "MeCell.h"
#import "MineMsgCenterVC.h"
#import "MeSettingVCtrl.h"
#import "AboutUsCtrl.h"
#import "ShareVCtrl.h"
#import "LTMaskTipView.h"
#import "TaskCenterVCtrl.h"
#import "FocusVC.h"
#import "CertificationVCtrl.h"
#import "CertificationResultVC.h"
#import "MeAssetsView.h"
#import "CashCouponVC.h"
#import "WebView.h"
#import "AuthVC.h"
#import "TopUpVC.h"

#define MeVCtrlDatas    @[\
                                                @[@"一分钟了解汇大师"],\
                                                @[@"关于我们"] \
                                         ]

@interface MineVCtrl ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL stateBarIsFornt;
}

@property (nonatomic,assign) BOOL formMineMsgCenter;
@property (nonatomic,assign) NSInteger unReadMsgCount;//未读消息
@property (nonatomic,strong) NSMutableArray *datas;
@property (nonatomic,strong) MeHeaderView *headView;
@property (nonatomic,strong) MeSectionView *sectionView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *stateBar;


@end

@implementation MineVCtrl

- (instancetype)init {
    self = [super init];
    if (self) {
        self.datas = [@[@"消息中心",@"推送设置",@"一分钟了解汇大师",@"版本检测",@"关于我们"] mutableCopy];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:NFC_LocLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:NFC_LocLogout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushAuthCtrl) name:NFC_PushAuthVC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushLoginCtrl) name:NFC_PushLoginVC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushAccountManagerVC) name:NFC_PushAccountManager object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:NFC_LocLogin object:nil];

    
    [self configstateBarColor];
    [self createHeadView];

//    [self createSectionView];
    [self createTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self sectionType];
    [self configDatas];
    [self.tableView setContentOffset:CGPointMake(0, 0)];
    [self stateBarToFront:NO];
    if ([LTUser hasLogin]) {
//        [self networkgGetMoney];
        [self.headView updateHeadImg];
        [self.headView updateNickName];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.headView animationBegin];
}

- (void)dealloc {
    NFC_RemoveAllObserver;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 通知
- (void)pushLoginCtrl {
    [self pushLocLogin];
}

- (void)pushAuthCtrl {
    AuthVC *vc = [[AuthVC alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushVC:vc];
}

#pragma mark - 请求

- (void)loadData {
    [self reqCardDistStatus:NO];
}

- (void)networkgGetMoney{
    NSString * url = [NSString stringWithFormat:@"%@%@",BaseUrl,@"/userAmount/get"];
    [[NetworkRequests sharedInstance] SWDPOST:url dict:nil succeed:^(id resonseObj, BOOL isSuccess, NSString *message) {
        NSLog(@"res == %@",resonseObj);
        if (isSuccess) {
            
        }else{
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}


//认证状态 1：认证失败，2：资料未认证，3：认证中，4：认证成功
- (void)reqCardDistStatus:(BOOL)needPush {
    NSInteger state = UD_CardDistStatus;
    if (state == 4) {
        return;
    }
    WS(ws);
    [self showLoadingView];
    [RequestCenter reqEXAuthStatus:^(LTResponse *res) {
        [ws hideLoadingView];
        if (res.success) {
            NSLog(@"reqCardDistStatus success ");
            NSInteger state = [res.resDict integerFoKey:@"status"];
            if (state != 0) {
                UD_SetCardDistStatus(state);
                [ws configSection];
                [ws.headView refViewWithLogin];
                [ws.tableView reloadData];
                if (needPush) {
                    if (state == 1 || state == 3) {//1：认证失败，，3：认证中
                        [self pushCertResultVC];
                    }
                    else if (state == 2) {//2：资料未认证
                        [self pushCertVC];
                    }
                }
            }
        }
    }];
}

#pragma mark 检查更新

- (void)checkUpdate:(NSIndexPath *)indexPath {
    [self.view showLoadingWithMsg:@"正在检检测"];
    WS(ws);
    [RequestCenter checkAppVersion:^(LTResponse *res) {
        [ws.view hideLoadingView];
        
        if (res.success) {
            NSDictionary *dict = [res.resDict copy];
            NSString *version = [dict stringFoKey:@"version"];
            NSString *content = [dict stringFoKey:@"content"];
            [UserDefaults setObject:version forKey:newestVersionKey];
            [LTAlertView alertAppUpdate:version content:content];
            [ws.tableView reloadData];
        } else {
            NSDictionary *dict = [res.rawDict copy];
            if (dict.count > 0) {
                NSString *code = [dict stringFoKey:@"errorCode"];
                if ([code isEqualToString:@"10012"]) {//已经是最新版本！
                    [ws.view showTip:res.message];
                } else {
                    [ws.view showTip:res.message];
                }
            } else {
                [ws.view showTip:@"网络不太通畅"];
            }
        }
    }];
}


#pragma mark - StateBar

- (void)configstateBarColor {
    UIColor *color = useNewYearTheme ? NavBarBgCoror0 : NavBarBgCoror ;
    self.stateBar = [[UIView alloc] init] ;
    _stateBar.frame = CGRectMake(0, 0, ScreenW_Lit, 20);
    _stateBar.backgroundColor = color;
    [self.view addSubview:_stateBar];
}
- (void)stateBarToFront:(BOOL)bl {
    if (bl) {
        [self.view bringSubviewToFront:_stateBar];
        stateBarIsFornt = YES;
    } else {
        [self.view bringSubviewToFront:_tableView];
        stateBarIsFornt = NO;
    }
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat y = scrollView.contentOffset.y;
//    if (y > 40) {//状态栏往上
  //      if (!stateBarIsFornt) {//状态栏在下层
            [self stateBarToFront:YES];//状态栏移动到上层
//        }
//    } else {//状态栏往下
//        if (stateBarIsFornt) {//状态栏在上层
//            [self stateBarToFront:NO];//状态栏移动到下层
//        }
//    }
}


#pragma mark - Head

- (void)createHeadView {
    CGRect r = CGRectMake(0, 0, ScreenW_Lit, LTAutoW(kMeHeaderViewH1));
    self.headView = [[MeHeaderView alloc] initWithFrame:r];
}

#pragma mark - Section

- (void)createSectionView {
    WS(ws);
    CGRect r = CGRectMake(0, 0, ScreenW_Lit, LTAutoW(kMeSectionViewH));
    self.sectionView = [[MeSectionView alloc] initWithFrame:r];
    _sectionView.meSectionBlock = ^(NSInteger idx) {
        [ws sectonAction:idx];
    };
    [self configSection];
}

- (MeSectionType)sectionType {
    MeSectionType type = MeSectionType_Logout;
    if (![LTUser hasLogin]) {
        type = MeSectionType_Logout;
    }
    else {
        type = MeSectionType_Authed;
 
//        //认证状态 1：认证失败，2：资料未认证，3：认证中，4：认证成功
//        NSInteger state = UD_CardDistStatus;
//        if (state == 0) {
//            type = MeSectionType_Logout;
//        }
//        else if (state == 4) {
//            type = MeSectionType_Authed;
//        }
//        else {
//            type = MeSectionType_NotAuth;
//        }
    }
    return type;
}

- (void)configSection {
    MeSectionType type = [self sectionType];
    [_sectionView configType:type];
}

- (void)loginSuccess {
    [self loadData];
    [self configSection];
    [self.headView refViewWithLogin];
    [_tableView reloadData];
}

- (void)logout {
    [_sectionView configType:MeSectionType_Logout];
    [self.headView refViewWithLogin];
    [_tableView reloadData];
}

//积分商城 、在线客服 、账号管理
- (void)sectonAction:(NSInteger)idx {
    MeSectionType type = [self sectionType];
    if (type == MeSectionType_Logout || type == MeSectionType_NotAuth) {
        if (idx == 0) {//开通账号
            [self pushCertificationVC];
        } else if (idx == 1) {//在线客服
            [self pushToCustomer];
        } else if (idx == 2) {//账号管理
            [self pushAccountManagerVC];
        }
    }
    else {
        if (idx == 0) {//在线客服
            [self pushToCustomer];
        } else if (idx == 1) {//账号管理
            [self pushAccountManagerVC];
        }
    }

}


//客服
- (void)pushToCustomer {
    if (![LTUser hasLogin]) {
        [self checkLocHasLogin:@"请先登录"];
        return;
    }
    
    WS(ws);
    //获取客服信息
    [ws showLoadingWithMsg:nil];
    [RequestCenter reqServerInfo:^(LTResponse *res)
     {
         [ws hideLoadingView];
         if (res.success) {
             [LTUser saveCustomerInfo:res.resDict];
             [ws pushToServer];
         }
         else
         {
             NSString *msg = res.message?res.message :@"客服异常，请稍后再试";
             [LTAlertView alertMessage:msg];
         }
     }];
}

//账号管理
- (void)pushAccountManagerVC {
    UMengEvent(page_UserSetting);
    if ([LTUser hasLogin]) {
        
        UMengEvent(UM_My_Setting);
        
        MeSettingVCtrl *ctrl = [[MeSettingVCtrl alloc] init];
        [self pushVC:ctrl];
    } else {
        
        [self pushLoginCtrl];
    }
}
//开通账号
- (void)pushCertificationVC {
    if (![LTUser hasLogin]) {
        [self pushLocLogin];
        return;
    }
    
    
    //认证状态 ，
    NSInteger state = UD_CardDistStatus;
    if (state == 0) {//本地没有数据
        [self reqCardDistStatus:YES];
    }
    else if (state == 1 || state == 3) {//1：认证失败，，3：认证中
        [self pushCertResultVC];
    }
    else if (state == 2) {//2：资料未认证
        [self pushCertVC];
    }
}

//任务中心
- (void)pushTaskCenterVC {
    if (![LTUser hasLogin]) {
        [self checkLocHasLogin:@"登录后可以查看任务中心"];
        return;
    }
    
    UMengEvent(UM_My_TaskCenter);
    
    TaskCenterVCtrl *ctrl = [[TaskCenterVCtrl alloc] init];
    [self pushVC:ctrl];
    
}
//关注列表
- (void)pushFocusVC {
    if (![LTUser hasLogin]) {
        [self checkLocHasLogin:@"登录后可以查看关注列表"];
        return;
    }
    
    UMengEvent(UM_My_TaskCenter);
    
    FocusVC *ctrl = [[FocusVC alloc] init];
    [self pushVC:ctrl];
}


//充值
- (void)pushChongZhi {
    if (![LTUser hasLogin]) {
        [self checkLocHasLogin:@"登录后可以充值"];
        return;
    }

    TopUpVC * webView =[[TopUpVC alloc]init];
    [self.navigationController pushVC:webView];
}

//代金券
- (void)pushCashCoupon {
    
    if (![LTUser hasLogin]) {
        [self checkLocHasLogin:@"登录后可以查看代金券"];
        return;
    }
    
    CashCouponVC *ctrl = [[CashCouponVC alloc] init];
    [self pushVC:ctrl];
}

//盈亏
- (void)pushYingkui {
    
    if (![LTUser hasLogin]) {
        [self checkLocHasLogin:@"登录后可以查看盈亏"];
        return;
    }
    
    [AppDelegate selectTabBarIndex:TabBarType_Deal];

}



#pragma mark - Table

- (void)createTableView {
    CGRect rect = CGRectMake(0, 0, self.w_, self.h_ - TabBarH_Lit);
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = LTBgRGB;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MeAssetsView" bundle:nil] forCellReuseIdentifier:NSStringFromClass([MeAssetsView class])];
    
    UIView *foot = [[UIView alloc] init];
    foot.frame = CGRectMake(0, 0, self.w_, 60);
    self.tableView.tableFooterView = foot;
    self.tableView.bounces = NO;
}


// 审核 隐藏
- (void)configDatas {
    [self.datas removeAllObjects];
//    self.datas = [NSMutableArray arrayWithArray:MeVCtrlDatas];
    self.datas = [@[@"消息中心",@"一分钟了解汇大师",@"版本检测",@"关于我们"] mutableCopy];
}

- (void)setUnReadMsgCount:(NSInteger)unReadMsgCount {
    _unReadMsgCount = unReadMsgCount;
    UD_SetUnReadMessageCount(_unReadMsgCount);
    [_tableView reloadData];
}


#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section < 2) {
        return 1;
    }

    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *identifier=@"MeCell0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell addSubview:_headView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    else if (indexPath.section == 1) {
        MeAssetsView *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MeAssetsView class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        WS(ws)
        cell.selectActionBlock = ^(NSInteger index) {
            if (index == 0) {
                [ws pushCashCoupon];
            }else if (index == 1){
                [ws pushYingkui];
            }else if (index == 2){
                [ws pushChongZhi];
            }
            
        };
        return cell;
    }
    
//    else if (indexPath.section == 2) {
//        static NSString *identifier=@"MeCell1";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        }
//        [cell addSubview:_sectionView];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    }
    
    static NSString *identifier=@"MeCell";
    MeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSInteger row = indexPath.row;
    
    NSString *data = _datas[row];
    [cell bindData:data];
    
    return cell;
}

#pragma mark UITableViewDelegate

static CGFloat HeaderSectionH = 8;
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return nil;
    }
    
    UIView *header = [UIView lineFrame:CGRectMake(0, 0, ScreenW_Lit, LTAutoW(HeaderSectionH)) color:LTColorHex(0xF0F2F5)];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 0;
    }
    return LTAutoW(HeaderSectionH);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 0) {
        CGFloat h = [LTUser hasLogin] ? LTAutoW(kMeHeaderViewH) : LTAutoW(kMeHeaderViewH1);
        return  h;
    }
    
    else if (section == 1) {
//        return [LTUser hasLogin] ? 140 : 0;
        return  0;
    }
    
//    else if (section == 2) {
//        return LTAutoW(kMeSectionViewH);
//    }
    
    return LTAutoW(kMeCellH);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section < 2) {
        return;
    }
    
    NSInteger row = indexPath.row;
    
    NSString *txt = _datas[row];
    
    UMengEventWithParameter(page_me, @"name", txt);
    
    if ([txt isEqualToString:@"一分钟了解汇大师"]) {
        [self pushWeb:@"http://www.zhangstz.com/xsxt/zh-CN/index.html" title:txt];
        return;
    }
    if ([txt isEqualToString:@"常见问题"]) {
        [self pushWeb:URL_CommonQA title:txt];
        return;
    }
    
    
    
    if ([txt isEqualToString:@"消息中心"]) {
        if (![LTUser hasLogin]) {
            LoginVCtrl *ctrl = [[LoginVCtrl alloc] init];
            [self pushVC:ctrl];
            return;
        }
        WS(ws);
        MineMsgCenterVC *ctrl = [[MineMsgCenterVC alloc]init];
        [ctrl setAllMessageReadedBlock:^{
            ws.formMineMsgCenter = YES;
        }];
        [self pushVC:ctrl];
        return;
    }
    
    if ([txt isEqualToString:@"版本检测"]) {
        [self checkUpdate:indexPath];
        return;
    }
    
    if ([txt isEqualToString:@"分享领代金券"]) {
        NSString *userid = UD_UserId;
        if (userid.integerValue<=0) {
            LoginVCtrl *ctrl = [[LoginVCtrl alloc] init];
            [self pushVC:ctrl];
        } else {
            ShareVCtrl *ctrl = [[ShareVCtrl alloc] init];
            [self pushVC:ctrl];
        }
        return;
    }
    
    
    
    if ([txt isEqualToString:@"关于我们"]) {
        NSURL *url=[NSURL URLWithString:@"http://www.zhangstz.com/aboutus/aboutus-zh-CN.html"];
       WebVCtrl *ctrl = [[WebVCtrl alloc]initWithTitle:@"关于我们" url:url returnType:BackType_PopVC];
        [self pushVC:ctrl];
        return;
    }
    if ([txt isEqualToString:@"版本检测"]) {
        
        return;
    }
    
}





@end
