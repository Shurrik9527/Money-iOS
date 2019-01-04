//
//  BaseTableViewController.h
//  ixit
//
//  Created by litong on 16/10/26.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "BaseVCtrl.h"
#import "MJRefresh.h"

@interface BaseTableVCtrl : BaseVCtrl<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    
}

@property(nonatomic,assign)NSInteger pageNo;
@property(nonatomic,assign)NSInteger pageSize;
@property(nonatomic,strong)UITableView *tableView;


- (void)createTableView;
- (void)createTableViewWithHeader;
- (void)createTableViewWithFooter;
- (void)createTableViewWithHeaderAndFooter;

- (void)endHeadOrFootRef;


#pragma mark - 显示空数据数据view
- (void)showEmptySubView:(UIView *)view;
- (void)showEmptySubView:(UIView *)view title:(NSString *)title;
- (void)hideEmptyView;
- (void)showEmptyView;
- (void)showEmptyView:(NSString *)title;

@end
