//
//  FundVCtrl.m
//  Canary
//
//  Created by litong on 2017/5/16.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "FundVCtrl.h"
#import "FundCell.h"


@interface FundVCtrl ()
{
    CGFloat tableViewHeaderH;
}
@property(strong,nonatomic)NSArray *datas;

@end

@implementation FundVCtrl

- (void)viewDidLoad {
    [super viewDidLoad];

    self.datas = @[@[kStr_FundRecharge, kStr_FundWithdraw] ,
                            @[kStr_FundDealHistory, kStr_FundMoneyRecord]];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = LTBgColor;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(@0);
    }];
    
    tableViewHeaderH = 20;
    
    NFC_AddObserver(NFC_DealHeadRefresh, @selector(configMinPrice:));
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NFC_RemoveAllObserver;
}



#pragma mark  - TableHeaderView

- (void)showWarningAddHeader:(BOOL)bl {
    tableViewHeaderH = bl ? 40 : 20;
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.datas[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier=@"kFundCellID";
    FundCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[FundCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *tit = self.datas[section][row];
    [cell bindData:tit];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return tableViewHeaderH;
    }
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kFundCellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *tit = self.datas[section][row];
    
    if (_delegate && [_delegate respondsToSelector:@selector(fundPush:)]) {
        [_delegate fundPush:tit];
    }
}

#pragma mark - utils

- (void)configMinInPriceCell:(NSString *)minPrice {
    NSIndexPath *ipath = [NSIndexPath indexPathForRow:0 inSection:0];
    FundCell *cell = ( FundCell *)[self.tableView cellForRowAtIndexPath:ipath];
    [cell changeDetails:minPrice];
}

- (void)configMinOutPriceCell:(NSString *)minPrice {
    NSIndexPath *ipath = [NSIndexPath indexPathForRow:1 inSection:0];
    FundCell *cell = ( FundCell *)[self.tableView cellForRowAtIndexPath:ipath];
    [cell changeDetails:minPrice];
}

- (void)configMinPrice:(NSNotification *)sender {
    NSDictionary *dict = sender.userInfo;
    if([dict isNotNull]){
        //最低出金
        NSString *rechargeMinAmountDesc = [dict stringFoKey:@"rechargeMinAmountDesc"];
        NSString *cashOutMinAmountDesc = [dict stringFoKey:@"cashOutMinAmountDesc"];
        [self configMinInPriceCell:rechargeMinAmountDesc];
        [self configMinOutPriceCell:cashOutMinAmountDesc];
    }
}


@end
