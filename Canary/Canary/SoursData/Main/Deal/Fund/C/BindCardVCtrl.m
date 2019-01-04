//
//  BindCardVCtrl.m
//  Canary
//
//  Created by litong on 2017/6/1.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BindCardVCtrl.h"
#import "BindCardCell.h"

#import "SelectBankVCtrl.h"
#import "SelectProvinceVCtrl.h"
#import "SelectCityVCtrl.h"
#import "SelectSubBankVCtrl.h"


@interface BindCardVCtrl ()<SelectBankDelegate, SelectCityDelegate, SelectSubBankDelegate, SelectProvinceDelegate>

@property (nonatomic,strong) NSArray *list;

@property (nonatomic,strong) BankMO *bankMO;
@property (nonatomic,strong) SubBankMO *subBankMO;
@property (nonatomic,strong) ProvinceMO *provinceMO;
@property (nonatomic,strong) CityMO *cityMO;

@end

@implementation BindCardVCtrl


#define kStr_BCVC_Bank       @"银行"
#define kStr_BCVC_Province  @"省份"
#define kStr_BCVC_City          @"城市"
#define kStr_BCVC_SubBank  @"支行"
#define kStr_BCVC_BankNO   @"卡号"

#define kStr_BCVC_BankTip       @"请选择银行"
#define kStr_BCVC_ProvinceTip  @"请选择开户行所在省份"
#define kStr_BCVC_CityTip          @"请选择开户行所在城市"
#define kStr_BCVC_SubBankTip  @"请选择开户支行"
#define kStr_BCVC_BankNOTip   @"请输入卡号"


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navPopBackTitle:@"绑定银行卡"];

    self.list = @[
                      @{key_BCC_Title : kStr_BCVC_Bank, key_BCC_Next : @(1),
                          key_BCC_Holder : kStr_BCVC_BankTip ,
                        },
                      @{key_BCC_Title : kStr_BCVC_Province, key_BCC_Next : @(1),
                        key_BCC_Holder : kStr_BCVC_ProvinceTip ,
                        },
                      @{key_BCC_Title : kStr_BCVC_City, key_BCC_Next : @(1),
                        key_BCC_Holder : kStr_BCVC_CityTip ,
                        },
                      @{key_BCC_Title : kStr_BCVC_SubBank, key_BCC_Next : @(1),
                        key_BCC_Holder : kStr_BCVC_SubBankTip ,
                        },
                      @{key_BCC_Title : kStr_BCVC_BankNO, key_BCC_Next : @(0),
                        key_BCC_Holder : kStr_BCVC_BankNOTip ,
                        }
                  ];
    
    [self createTableView];
    CGRect rect = CGRectMake(0, NavBarTop_Lit, self.w_, self.h_ - NavBarTop_Lit);
    self.tableView.backgroundColor = LTBgColor;
    self.tableView.frame = rect;
    [self addFootView];
    [self.tableView reloadData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FootView

- (void)addFootView {
    UIView *footView = [UIView lineFrame:CGRectMake(0, 0, ScreenW_Lit, 79) color:self.tableView.backgroundColor];
    
    UIButton *btn = [UIButton btnWithTarget:self action:@selector(bindCardAction) frame:CGRectMake(kLeftMar, 12, kMidW, 45)];
    [btn setTitle:@"绑定" forState:UIControlStateNormal];
    [btn setTitleColorNSH:LTWhiteColor];
    btn.titleLabel.font = fontSiz(15);
    [btn layerRadius:3 bgColor:LTSureFontBlue];
    [footView addSubview:btn];
    
    self.tableView.tableFooterView = footView;
}

- (void)bindCardAction {
    if (!_bankMO) {
        [self.view showTip:kStr_BCVC_BankTip];
        return;
    }
    if (!_provinceMO) {
        [self.view showTip:kStr_BCVC_ProvinceTip];
        return;
    }
    if (!_cityMO) {
        [self.view showTip:kStr_BCVC_CityTip];
        return;
    }
    if (!_subBankMO) {
        [self.view showTip:kStr_BCVC_SubBankTip];
        return;
    }
    NSString *bankNo = [self bankCardNO];//银行卡号
    if (emptyStr(bankNo)) {
        [self.view showTip:kStr_BCVC_BankNOTip];
        return;
    }
    
    NSString *bankDepositId = _subBankMO.bankDepositId;//银行支行ID
    NSString *province = _provinceMO.name;//省份名称
    NSString *city = _cityMO.name;//城市名称
    NSString *bankName = _bankMO.name;//银行名称
    NSString *bankBranch = _subBankMO.name;//支行名称

    NSDictionary *dict = @{
                               @"bankDepositId" : bankDepositId,
                               @"bankNo" : bankNo,
                               @"province" : province,
                               @"city" : city,
                               @"bankName" : bankName,
                               @"bankBranch" : bankBranch,
                               @"userId" : UD_UserId,
                               @"token" : UD_Token
                           };
    WS(ws);
    [RequestCenter reqUserBindCard:dict finsh:^(LTResponse *res) {
        if (res.success) {
            [ws.view showTip:@"绑定成功"];
            [ws popVC];
        } else {
            [ws.view showTip:res.message];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier=@"BindCardCellID";
    BindCardCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[BindCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSInteger row = indexPath.row;
    NSDictionary *dict = _list[row];
    [cell bindData:dict];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kBindCardCellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSDictionary *dict = _list[row];
    NSString *title = [dict stringFoKey:key_BCC_Title];
    [self pushSelectVC:title];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    ShutAllKeyboard;
}

#pragma mark - utils

- (void)pushSelectVC:(NSString *)title {
    if ([title isEqualToString:kStr_BCVC_BankNO]) {//卡号
        
    } else {
//        [self shutkey];       //关闭键盘

        if ([title isEqualToString:kStr_BCVC_Bank]) {//银行
            SelectBankVCtrl *ctrl = [[SelectBankVCtrl alloc] init];
            ctrl.delegate = self;
            [self pushVC:ctrl];
        }
        else if ([title isEqualToString:kStr_BCVC_Province]) {//省份
            SelectProvinceVCtrl *ctrl = [[SelectProvinceVCtrl alloc] init];
            ctrl.delegate = self;
            [self pushVC:ctrl];
        }
        else if ([title isEqualToString:kStr_BCVC_City]) {//城市
            if (!_provinceMO) {
                [self.view showTip:kStr_BCVC_ProvinceTip];
                return;
            }
            SelectCityVCtrl *ctrl = [[SelectCityVCtrl alloc] init];
            ctrl.delegate = self;
            ctrl.provinceCode = _provinceMO.code;
            [self pushVC:ctrl];
        }
        else if ([title isEqualToString:kStr_BCVC_SubBank]) {//支行
            if (!_bankMO) {
                [self.view showTip:kStr_BCVC_BankTip];
                return;
            }
            if (!_cityMO) {
                [self.view showTip:kStr_BCVC_CityTip];
                return;
            }
            SelectSubBankVCtrl *ctrl = [[SelectSubBankVCtrl alloc] init];
            ctrl.delegate = self;
            ctrl.bankCode = _bankMO.code;
            ctrl.cityCode = _cityMO.code;
            [self pushVC:ctrl];
        }
    }
}

- (BindCardCell *)findCell:(NSInteger)idx {
    NSIndexPath *ipath = [NSIndexPath indexPathForRow:idx inSection:0];
    BindCardCell *cell = (BindCardCell *)[self.tableView cellForRowAtIndexPath:ipath];
    return cell;
}

- (NSString *)bankCardNO {
    BindCardCell *cell = [self findCell:4];
    NSString *cardNO = [cell fieldString];
    cardNO=[cardNO replacStr:@" " withStr:@""];
    return cardNO;
}


#pragma mark - SelectBankDelegate

- (void)selectBank:(BankMO *)mo {
    _bankMO = mo;
    
    BindCardCell *cell = [self findCell:0];
    [cell changeField:mo.name];
}

#pragma mark -  SelectProvinceDelegate

- (void)selectProvince:(ProvinceMO *)mo {
    _provinceMO = mo;
    
    BindCardCell *cell = [self findCell:1];
    [cell changeField:mo.name];
}

#pragma mark - SelectCityDelegate

- (void)selectCity:(CityMO *)mo {
    _cityMO = mo;
    
    BindCardCell *cell = [self findCell:2];
    [cell changeField:mo.name];
}

#pragma mark - SelectSubBankDelegate

- (void)selectSubBank:(SubBankMO *)mo {
    _subBankMO = mo;
    
    BindCardCell *cell = [self findCell:3];
    [cell changeField:mo.name];
}




@end
