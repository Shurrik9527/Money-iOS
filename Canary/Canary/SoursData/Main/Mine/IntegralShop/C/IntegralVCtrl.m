//
//  integralVC.h
//  ixit
//
//  Created by Brain on 2016/12/12.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "IntegralVCtrl.h"
#import "ShopHeadView.h"
#import "GiftChangeVCtrl.h"
#import "GiftDetailsVCtrl.h"
#import "GiftExchangeView.h"
#import "GiftCell.h"
#import "ActivityGiftCell.h"
#import "ActivityListGiftMO.h"
#import "PrivilegedCardInfoVCtrl.h"
#import "GiftCountDownView.h"
#import "UITableView+LT.h"

@interface IntegralVCtrl ()

@property (nonatomic,strong) NSMutableArray *list;
@property (nonatomic,strong) NSMutableArray *actList;
@property (nonatomic,strong) NSMutableArray *quanList;

@property (nonatomic,strong) ShopHeadView *shopHeadView;
@property (nonatomic,strong) GiftExchangeView *popView;
@property (nonatomic,strong) UILabel * noteLab;

@property (nonatomic,strong) InviteFriendsInfo *inviteFriendsInfo;

@end

@implementation IntegralVCtrl
#define NoteH      30.0
#define NoteMsg @"更多实物兑换正在陆续添加中，敬请关注！"
- (instancetype)init {
    self = [super init];
    if (self) {
        self.list = [NSMutableArray array];
        self.quanList = [NSMutableArray array];
        self.actList = [NSMutableArray array];
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exchangeGift:) name:NFC_ExchangeGift object:nil];
    NFC_AddObserver(NFC_ExchangeGift, @selector(exchangeGift:));
    NFC_AddObserver(NFC_GiftTimeIsUp, @selector(loadData));
    
    [self navTitle:@"积分商城" backType:BackType_PopVC rightTitle:@"积分规则" ];
    
    [self createTableViewWithHeader];
    
    CGRect rect = CGRectMake(0, NavBarTop_Lit, ScreenW_Lit, ScreenH_Lit - NavBarTop_Lit);
    self.tableView.frame = rect;
    self.tableView.backgroundColor = LTWhiteColor;
    [self.tableView registerClass:[GiftCell class]];
    [self.tableView registerClass:[ActivityGiftCell class]];
    self.tableView.tableHeaderView = self.shopHeadView;
    [self refShopHeadView];
    [self createPopView];
    [self createNoteView];
    [self loadData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!_mo) {
        [self reqUserPoint];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NFC_ExchangeGift object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action

- (void)refShopHeadView {
    [self.shopHeadView refView:_mo];
}

//用户积分&经验
- (void)reqUserPoint {
//    WS(ws);
//    [RequestCenter reqUserPoint:[IntegralMo vipLvVer] finish:^(LTResponse *res) {
//        if (res.success) {
//            IntegralMo *mo = [IntegralMo objWithDict:res.resDict];
//            ws.mo = mo;
//            [ws.shopHeadView refView:mo];
//        }
//    }];
}

//右按钮
- (void)rightBarAction{
    UMengEvent(UM_My_IM_Rules);
    [self pushWeb:URL_UserPointRule title:@"商城规则"];
}

#pragma mark - 父类重写
//下拉上提刷新调用
- (void)loadData {
    [self reqUserPoint];
    [self reqGiftList];
}

- (void)returnBack {
    if (self.backType > 0) {
        if (self.backType == BackType_PopToRoot) {
            [self popToRootVC];
        }
        else if (self.backType == BackType_Dismiss) {
            [self dismissVC];
        }
        else {
            [self.navigationController popVC];
        }
    } else {
        [self.navigationController popVC];
    }
}

#pragma mark - 通知

#pragma mark 马上兑换
- (void)exchangeGift:(NSNotification *)obj {
    NSDictionary *dict = obj.object;
    GiftMOType typ = (GiftMOType)[dict integerFoKey:GiftCellMoTypeKey];
    GiftMO *mo = [dict objectForKey:GiftCellMoKey];
//    NSIndexPath *iPath = [dict objectForKey:GiftCellIndexPathKey];
//    NSInteger section = iPath.section;
//    NSInteger row = iPath.row;
    
    if (typ == GiftMOType_quan) {
        _popView.mo = mo;
        _popView.integralMo = _mo;
        
        [_popView showView:YES];
    } else if (typ == GiftMOType_PrivilegedCard) {
        NSString *endTime = [dict objectForKey:GiftEndTimeKey];
        PrivilegedCardInfoVCtrl *ctrl = [[PrivilegedCardInfoVCtrl alloc] init];
        ctrl.endTime=endTime;
        ctrl.mo = mo;
        ctrl.Integralmo = self.mo;
        WS(ws);
        ctrl.giftListRefBlock = ^{
            [ws loadData];
        };
        [self pushVC:ctrl];
    }
}

#pragma mark - request

- (void)reqGiftList {
//    WS(ws);
//    [RequestCenter reqUserGiftList:^(LTResponse *res) {
//        if (res.success) {
//            [ws endHeadOrFootRef];
//            [ws.list removeAllObjects];
//            [ws configResdict:res.resDict];
//        } else {
//            [LTAlertView alertMessage:res.message];
//        }
//    }];
}

- (void)reqGiftChange:(GiftMO *)giftMO num:(NSInteger)num {
//    NSString *gid = giftMO.giftId;
//    
//    __block NSInteger exchangeTyp = giftMO.excode;
//    __block NSString *giftName = giftMO.giftName;
//    WS(ws);
//    [self showLoadingView];
//    [RequestCenter reqUserGiftChange:gid giftNum:num versionNo:[IntegralMo vipLvVer] finish:^(LTResponse *res) {
//        [ws hideLoadingView];
//        if (res.success) {
//            IntegralMo *mo = [IntegralMo objWithDict:res.resDict];
//            ws.mo = mo;
//            [ws.shopHeadView refView:mo];
//            
//            NSString *exName = EXchangeNameList[exchangeTyp];
//            NSString *UMKey = [NSString stringWithFormat:@"兑换%@券",exName];
//            UMengEventWithParameter(UM_My_IM_ExchangeQuan, UMKey, giftName);
//            
//            [LTAlertView alertSuccessMsg:@"兑换成功" sureTitle:@"继续兑换" sureAction:^{} cancelTitle:@"查看代金券" cancelAction:^{
//                [ws pushCouponListVC];
//            }];
//        } else {
//            [LTAlertView alertMessage:res.message];
//        }
//    }];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id obj = _list[section];
    if ([obj isKindOfClass:[ActivityListGiftMO class]]) {
        ActivityListGiftMO *mo = (ActivityListGiftMO *)obj;
        return  mo.giftList.count;
    }
    else if ([obj isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)obj;
        return arr.count;
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    id obj = _list[section];
    if ([obj isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)obj;
        
        NSString *identifier = [UITableView cellReuseIdentifier:[GiftCell class]];
        GiftCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        GiftMO *mo = arr[row];
        [cell bindData:mo indexPath:indexPath];
        
        return cell;
        
    }
    else if ([obj isKindOfClass:[ActivityListGiftMO class]]) {
        
        ActivityListGiftMO *item = (ActivityListGiftMO *)obj;
        NSArray *arr = item.giftList_fmt;
        
        NSString *identifier = [UITableView cellReuseIdentifier:[ActivityGiftCell class]];
        ActivityGiftCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        GiftMO *mo = arr[row];
        [cell bindData:mo indexPath:indexPath];
        
        return cell;
        
    }
    else {
        return nil;
    }

}

#pragma mark - UITableViewDelegate

static CGFloat kGiftCellHeadH = 32;
static CGFloat kActivityGiftCellHeadH = 56;

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    id obj = _list[section];
    if ([obj isKindOfClass:[ActivityListGiftMO class]]) {
        ActivityListGiftMO *mo = (ActivityListGiftMO *)obj;
        UIView *view = [self activityGiftCellHeadView:mo section:section];
        return view;
    }
    
    else if ([obj isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)obj;
        if (arr.count > 0) {
            GiftMO *mo = arr[0];
            UIView *view = [self giftCellHeadView:mo];
            return view;
        }
    }
    
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    id obj = _list[section];
    if ([obj isKindOfClass:[ActivityListGiftMO class]]) {
        return LTAutoW(kActivityGiftCellHeadH);
    }
    else if ([obj isKindOfClass:[NSArray class]]) {
        return LTAutoW(kGiftCellHeadH);
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    id obj = _list[section];
    if ([obj isKindOfClass:[ActivityListGiftMO class]]) {
        return kActivityGiftCellH;
    }
    else if ([obj isKindOfClass:[NSArray class]]) {
        return kGiftCellH;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    id obj = _list[section];
    if ([obj isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)obj;
        GiftMO *mo = arr[row];
        NSDictionary *dict = @{
                               GiftCellMoTypeKey : @(GiftMOType_quan),
                               GiftCellMoKey:mo,
                               GiftCellIndexPathKey:indexPath
                               };
        [[NSNotificationCenter defaultCenter] postNotificationName:NFC_ExchangeGift object:dict];
        
    }
    else if ([obj isKindOfClass:[ActivityListGiftMO class]]) {
        
        ActivityListGiftMO *item = (ActivityListGiftMO *)obj;
        NSArray *arr = item.giftList_fmt;
        GiftMO *mo = arr[row];
        NSString *endTime = item.actEndTime;
        NSDictionary *dict = @{
                               GiftCellMoTypeKey : @(GiftMOType_PrivilegedCard),
                               GiftCellMoKey : mo,
                               GiftCellIndexPathKey : indexPath,
                               GiftEndTimeKey : endTime
                               };
        [[NSNotificationCenter defaultCenter] postNotificationName:NFC_ExchangeGift object:dict];
    }
    else {
        
    }
    
    
}


#pragma mark - utils

- (GiftMO *)objWithIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSArray *arr = _list[section];
    GiftMO *mo = arr[row];
    return mo;
}





- (UIView *)giftCellHeadView:(GiftMO *)mo {
    CGRect rect = CGRectMake(0, 0, self.w_, LTAutoW(kGiftCellHeadH));
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = LTWhiteColor;
    
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(LTAutoW(kLeftMar), 0, 200, LTAutoW(kGiftCellHeadH));
    lab.font = autoFontSiz(12);
    lab.textColor = LTSubTitleColor;
//    lab.text = EXchangeNameList[mo.excode];
    [view addSubview:lab];
    
    UIView *lineView = [[UIView alloc] init] ;
    lineView.frame = CGRectMake(0, LTAutoW(kGiftCellHeadH)-0.5, ScreenW_Lit, 0.5);
    lineView.backgroundColor = LTLineColor;
    [view addSubview:lineView];
    
    return view;
}



- (UIView *)activityGiftCellHeadView:(ActivityListGiftMO *)mo section:(NSInteger)section {
    CGRect rect = CGRectMake(0, 0, self.w_, LTAutoW(kActivityGiftCellHeadH));
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = LTWhiteColor;
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = LTRectAutoW(16, 10.5, 200, 15);
    lab.text = mo.actTitle;
    lab.font = autoFontSiz(15);
    lab.textColor = LTTitleColor;
    [view addSubview:lab];
    
    UILabel *subLab = [[UILabel alloc] init];
    subLab.frame = CGRectMake(lab.x_, lab.yh_ + LTAutoW(6), lab.w_, LTAutoW(16.5));
    subLab.text = mo.actDesc;
    subLab.font = autoFontSiz(12);
    subLab.textColor = LTSubTitleColor;
    [view addSubview:subLab];
    
    CGFloat countDownViewW = kGiftCountDownLabW *3 + kGiftCountDownMar*2;
    GiftCountDownView *countDownView = [self createCountDownView:section];
    countDownView.frame = CGRectMake(ScreenW_Lit - LTAutoW(16) - countDownViewW, LTAutoW(12), countDownViewW, kGiftCountDownH);
    [view addSubview:countDownView];
    [countDownView refTimeInterval:[mo.actEndTime doubleValue]];
    return view;
}

- (GiftCountDownView *)createCountDownView:(NSInteger)section {
    GiftCountDownView *countDownView = [[GiftCountDownView alloc] init];
    countDownView.section = section;
    return countDownView;
}

- (void)pushCouponListVC {
    
//    WS(ws);
//    BOOL bl = [self checkExTimeout:_exType success:^{
//        [LTAlertView alertSuccessMsg:@"兑换成功" sureTitle:@"继续兑换" sureAction:^{} cancelTitle:@"查看代金券" cancelAction:^{
//            [ws pushCouponListVC];
//        }];
//    }];
//    if (bl) {
//        WQCouponListVC *ctrl=[[WQCouponListVC alloc]init];
//        ctrl.exType = _exType;
//        [self pushVC:ctrl];
//    }
}

-(UILabel *)createLabWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font{
    UILabel *label=[[UILabel alloc]init];
    label.frame=frame;
    label.backgroundColor=[UIColor whiteColor];
    label.text=text;
    label.textAlignment=NSTextAlignmentCenter;
    label.numberOfLines=0;
    label.textColor=LTSubTitleColor;
    label.font=font;
    return label;
}


#pragma mark - 兑换

- (void)createPopView {
    self.popView = [[GiftExchangeView alloc] initWithFrame:CGRectMake(0, NavBarTop_Lit, ScreenW_Lit, ScreenH_Lit - NavBarTop_Lit)];
    [self.view addSubview:_popView];
    
//    WS(ws);
//    _popView.giftExchangeBlock = ^(GiftMO *mo,NSInteger num) {
//        ws.exType = mo.excode;
//        [ws reqGiftChange:mo num:num];
//    };
//    _popView.giftExShowTipBlock = ^(NSString *tip) {
//        [ws.view showTip:tip];
//    };
}
-(void)createNoteView{
    
    _noteLab=[self createLabWithFrame:CGRectMake(0, ScreenH_Lit - NoteH, ScreenW_Lit, NoteH) text:NoteMsg font:autoFontSiz(12)];
    self.tableView.tableFooterView=_noteLab;
}
#pragma mark 兑换历史&查看明细 | banner

- (ShopHeadView *)shopHeadView {
    if (!_shopHeadView) {
        WS(ws);
        ShopHeadView *shopView = [[ShopHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenW_Lit, LTAutoW(ShopHeadViewH))];
        shopView.myExchangeHistoryBlock = ^{
            UMengEvent(UM_My_IM_ExchangeHistory);
            GiftChangeVCtrl *ctrl = [[GiftChangeVCtrl alloc] init];
            ctrl.mo = ws.mo;
            [ws pushVC:ctrl];
        };
        shopView.lookIntegralDetailsBlock = ^{
            UMengEvent(UM_My_IM_CheckDetails);
            GiftDetailsVCtrl *ctrl = [[GiftDetailsVCtrl alloc] init];
            [ws pushVC:ctrl];
        };
        shopView.lookBannerDetailsBlock = ^(InviteFriendsInfo *inviteFriendsInfo){
            UMengEventWithParameter(UM_My_IM_Banner, @"积分商城Banner", inviteFriendsInfo.title);
            [ws presentWeb:inviteFriendsInfo.link title:inviteFriendsInfo.linkTitle];
        };
        _shopHeadView = shopView;
    }
    
    
    return _shopHeadView;
}


- (void)addBanner {
    BOOL canShow = _inviteFriendsInfo.status;
    if (canShow && [LTUtils noHide]) {
        [_shopHeadView addBanner:_inviteFriendsInfo];
        self.tableView.tableHeaderView = self.shopHeadView;
        [self.tableView reloadData];
    }
}

#pragma mark 数据配置

- (void)configResdict:(NSDictionary *)dict {
    NSArray *activityList0 = [dict arrayFoKey:@"activityList"];
    [self.actList removeAllObjects];
    [self.actList addObjectsFromArray:[ActivityListGiftMO objsWithList:activityList0]];
    
    NSArray *voucherList0 = [dict arrayFoKey:@"voucherList"];
    if (voucherList0.count > 0) {
        
        NSArray *voucherList = [GiftMO objsWithList:voucherList0];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        for (GiftMO *mo in voucherList) {
            NSString *exStr = [NSString stringWithInteger:mo.excode];
            if ([dic.allKeys containsObject:exStr]) {
                NSArray *oldArr = [dic objectForKey:exStr];
                NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:oldArr];
                [tmpArr addObject:mo];
                [dic setObject:tmpArr forKey:exStr];
            } else {
                NSMutableArray *tmpArr = [NSMutableArray array];
                [tmpArr addObject:mo];
                [dic setObject:tmpArr forKey:exStr];
            }
        }
        
        [_quanList removeAllObjects];
        NSArray *dicValues = [dic allValues];
        for (NSMutableArray *arr in dicValues) {
            [_quanList addObject:arr];
        }
    }
    
    [self.list removeAllObjects];
    
    if (self.actList.count > 0) {
        [self.list addObjectsFromArray:self.actList];
    }
    
    if (self.quanList.count > 0) {
        [self.list addObjectsFromArray:self.quanList];
    }
    
    [self.tableView reloadData];
    
}


@end
