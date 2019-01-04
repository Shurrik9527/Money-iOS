//
//  MoneyRecordListVCtrl.m
//  Canary
//
//  Created by litong on 2017/6/2.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "MoneyRecordListVCtrl.h"


@interface MoneyRecordListVCtrl ()

@property(strong,nonatomic)NSMutableArray * inDatas;
@property(strong,nonatomic)NSMutableArray * outDatas;

@end

@implementation MoneyRecordListVCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.inDatas = [NSMutableArray array];
    self.outDatas = [NSMutableArray array];
    
    [self createTableViewWithHeaderAndFooter];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(@0);
    }];
    [self.tableView.header beginRefreshing];
}

- (void)dealloc {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request

- (void)loadData {
    WS(ws);
    if (_typ == MoneyRecordType_in) {
        [RequestCenter reqRechargeListWithPage:self.pageNo pageSize:self.pageSize finsh:^(LTResponse *res) {
            [ws configDatas:res typ:MoneyRecordType_in];
        }];

    }
    else {
        [RequestCenter reqCashOutListWithPage:self.pageNo pageSize:self.pageSize finsh:^(LTResponse *res) {
            [ws configDatas:res typ:MoneyRecordType_out];
        }];
    }

}

- (void)configDatas:(LTResponse *)res typ:(MoneyRecordType)typ {
    [self endHeadOrFootRef];
    [self hideLoadingView];
    if (res.success) {
        NSMutableArray *list = (typ == MoneyRecordType_in) ? self.inDatas : self.outDatas;
        if (self.pageNo == kStartPageNum) {
            [list removeAllObjects];
        }
        NSArray *arr = nil;
        if (typ == MoneyRecordType_in) {
            arr = [NSArray arrayWithArray:[MoneyRecordMO inObjsWithList:res.resArr]];
        } else {
            arr = [NSArray arrayWithArray:[MoneyRecordMO outObjsWithList:res.resArr]];
        }
        if (arr.count < self.pageSize) {
            [self.tableView.footer noticeNoMoreData];
        } else {
            [self.tableView.footer resetNoMoreData];
        }
        
        [list addObjectsFromArray:arr];
        
        if (list.count == 0) {
            [self showEmptySubView:self.tableView];
        } else {
            [self hideEmptyView];
        }
        [self.tableView reloadData];
        
    } else {
        [self.tableView showTip:res.message];
        NSMutableArray *list = (typ == MoneyRecordType_in) ? self.inDatas : self.outDatas;
        if (list.count == 0) {
            [self showEmptySubView:self.tableView];
        } else {
            [self hideEmptyView];
        }
    }
}

#pragma mark - action



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_typ == MoneyRecordType_in) {
       return self.inDatas.count;
    } else if (_typ == MoneyRecordType_out) {
        return self.outDatas.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MoneyRecordCellID";
    MoneyRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MoneyRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.typ = _typ;
    MoneyRecordMO *mo = nil;
    NSInteger row = indexPath.row;
    if (_typ == MoneyRecordType_in) {
        mo = _inDatas[row];
    } else if (_typ == MoneyRecordType_out) {
        mo = _outDatas[row];
    }
    [cell bindData:mo];
    
    return cell;
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kMoneyRecordCellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MoneyRecordMO * mo = nil;
    NSInteger row = indexPath.row;
    if (_typ == MoneyRecordType_in) {
        mo = _inDatas[row];
    } else if (_typ == MoneyRecordType_out) {
        mo = _outDatas[row];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(pushDetails:typ:)]) {
        [_delegate pushDetails:mo typ:_typ];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW_Lit, 8)];
    view.backgroundColor = tableView.backgroundColor;
    return view;
}



@end
