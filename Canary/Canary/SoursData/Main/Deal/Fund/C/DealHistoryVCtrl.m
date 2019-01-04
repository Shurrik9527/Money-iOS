//
//  DealHistoryVCtrl.m
//  Canary
//
//  Created by litong on 2017/6/1.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "DealHistoryVCtrl.h"
#import "DealHistoryMO.h"
@interface DealHistoryVCtrl ()

@property (nonatomic,strong) NSMutableArray *list;


@end

@implementation DealHistoryVCtrl


#define kDealHistoryCellID  @"kDealHistoryCellID"

- (void)viewDidLoad {
    [super viewDidLoad];

    [self navPopBackTitle:@"交易历史"];
    
    self.list = [NSMutableArray array];
    
    [self createTableViewWithHeaderAndFooter];
    self.tableView.frame = CGRectMake(0, NavBarTop_Lit, self.w_, self.h_ - NavBarTop_Lit);
    [self.tableView registerNib:[UINib nibWithNibName:@"DealHistoryCell" bundle:nil] forCellReuseIdentifier:kDealHistoryCellID];
    [self.tableView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - req

- (void)loadData {
    if (self.pageNo != kStartPageNum) {
        [self showLoadingView];
    }

    WS(ws);
    [RequestCenter reqDealHistoryListWithPage:self.pageNo pageSize:self.pageSize finsh:^(LTResponse *res) {
        [ws endHeadOrFootRef];
        [ws hideLoadingView];
        if (res.success) {
            
            if (ws.pageNo == kStartPageNum) {
                [ws.list removeAllObjects];
            }
            
            NSArray *arr = [DealHistoryMO objsWithList:res.resArr];
            
            if (arr.count < ws.pageSize) {
                [ws.tableView.footer noticeNoMoreData];
            } else {
                [ws.tableView.footer resetNoMoreData];
            }
            
            [ws.list addObjectsFromArray:arr];
            
            if (_list.count == 0) {
                [ws showEmptySubView:ws.tableView];
            } else {
                [ws hideEmptyView];
            }
            [ws.tableView reloadData];
            
        } else {
            [ws handleTokenTimeout:res];
//            [LTAlertView alertMessage:res.message];
        }

    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _list.count;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}



@end
