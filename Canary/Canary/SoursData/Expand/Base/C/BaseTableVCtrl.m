//
//  BaseTableViewController.m
//  ixit
//
//  Created by litong on 16/10/26.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "BaseTableVCtrl.h"

@interface BaseTableVCtrl ()

@property (nonatomic,strong) UIView *empteView;

@end

@implementation BaseTableVCtrl

- (id)init {
    self = [super init];
    if (self) {
        self.pageNo = kStartPageNum;
        self.pageSize = kPageSize;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createTableView {
    [self createTableViewWithHeader:NO Footer:NO];
}
- (void)createTableViewWithHeader {
    [self createTableViewWithHeader:YES Footer:NO];
}

- (void)createTableViewWithFooter {
    [self createTableViewWithHeader:NO Footer:YES];
}

- (void)createTableViewWithHeaderAndFooter {
    [self createTableViewWithHeader:YES Footer:YES];
}


- (void)createTableViewWithHeader:(BOOL)hbl Footer:(BOOL)fbl {
    CGRect rect = CGRectMake(0, NavBarTop_Lit, self.w_, self.h_ - NavBarTop_Lit - TabBarH_Lit);
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = LTBgColor;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    
    if (hbl) {
        [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    }
    
    if (fbl) {
        [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    }
    
}


#pragma mark - action

- (void)loadData {}
/**
 *  @brief  下拉刷新
 */
- (void)headerRereshing {
    self.pageNo = kStartPageNum;
    [self loadData];
}

/**
 *  @brief  上提刷新
 */
- (void)footerRereshing {
    self.pageNo ++ ;
    [self loadData];
}

- (void)endHeadOrFootRef {
    if (_pageNo == kStartPageNum) {
        [self.tableView.header endRefreshing];
    } else {
        [self.tableView.footer endRefreshing];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}




#pragma mark - 显示空数据数据view

- (void)showEmptySubView:(UIView *)view {
    [self showEmptySubView:view title:nil imageName:nil];
}
- (void)showEmptySubView:(UIView *)view title:(NSString *)title {
    [self showEmptySubView:view title:title imageName:nil];
}


- (void)hideEmptyView {
    _empteView.hidden=YES;
    [_empteView removeAllSubView];
    [_empteView removeFromSuperview];
}
- (void)showEmptyView {
    [self showEmptySubView:nil title:nil imageName:nil];
}
- (void)showEmptyView:(NSString *)title {
    [self showEmptySubView:nil title:title imageName:nil];
}


- (void)showEmptySubView:(UIView *)view title:(NSString *)title imageName:(NSString *)imageName {
    if (!title) {
        title = @"暂无数据";
    }
    if (!imageName) {
        imageName = @"emptyIcon";
    }
    
    [self createEmptySubView:view title:title imageName:imageName];
    
    [self.view bringSubviewToFront:_empteView];
    
    
}

- (void)createEmptySubView:(UIView *)view title:(NSString *)title imageName:(NSString *)imageName {
    if (_empteView) {
        [self hideEmptyView];
    }
    
    UIImage *img = [UIImage imageNamed:imageName];
    CGFloat iw = ScreenW_Lit - 2*kLeftMar;
    CGFloat ih = ScreenW_Lit/3.0;
    CGFloat labh = 50;
    CGFloat emptyViewH = ih + labh;
    
    
    self.empteView = [[UIView alloc] init];
    _empteView.frame = CGRectMake(kLeftMar, (self.tableView.h_ - emptyViewH)*0.5, iw, emptyViewH);
    _empteView.backgroundColor = self.tableView.backgroundColor;
    [self.tableView addSubview:_empteView];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = CGRectMake(0, 0, iw, ih);
    imgView.image = img;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.userInteractionEnabled = YES;
    [imgView addSingeTap:@selector(loadData) target:self];
    [_empteView addSubview:imgView];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(0, imgView.yh_, iw, labh);
    lab.font = [UIFont fontOfSize:15.f];
    lab.textColor = LTSubTitleColor;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = title;
    [_empteView addSubview:lab];
    
}

@end
