//
//  SelectProvinceVCtrl.m
//  Canary
//
//  Created by litong on 2017/6/2.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "SelectProvinceVCtrl.h"

@implementation ProvinceMO

@end

@interface SelectProvinceVCtrl ()<UISearchBarDelegate>

@property (nonatomic,strong) NSMutableArray *list;

@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) NSMutableArray *searchList;
@property (nonatomic,assign) BOOL showSearchList;

@end

@implementation SelectProvinceVCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navPopBackTitle:@"选择省份"];
    self.list = [NSMutableArray array];
    self.searchList = [NSMutableArray array];
    self.showSearchList = NO;
    
    [self createSearchBar];
    
    [self createTableViewWithHeader];
    CGFloat y = _searchBar.yh_;
    CGRect rect = CGRectMake(0, y, self.w_, self.h_ - y);
    self.tableView.backgroundColor = LTBgColor;
    self.tableView.frame = rect;
    self.tableView.separatorColor = LTLineColor;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [self.tableView.header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated {
    [_searchBar resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    WS(ws);
    [RequestCenter reqProvinceList:^(LTResponse *res) {
        if (res.success) {
            NSArray *arr = [ProvinceMO objsWithList:res.resArr];
            [ws.list removeAllObjects];
            [ws.list addObjectsFromArray:arr];
            [ws.tableView reloadData];
        } else {
            [ws.view showTip:res.message];
        }
        [ws endHeadOrFootRef];
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_showSearchList) {
        return _searchList.count;
    }
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier=@"ProvinceCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    ProvinceMO *mo = nil;
    if (_showSearchList) {
        mo = _searchList[indexPath.row];
    } else {
        mo = _list[indexPath.row];
    }
    cell.textLabel.text = mo.name;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProvinceMO *mo = nil;
    if (_showSearchList) {
        mo = _searchList[indexPath.row];
    } else {
        mo = _list[indexPath.row];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(selectProvince:)]) {
        [_delegate selectProvince:mo];
        [self popVC];
    }
}




#pragma mark -
#pragma mark - 搜索

#define kSearchBarH 44
- (void)createSearchBar {
    self.searchBar = [[UISearchBar alloc] init];
    _searchBar.frame = CGRectMake(0, NavBarTop_Lit, ScreenW_Lit, kSearchBarH);
    [_searchBar setPlaceholder:@"搜索"];
    _searchBar.showsCancelButton = NO;
    _searchBar.delegate = self;
    //    _searchBar.backgroundImage = [UIImage imageNamed:@"searchBG"];
    [self.view addSubview:_searchBar];
}

- (void)setShowSearchList:(BOOL)showSearchList {
    _showSearchList = showSearchList;
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [_searchList removeAllObjects];
    for (ProvinceMO *mo in _list) {
        NSString *str = mo.name;
        BOOL bl = [LTUtils searchStr:str isContainStr:searchText];
        if (bl) {
            [_searchList addObject:mo];
        }
    }
    self.showSearchList = YES;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.showSearchList = YES;
    searchBar.showsCancelButton = YES;
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = nil;
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
    self.showSearchList = NO;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_searchBar resignFirstResponder];
}


@end
