//
//  OutcryVCtrl.m
//  ixit
//
//  Created by litong on 16/10/27.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "OutcryVCtrl.h"
#import "OutcryCell.h"
#import "OutcryRichCell.h"
#import "Masonry.h"

@interface OutcryVCtrl ()

@property(strong,nonatomic)NSMutableArray * datas;
@property (nonatomic,assign) NSInteger topNum;

@end

@implementation OutcryVCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datas = [NSMutableArray array];

    [self createTableViewWithHeaderAndFooter];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(@0);
    }];
    [self.tableView.header beginRefreshing];
}

- (void)dealloc {
    NSLog(@"OutcryVCtrl dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request
- (void)loadData {
    WS(ws);
    [RequestCenter requesOutcryList:self.pageNo count:self.pageSize roomId:self.rid completion:^(LTResponse *res) {
        if (res.success) {
            NSArray *list = [OutcryModel objsWithList:res.resArr];
            if (list.count > 0) {
                if (ws.pageNo == kStartPageNum) {
                    ws.topNum = 0;
                    [ws.datas removeAllObjects];
                }
                [ws.datas addObjectsFromArray:list];
                if (ws.pageNo == kStartPageNum) {
                    for (OutcryModel *mo in list) {
                        if (mo.top_fmt) {
                            ws.topNum ++;
                        }
                    }
                }
                
                [ws.tableView reloadData];
            }
        } else {
            [ws.tableView showTip:res.message];
        }
        [ws endHeadOrFootRef];
    }];
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    OutcryModel *model = self.datas[row];
    
    if (model.top_fmt) {
        static NSString *identifier=@"OutcryRichCellID";
        OutcryRichCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[OutcryRichCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell bindData:model];
        return cell;
        
    } else {
        static NSString *identifier=@"OutcryCellID";
        OutcryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[OutcryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        [cell bindData:model begin:(row==_topNum)];
        return cell;
    }

    
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OutcryModel *model = self.datas[indexPath.row];
    CGFloat h = 0;
    if (model.top_fmt){
        h =  [OutcryRichCell cellHWithMo:model];
    } else {
        h =  [OutcryCell cellHWithMo:model];
    }
    return h;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
