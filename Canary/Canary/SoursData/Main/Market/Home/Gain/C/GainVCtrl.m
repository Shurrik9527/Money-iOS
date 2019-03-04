//
//  GainVCtrl.m
//  ixit
//
//  Created by litong on 2016/11/14.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "GainVCtrl.h"
#import "GainTopCell.h"
#import "GainCell.h"
#import "GainBtmView.h"
#import "MyGainVCtrl.h"
#import "BarPopView.h"
#import "GainDetailVCtrl.h"
#import "NSDate+LT.h"

@interface GainVCtrl ()
{
    
}

@property (nonatomic,assign) BOOL hasTop3;//YES:今天分享人数>=3
@property (nonatomic,assign) BOOL hasTopToday;//YES:今天分享人数>0

@property (nonatomic,strong) NSMutableArray *list;
@property (nonatomic,strong) GainBtmView *btmView;
@property (nonatomic,strong) ShowGainModel *showGainModel;
@property (nonatomic,strong) BarPopView *barPopView;

@end

@implementation GainVCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushGainDetail:) name:NFC_ClickRankView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareSuccess) name:NFC_ShareGainSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:NFC_LocLogin object:nil];
    
    
    _hasTop3 = NO;
    _hasTopToday = NO;
    self.list = [NSMutableArray array];
    self.pageSize = 20.f;

    
    [self navTitle:@"盈利榜" backType:BackType_PopVC rightImgName:@"navIcon_tip1"];
    
    
    
    [self createTableViewWithHeaderAndFooter];
    self.tableView.backgroundColor = LTBgColor;
    CGRect rect = CGRectMake(0, NavBarTop_Lit, self.view.w_, self.view.h_ - NavBarTop_Lit-LTAutoW(GainBtmViewH));
    self.tableView.frame = rect;
    
    [self createGainBtmView];
    [self createBarPopView];
    
    [self.tableView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:NFC_ClickRankView];
    [[NSNotificationCenter defaultCenter] removeObserver:NFC_ShareGainSuccess];
    [[NSNotificationCenter defaultCenter] removeObserver:NFC_LocLogin];
    
}

#pragma mark - action

- (void)rightBarAction {
    [_barPopView show];
}



- (void)refShowGainView {
    if ([LTUser hasLogin]) {
        if (_showGainModel.myRanking == 0) {
            self.btmView.typ = GainBtmViewType_meOutTop;
        } else {
            self.btmView.typ = GainBtmViewType_meInTop;
        }
    } else {
        self.btmView.typ = GainBtmViewType_logout;
    }
    [self.btmView refData:_showGainModel];
}

- (void)pushGainDetail:(NSNotification *)obj {
    NSDictionary *dict = obj.object;
    if ([dict isKindOfClass:[NSDictionary class]]) {
        GainModel *mo = dict[@"GainModel"];
        NSInteger ranking = [dict integerFoKey:@"ranking"] - 1;
        [self pushGainDetailVC:mo idx:ranking];
    }
}

- (void)shareSuccess {
    self.pageNo = kStartPageNum;
    [self loadData];
}

- (void)loginSuccess {
    self.pageNo = kStartPageNum;
    [self loadData];
}


#pragma mark - 网络请求

- (void)loadData {
    if (self.pageNo == kStartPageNum) {
        [self reqShowGian];
    }
    [self reqRateList];
}

- (void)reqRateList {
    WS(ws);
    [self showLoadingWithMsg:@"正在加载..."];
    [RequestCenter reqGainList:self.pageNo completion:^(LTResponse *res) {
        [ws hideLoadingView];
        
        if (res.success) {
            NSArray *arr = [GainModel objsWithList:res.resArr];
            if (arr.count > 0) {
                if (ws.pageNo == kStartPageNum) {
                    [ws.list removeAllObjects];
                }
                [ws configDatas:arr];
            }

            if (ws.list.count > 0) {
                [ws hideEmptyView];
                ws.btmView.hidden = NO;
            }
            else {
                [ws showEmptyView];
                ws.btmView.hidden = YES;
            }
            [ws.tableView reloadData];
            
        }
        else {
            [ws.view showTip:res.message];
        }
         [ws endHeadOrFootRef];
    }];
}

- (void)configDatas:(NSArray *)arr {
    
    NSMutableArray *mos = [NSMutableArray array];
    GainModel *oldMO = nil;
    
    if (_list.count > 0) {
        [mos addObjectsFromArray:[_list lastObject]];
        [_list removeLastObject];
        if (mos.count > 0) {
            oldMO = mos[0];
        }
    }
    
    
    
    NSInteger i = 0;
    NSInteger arrCount = arr.count;
    
    for (GainModel *mo in arr) {
        
        if (!oldMO) {
            [mos addObject:mo];
        } else {
            if ([oldMO.closeDate isEqualToString:mo.closeDate]) {
                [mos addObject:mo];

            } else {
                NSArray *temp = [NSArray arrayWithArray:mos];
                [_list addObject:temp];
                [mos removeAllObjects];
                
                [mos addObject:mo];
            }
        }
        oldMO = mo;
        
        i++;
        
        if (i == arrCount) {
            NSArray *temp = [NSArray arrayWithArray:mos];
            [_list addObject:temp];
            [mos removeAllObjects];
        }
    }
    
    if (_list.count > 0) {
        NSString *todayYMD = [[NSDate date] chinaYMDString];
        NSArray *temp = [NSArray arrayWithArray:_list[0]];
        if (temp.count > 0) {
            GainModel *mo = temp[0];
            if ([mo.closeDate isEqualToString:todayYMD]) {
                _hasTopToday = YES;
                
                if (temp.count >= 3) {
                    _hasTop3 = YES;
                } else {
                    _hasTop3 = NO;
                }
                
            } else {
                _hasTopToday = NO;
            }
        }
    }
    
}

