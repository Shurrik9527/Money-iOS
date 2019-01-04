//
//  GiftChangeVCtrl.m
//  ixit
//
//  Created by litong on 2016/12/20.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "GiftChangeVCtrl.h"
#import "GiftChangeCell.h"
#import "GoodsExchangeCell.h"
#import "SelDateView.h"
#import "ActivityGiftChangeCell.h"
#import "PrivilegedCardInfoVCtrl.h"
#import "UITableView+LT.h"

#define selViewH 45
#define tempH     8

@interface GiftChangeVCtrl ()
{
    BOOL showDatePicker;
}
@property (nonatomic,strong) NSMutableArray *list;

@property (nonatomic,strong) UIView *selView;//选择日期
@property (nonatomic,strong) UIButton *selDateBtn;//选择日期
@property (nonatomic,strong) UILabel *dateLab;//日期
@property (nonatomic,strong) UIImageView *dateIV;//日期

@property (nonatomic,strong) SelDateView *selDateView;
@property (nonatomic,copy) NSString *ym;


@end

@implementation GiftChangeVCtrl

- (instancetype)init {
    self = [super init];
    if (self) {
        showDatePicker = NO;
        self.pageSize = kPageSize;
        self.ym = [[NSDate date] chinaFmt:@"yyyy-MM"];
        self.list = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self navTitle:@"兑换历史" backType:BackType_PopVC];
    
    [self createSelView];
    
    [self createTableViewWithHeaderAndFooter];
    CGFloat tabViewY = NavBarTop_Lit+selViewH+tempH;
    CGRect rect = CGRectMake(0, tabViewY, ScreenW_Lit, ScreenH_Lit - tabViewY);
    self.tableView.frame = rect;
    self.tableView.backgroundColor = LTWhiteColor;
    [self.tableView registerClass:[GiftChangeCell class]];
    [self.tableView registerClass:[GoodsExchangeCell class]];
    [self.tableView registerClass:[ActivityGiftChangeCell class]];

    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request

- (void)reqGiftChangeList {
        #warning 暂时注释
//    WS(ws);
//
//    if (self.pageNo != kStartPageNum) {
//        [self showLoadingView];
//    }
//
//    [RequestCenter reqUserGiftChangeList:self.pageNo pageSize:self.pageSize yearMonth:_ym finish:^(LTResponse *res) {
//        [ws hideLoadingView];
//        if (res.success) {
//            if (ws.pageNo == kStartPageNum) {
//                [ws.list removeAllObjects];
//            }
//            NSArray *arr = [GiftChangeMO objsWithList:res.resArr];
//            if (arr.count < ws.pageSize) {
//                [ws.tableView.footer noticeNoMoreData];
//            } else {
//                [ws.tableView.footer resetNoMoreData];
//            }
//            [ws.list addObjectsFromArray:arr];
//            if (_list.count == 0) {
//                [ws showEmptySubView:ws.tableView];
//            } else {
//                [ws hideEmptyView];
//            }
//            [ws endHeadOrFootRef];
//            [ws.tableView reloadData];
//        } else {
//            [LTAlertView alertMessage:res.message];
//        }
//    }];
}

#pragma mark - 父类重写

- (void)loadData {
    [self reqGiftChangeList];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    GiftChangeMO *mo = _list[row];
    //商品类型：1=代金券，2=直播室礼物，3=特权卡，4=实物兑换
    NSInteger giftType = mo.giftType;
    if (giftType == 3) {
        NSString *identifier= [UITableView cellReuseIdentifier:[ActivityGiftChangeCell class]];
        ActivityGiftChangeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        [cell bindData:mo];
        return cell;
    } else if (giftType == 4) {//4=实物兑换
        NSString *identifier= [UITableView cellReuseIdentifier:[GoodsExchangeCell class]];
        GoodsExchangeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        [cell bindData:mo];
        return cell;
    }
    
    NSString *identifier= [UITableView cellReuseIdentifier:[GiftChangeCell class]];
    GiftChangeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell bindData:mo];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    GiftChangeMO *mo = _list[row];
    //商品类型：1=代金券，2=直播室礼物，3=特权卡，4=实物兑换
    NSInteger giftType = mo.giftType;
    if (giftType == 4){
        return kGoodsChangeCellH;
    }
    return kGiftChangeCellH;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    GiftChangeMO *mo = _list[row];
    //商品类型：1=代金券，2=直播室礼物，3=特权卡，4=实物兑换
    NSInteger giftType = mo.giftType;
    if (giftType == 3) {
        PrivilegedCardInfoVCtrl *ctrl = [[PrivilegedCardInfoVCtrl alloc] init];
        ctrl.fromHistory = YES;
        ctrl.giftChangeMO = mo;
        ctrl.Integralmo = self.mo;
        [self pushVC:ctrl];
    }
}



