//
//  ManagerBankCardVC.m
//  Canary
//
//  Created by litong on 2017/6/1.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "ManagerBankCardVC.h"
#import "BankCardCell.h"
#import "BindCardVCtrl.h"

@interface ManagerBankCardVC ()<BankCardCellDelegate>

@property (nonatomic,strong) NSMutableArray *list;


@end

@implementation ManagerBankCardVC


#define kBankCardCellID  @"kBankCardCellID"

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navPopBackTitle:@"管理银行卡"];
    
    self.list = [NSMutableArray array];
    
    [self createTableViewWithHeader];
    CGRect rect = CGRectMake(0, NavBarTop_Lit, self.w_, self.h_ - NavBarTop_Lit);
    self.tableView.backgroundColor = LTBgColor;
    self.tableView.frame = rect;
    [self.tableView registerClass:[BankCardCell class] forCellReuseIdentifier:kBankCardCellID];
//    [self.tableView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

#pragma mark - req

- (void)loadData {
    WS(ws);
    [RequestCenter reqUserBindedBankList:^(LTResponse *res) {
        [ws endHeadOrFootRef];
        NSLog(@"manger bank card");
        if (res.success) {
            [ws.list removeAllObjects];
            NSArray *arr = [BankCarkMO objsWithList:res.resArr];
            [ws.list addObjectsFromArray:arr];
            [ws.tableView reloadData];
        } else {
            [LTAlertView alertMessage:res.message];
        }
        
    }];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _list.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger count = _list.count;
    BankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:kBankCardCellID];
    if (row < count && count != 0) {
        cell.delegate = self;
        cell.typ = BankCardCellType_UnBind;
        BankCarkMO *mo = _list[row];
        [cell bindData:mo];
    }
    else {//添加银行卡
        cell.typ = BankCardCellType_AddCard;
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kBankCardCellH;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger count = _list.count;
    if (row < count && count != 0) {
        BankCarkMO *mo = _list[row];
        [self unBindCard:mo];
    }
    else {//添加银行卡
        BindCardVCtrl *ctrl = [[BindCardVCtrl alloc] init];
        [self pushVC:ctrl];
    }
}

#pragma mark - BankCardCellDelegate
//解绑
- (void)unBindCard:(BankCarkMO *)mo {

}


@end
