//
//  MyGainVCtrl.m
//  ixit
//
//  Created by litong on 2016/11/14.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "MyGainVCtrl.h"
#import "MyGainCell.h"
#import "MyGainDetailVCtrl.h"


@interface MyGainVCtrl ()

@property (nonatomic,strong) NSMutableArray *list;


@end

@implementation MyGainVCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.list = [NSMutableArray array];

    [self navTitle:@"今日盈利单" backType:BackType_PopVC];
    
    [self createTableViewWithHeader];
    self.tableView.backgroundColor = LTBgColor;
    CGRect rect = CGRectMake(0, NavBarTop_Lit, self.view.w_, self.view.h_ - NavBarTop_Lit);
    self.tableView.frame = rect;

    [self.tableView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 网络请求

- (void)loadData {
//    WS(ws);
//    
//    [RequestCenter reqMyGainCompletion:^(LTResponse *res) {
//        
//        if (res.success) {
//            NSArray *arr = [MyGainModel objsWithList:res.resArr];
//            if (arr.count > 0) {
//                [ws hideEmptyView];
//                
//                if (ws.pageNo == kStartPageNum) {
//                    [ws.list removeAllObjects];
//                }
//                
//                [ws.list addObjectsFromArray:arr];
//                
//                
//            }
//            
//            if (ws.list.count > 0) {
//                [ws hideEmptyView];
//            } else {
//                [ws showEmptyView:@"暂无可晒盈利单"];
//            }
//            [ws.tableView reloadData];
//            
//        } else {
//            [ws.view showTip:res.message];
//        }
//        
//        [ws endHeadOrFootRef];
//    }];
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier=@"MyGainCell";
    MyGainCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyGainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    MyGainModel *mo = _list[indexPath.row];
    [cell bindData:mo];
    
    return cell;
}

#pragma mark - UITableViewDelegate


//static CGFloat HeaderSectionH = 28;
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *view = [[UIView alloc] init];
//    view.frame = CGRectMake(0, 0, self.w_, LTAutoW(HeaderSectionH));
//    view.backgroundColor = LTBgColor;
//    
//    UILabel *lab = [[UILabel alloc] init];
//    lab.frame = CGRectMake(LTAutoW(kLeftMar), 0, 200, LTAutoW(HeaderSectionH));
//    lab.font = autoFontSiz(12);
//    lab.textColor = LTSubTitleColor;
//    lab.text = @"今日盈利单";
//    [view addSubview:lab];
//    
//    return view;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return LTAutoW(HeaderSectionH);
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LTAutoW(MyGainCellH);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MyGainModel *mo = _list[indexPath.row];
    MyGainDetailVCtrl *ctrl = [[MyGainDetailVCtrl alloc] init];
    [ctrl configData:mo];
    [self pushVC:ctrl];
}


@end
