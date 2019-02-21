//
//  BuyingSellingVC.m
//  Canary
//
//  Created by 孙武东 on 2019/1/2.
//  Copyright © 2019 litong. All rights reserved.
//

#import "BuyingSellingVC.h"
#import "BuyingSellingCell.h"
#import "GuaDanView.h"
#import "BuySellingModel.h"

@interface BuyingSellingVC ()

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation BuyingSellingVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tableView.frame = self.view.frame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableViewWithHeaderAndFooter];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.tableView registerNib:[UINib nibWithNibName:@"BuyingSellingCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([BuyingSellingCell class])];
    
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)loadData{
    
    NSString * url = [NSString stringWithFormat:@"%@%@",BaseUrl,@"/symbolInfo/getList"];
    [[NetworkRequests sharedInstance] SWDPOST:url dict:@{@"page":@(self.pageNo),@"pageSize":@(self.pageSize)} succeed:^(id resonseObj, BOOL isSuccess, NSString *message) {
        NSLog(@"res == %@",resonseObj);
        
        if (isSuccess) {
            
            if (self.pageNo == 0) {
                [self.dataArray removeAllObjects];
            }
            
            NSArray *array = [BuySellingModel mj_objectArrayWithKeyValuesArray:resonseObj[@"list"]];
            
            [self.dataArray addObjectsFromArray:array];
            
        }
        [self endHeadOrFootRef];

    } failure:^(NSError *error) {
        
        [self endHeadOrFootRef];

    }];
    
}

- (void)showGuaDanView:(BOOL)isGuaDan isDown:(BOOL)isDown{
    GuaDanView *gua = [[NSBundle mainBundle]loadNibNamed:@"GuaDanView" owner:nil options:nil].firstObject;
    gua.isGuaDan = isGuaDan;
    gua.isBuyDown = isDown;
    gua.frame = CGRectMake(0, 0, Screen_width, Screen_height);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:gua];
    
}

- (void)gotoGuaDanAction{
    
    
    if (![LTUser hasLogin]) {
        LoginVCtrl *ctrl = [[LoginVCtrl alloc] init];
        [self pushVC:ctrl];
    }else{
        [self showGuaDanView:YES isDown:NO];
    }
}

- (void)gotoBuyUpAction{
    if (![LTUser hasLogin]) {
        LoginVCtrl *ctrl = [[LoginVCtrl alloc] init];
        [self pushVC:ctrl];
    }else{
        [self showGuaDanView:NO isDown:NO];
    }
}

- (void)gotoBuyDownAction{
    if (![LTUser hasLogin]) {
        LoginVCtrl *ctrl = [[LoginVCtrl alloc] init];
        [self pushVC:ctrl];
    }else{
        [self showGuaDanView:NO isDown:YES];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BuySellingModel *model = self.dataArray[indexPath.row];
    
    BuyingSellingCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BuyingSellingCell class]) forIndexPath:indexPath];
    
    cell.model = model;
    
    WS(ws);
    cell.guaDanAction = ^{
        [ws gotoGuaDanAction];
    };
    cell.buyUpAction = ^{
        [ws gotoBuyUpAction];
    };
    cell.buyDownAction = ^{
        [ws gotoBuyDownAction];
    };
    return cell;

}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 233;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@",[tableView indexPathsForVisibleRows]);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
