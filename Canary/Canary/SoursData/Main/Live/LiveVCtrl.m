//
//  LiveVCtrl.m
//  Canary
//
//  Created by litong on 2017/5/8.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "LiveVCtrl.h"
#import "LiveCoCell.h"
#import "LiveDetailVCtrl.h"
#import "PollADModel.h"
#import "PollADView.h"
#import "WebVCtrl.h"
#import "AppDelegate.h"
#import "ShareVCtrl.h"

#define kCollectionViewHeadId   @"kCollectionViewHeadId"
#define kCollectionViewCellId   @"kCollectionViewCellId"

@interface LiveVCtrl ()
{
    UIButton *rightBt;
}
@property(strong,nonatomic)NSMutableArray * liveList;
@property(strong,nonatomic)NSMutableArray * bannerList;
@property (nonatomic,strong) PollADView *pollADView;

@end

@implementation LiveVCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navTitle:@"直播"];
    
    self.liveList = [[NSMutableArray alloc] init];
    self.bannerList = [[NSMutableArray alloc] init];
    
#if useNewYearTheme
    //特殊处理颜色
    UIColor *color = NavBarBgCoror0;
    [self.header changeBgImage];
    self.header.titler.textColor = LTWhiteColor;
    self.stateView.backgroundColor = color;
#else
    
#endif
    
    [self setupRightBt];
    
    [self createPollAdView];
    
    
    CGFloat itemw = LTAutoW(163);
    CGFloat lineSpacing = LTAutoW(20);
    CGFloat itemh = itemw + LTAutoW(11+15);
    CGFloat itemmid = LTAutoW(17);
    CGFloat lrMar = (ScreenW_Lit - 2*itemw - itemmid)*0.5;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.minimumInteritemSpacing = itemmid;
    layout.minimumLineSpacing = lineSpacing;
    layout.itemSize = CGSizeMake(itemw, itemh);
    layout.sectionInset = UIEdgeInsetsMake(LTAutoW(12), lrMar, LTAutoW(12), lrMar);
    [self createCollectionViewWithHeader:layout];
    [self.collectionView registerClass:[LiveCoCell class] forCellWithReuseIdentifier:kCollectionViewCellId];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionViewHeadId];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.pollADView stop];
    
}


#pragma mark - action

- (void)loadData {
    
    [self reqLiveList];
//    [self reqBannerList];
}

- (void)reqLiveList {
    WS(ws);
    [RequestCenter requestLiveList:^(LTResponse *res) {
        if (res.success) {
            NSArray *list = [LiveMO objsWithList:res.resArr];
            if (list.count > 0) {
                [ws.liveList removeAllObjects];
                [ws.liveList addObjectsFromArray:list];
                [ws.collectionView reloadData];
            }
        } else {
            [ws.collectionView showTip:res.message];
        }
        [ws endHeadOrFootRef];
    }];
}

- (void)reqBannerList {
    WS(ws);
    [RequestCenter reqBannerList:2 finish:^(LTResponse *res) {
        if (res.success) {
            NSArray *list = [res.resArr copy];
            if (list.count > 0) {
                NSArray *resArr = [PollADModel objsWithList:list];
                [ws.pollADView refDatas:resArr];
                [ws.bannerList removeAllObjects];
                [ws.bannerList addObjectsFromArray:resArr];
                
                [ws.collectionView reloadData];
            }
        } else {
            [ws.collectionView showTip:res.message];
        }
        [ws endHeadOrFootRef];
    }];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _liveList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LiveCoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellId forIndexPath:indexPath];
    
    NSInteger row = indexPath.row;
    LiveMO *mo = _liveList[row];
    [cell bindData:mo];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (_bannerList.count > 0) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kCollectionViewHeadId forIndexPath:indexPath];
            if (headerView == nil) {
                headerView = [[UICollectionReusableView alloc] init];
            } else {
                [headerView removeAllSubView];
            }
            [headerView addSubview:_pollADView];
            return headerView;
        }
        return nil;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    BOOL locHasLogin = [self checkLocHasLogin:@"登录观看直播"];
    if (!locHasLogin) {
        return;
    }
    
    NFC_PostName(NFC_FloatingPlayRemove);
    
    
    LiveMO *model = self.liveList[indexPath.row];
    
    UMengEventWithParameter(page_chatRoom, @"live_list_index",model.channelId);
    
    LiveDetailVCtrl *ctrl = [[LiveDetailVCtrl alloc] init];
    if(!NoTestLive){
        //测试聊天室
        model.chatRoomId=TestLiveRoomId;
    }
    ctrl.liveModel = model;
    [self pushVC:ctrl];
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGFloat h = (_bannerList.count > 0) ? LTAutoW(130) : 0;
    return CGSizeMake(ScreenW_Lit, h);
}



#pragma mark - banner

- (void)createPollAdView {
    if (!_pollADView) {
        self.pollADView = [[PollADView alloc] initWithFrame:CGRectMake(0, 0, self.w_, [PollADView viewH])];
        WS(ws);
        self.pollADView.clickPollADView = ^(PollADModel *mo){
            [ws clickPollImage:mo];
        };
    }
    
}


- (void)clickPollImage:(PollADModel *)mo {
    NSString *title = mo.desc;
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
        [self presentVC:ctrl];
    }
}

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
        
    } else {
        
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



#pragma mark - 客服

- (void)setupRightBt {
    //隐藏
    if(!rightBt) {
        rightBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.header addSubview:rightBt];
        [rightBt setImage:[UIImage imageNamed:@"live_btn_service"] forState:UIControlStateNormal];
        
        [rightBt addTarget:self action:@selector(clickRightBt) forControlEvents:UIControlEventTouchUpInside];
        [rightBt mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.right.equalTo(@(-LTAutoW(5)));
             make.width.equalTo(@44);
             make.height.equalTo(@44);
             make.centerY.equalTo(@0);
         }];
    }
}

- (void)clickRightBt
{
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

@end