#pragma mark - head

- (void)createSelView {
    self.selView = [[UIView alloc] init];
    _selView.frame = CGRectMake(0, NavBarTop_Lit, ScreenW_Lit, selViewH);
    _selView.backgroundColor = LTWhiteColor;
    [self.view addSubview:_selView];
    
    self.selDateBtn = [UIButton btnWithTarget:self action:@selector(selDateAction) frame:CGRectMake(0, 0, ScreenW_Lit, selViewH)];
    _selDateBtn.backgroundColor = LTWhiteColor;
    [_selView addSubview:_selDateBtn];
    
    
    self.dateLab = [[UILabel alloc] init];
    _dateLab.frame = CGRectMake(0, 0, ScreenW_Lit*0.4, selViewH);
    _dateLab.text = [self ymFmt];
    _dateLab.font = [UIFont fontOfSize:15];
    _dateLab.textColor = LTTitleColor;
    _dateLab.textAlignment = NSTextAlignmentCenter;
    [_selView addSubview:_dateLab];
    
    CGFloat ivw = 11;
    CGFloat ivh = 7;
    self.dateIV = [[UIImageView alloc] init];
    _dateIV.frame = CGRectMake(ScreenW_Lit - 44 - ivw, (selViewH - ivh)*0.5, ivw, ivh);
    _dateIV.image = [UIImage imageNamed:@"Shop_btn_close"];
    [_selView addSubview:_dateIV];
    
    UIView *lineView = [[UIView alloc] init] ;
    lineView.frame = CGRectMake(0, selViewH-0.5, ScreenW_Lit, 0.5);
    lineView.backgroundColor = LTLineColor;
    [_selView addSubview:lineView];

    CGFloat selDateViewY = _selView.yh_;
    CGRect sr = CGRectMake(0, selDateViewY, ScreenW_Lit, ScreenH_Lit - selDateViewY);
    self.selDateView = [[SelDateView alloc] initWithFrame:sr ym:_ym];
    [self.view addSubview:_selDateView];
    
    WS(ws);
    _selDateView.selDateBlock = ^(NSString *ym) {
        ws.ym = ym;
        ws.dateLab.text = [ws ymFmt];
        ws.pageNo = kStartPageNum;
        [ws reqGiftChangeList];
    };
    _selDateView.selDateViewShowBlock = ^(BOOL show) {
        [ws configDateIV:show];
    };
    
}

- (void)selDateAction {
    showDatePicker = !showDatePicker;
    
    //yes 显示日期
    [_selDateView showView:showDatePicker];
    [self.view bringSubviewToFront:_selDateView];
    [self configDateIV:showDatePicker];
    
}

- (void)configDateIV:(BOOL)show {
    showDatePicker = show;
    NSString *str = showDatePicker ? @"Shop_btn_open" : @"Shop_btn_close";
    _dateIV.image = [UIImage imageNamed:str];
}

#pragma mark - utils

- (NSString *)ymFmt {
    NSString *str = [_ym replacStr:@"-" withStr:@"年"];
    NSString *ym = [NSString stringWithFormat:@"%@月",str];
    return ym;
}

@end