- (void)reqShowGian {
    WS(ws);
    [RequestCenter reqShowGainCompletion:^(LTResponse *res) {
        if (res.success) {
            ws.showGainModel = [ShowGainModel objWithDict:res.resDict];
            [ws refShowGainView];
        }
    }];
}





#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_hasTopToday) {
        return _list.count;
    } else {
        return _list.count + 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_hasTopToday) {
        if (section == 0) {
            NSArray *arr = [NSArray arrayWithArray:_list[0]];
            if (arr.count>= 3) {
                return arr.count-2;
            }
            return 1;
        }
    } else {
        if (section == 0) {
            return 1;
        }
        section-=1;
    }
    
    if (_list.count > 0) {
        return ((NSArray *)_list[section]).count;
    } else {
        return 0;
    }
    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (_hasTopToday) {
        if (section == 0) {
            if (row == 0) {
                return [self configCellSection0Row0];
            } else {
                NSInteger idx = row+2;
                return [self configCellSection:section row:row idx:idx];;
            }
            
        } else {
            if (section == 0) {
                return [self configCellSection0Row0];
            } else {
                NSInteger idx = row;
                return [self configCellSection:section row:row idx:idx];;
            }
        }
    } else {
        if (section == 0) {
            return [self configCellSection0Row0];
        } else {
            
            section -=1;
            NSInteger idx = row;
            return [self configCellSection:section row:row idx:idx];
            
        }
    }

}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (_hasTopToday) {
        if (section == 0 && row == 0) {
            NSArray *arr = [NSArray arrayWithArray:_list[0]];
            if (arr.count>= 3) {
                return LTAutoW(GainTopCellH);
            }
            return LTAutoW(GainTopCellH1);
        }
    } else {
        if (section == 0) {
            return LTAutoW(GainTopCellH1);
        }
    }

    return LTAutoW(GainCellH);
    
}


static CGFloat HeaderSectionH = 28;
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectZero;
    if (section == 0) {
        return view;
    }
    
    if (!_hasTopToday) {
        section-=1;
    }
    
    NSArray *arr = [NSArray arrayWithArray:_list[section]];
    if (arr.count > 0) {
        GainModel *mo = arr[0];
        NSString *time = [mo.closeDate stringFMD:@"MM-dd" withSelfFMT:@"yyyy-MM-dd"];
        
        view.frame = CGRectMake(0, 0, self.view.w_, LTAutoW(HeaderSectionH));
        view.backgroundColor = LTBgColor;
        
        UILabel *lab = [[UILabel alloc] init];
        lab.frame = CGRectMake(LTAutoW(kLeftMar), 0, 200, LTAutoW(HeaderSectionH));
        lab.font = autoFontSiz(15);
        lab.textColor = LTSubTitleColor;
        lab.text = time;
        [view addSubview:lab];
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    
    if (!_hasTopToday) {
        section -=1;
    }
    
    if (_list.count > 0) {
        NSArray *arr = [NSArray arrayWithArray:_list[section]];
        if (arr.count > 0) {
            return LTAutoW(HeaderSectionH);
        }
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSInteger idx = row;
    
    if (_hasTopToday) {
        if (section == 0) {
            if (row == 0) {
                return;
            } else {
                idx = row+2;
            }
        } else {
            if (section == 0) {
                return;
            }
        }
    } else {
        if (section == 0) {
            return;
        } else {
            section -=1;
        }
    }
    GainModel *mo = _list[section][idx];
    [self pushGainDetailVC:mo idx:idx];
}


#pragma mark - utils

- (void)pushGainDetailVC:(GainModel *)mo idx:(NSInteger)idx {
    if (mo) {
        GainDetailVCtrl *ctrl = [[GainDetailVCtrl alloc] init];
        [ctrl configData:mo ranking:(idx+1)];
        [self.navigationController pushVC:ctrl];
    }
}

- (UITableViewCell *)configCellSection0Row0 {
    static NSString *identifier=@"GainTopCell";
    GainTopCell *cell = (GainTopCell *)[self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[GainTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_hasTopToday) {
        NSArray *arr = [NSArray arrayWithArray:_list[0]];
        if (arr.count>= 3) {
            NSArray *mos = [arr subarrayWithRange:NSMakeRange(0, 3)];
            [cell bindData:mos];
            return cell;
        }
    }
    
    [cell bindData:nil];
    return cell;
}

- (UITableViewCell *)configCellSection:(NSInteger)section row:(NSInteger)row idx:(NSInteger)idx {
    static NSString *identifier=@"GainCell";
    GainCell *cell = (GainCell *)[self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[GainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    GainModel *mo = _list[section][idx];
    [cell bindData:mo idx:idx];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark - init

- (void)createGainBtmView {
    WS(ws);
    CGRect frame = CGRectMake(0, self.view.h_ - LTAutoW(GainBtmViewAllH), self.view.w_, LTAutoW(GainBtmViewAllH));
    self.btmView = [[GainBtmView alloc] initWithFrame:frame];
    [self.view addSubview:_btmView];
    
    _btmView.loginBlock = ^{
    };

    _btmView.showGainBlock = ^{
        MyGainVCtrl *ctrl = [[MyGainVCtrl alloc] init];
        [ws pushVC:ctrl];
    };
}

- (void)createBarPopView {
    self.barPopView = [[BarPopView alloc] initWithFrame:CGRectMake(0, NavBarTop_Lit, self.view.w_, self.view.h_-NavBarTop_Lit)];
    [self.view addSubview:_barPopView];
}


@end
