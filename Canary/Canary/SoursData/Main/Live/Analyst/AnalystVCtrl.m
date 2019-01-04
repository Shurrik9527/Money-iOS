//
//  AnalystVCtrl.m
//  ixit
//
//  Created by litong on 2017/3/29.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "AnalystVCtrl.h"
#import "Masonry.h"
#import "AnalystScheduleCell.h"

#define kLiveTimesHeadViewH     LTAutoW(59)

#if useThreeLive
    #import "AnalystView.h"
#else
    #import "AnalystView0.h"
#endif

/** 分析师 */
@interface AnalystVCtrl ()

@property(strong, nonatomic) NSArray * liveTimes;
@property (nonatomic,strong) AnalystMO *analystMO;

@property (nonatomic,strong) UIView *tableHeadView;
#if useThreeLive
@property (nonatomic,strong) AnalystView *analystView;
#else
@property (nonatomic,strong) AnalystView0 *analystView;
#endif

@property (nonatomic,strong) UIView *liveTimesHeadView;


@end

@implementation AnalystVCtrl


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableViewWithHeader];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(@0);
    }];
    self.tableView.tableHeaderView = self.tableHeadView;
    
    UIView *tableFootView = [[UIView alloc] init];
    tableFootView.frame = CGRectMake(0, 0, ScreenW_Lit, LTAutoW(20));
    tableFootView.backgroundColor = LTWhiteColor;
    self.tableView.tableFooterView = tableFootView;
    
    [self.tableView.header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)dealloc {
    NSLog(@"AnalystVCtrl dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request

- (void)loadData {
    WS(ws);
    [RequestCenter reqLiveAuthorInfo:_liveModel.authorId finish:^(LTResponse *res) {
        [ws endHeadOrFootRef];
        if (res.success) {
            [ws configTableHeadView:res.resDict];
        }
    }];
}

- (void)configTableHeadView:(NSDictionary *)dict {
    self.analystMO = [AnalystMO objWithDict:dict];
    [self.analystView configViewWithAnalystMO:self.analystMO];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.liveTimes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier=@"AnalystScheduleCell";
    AnalystScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AnalystScheduleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSInteger row = indexPath.row;
    LiveTimeMo *model = self.liveTimes[row];
    [cell bindData:model row:row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LTAutoW(kAnalystScheduleCellH);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSInteger row = indexPath.row;
//    LiveTimeMo *model = self.liveTimes[row];

}


#pragma mark  - 属性


- (void)setLiveModel:(LiveMO *)liveModel {
    _liveModel = liveModel;
    self.liveTimes = _liveModel.liveTimeList_fmt;
}


- (UIView *)tableHeadView {
    if (!_tableHeadView) {
#if useThreeLive
        _tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW_Lit, (LTAutoW(16)+kAnalystViewH)+kLiveTimesHeadViewH)];
        _tableHeadView.backgroundColor = [AnalystView darkBgColor:NO];
#else
        _tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW_Lit, (kAnalystViewH)+kLiveTimesHeadViewH)];
        _tableHeadView.backgroundColor = LTColorHex(0xF8FAFF);
#endif

        [_tableHeadView addSubview:self.analystView];
        [_tableHeadView addSubview:self.liveTimesHeadView];
    }
    return _tableHeadView;
}



#if useThreeLive
- (AnalystView *)analystView {
    if (!_analystView) {
        CGRect rect = CGRectMake(0, LTAutoW(16), ScreenW_Lit, kAnalystViewH);
        _analystView = [[AnalystView alloc] initWithFrame:rect];
        [_analystView configViewWithLiveMO:_liveModel];
    }
    return _analystView;
}
#else
- (AnalystView0 *)analystView {
    if (!_analystView) {
        _analystView = [[AnalystView0 alloc] initWithFrame:CGRectZero];
        [_analystView configViewWithLiveMO:_liveModel];
    }
    return _analystView;
}

#endif

- (UIView *)liveTimesHeadView {
    if (!_liveTimesHeadView) {
#if useThreeLive
        CGFloat yy = LTAutoW(16);
#else
        CGFloat yy = 0;
#endif
        
        _liveTimesHeadView = [[UIView alloc] init];
        _liveTimesHeadView.frame = CGRectMake(0, yy + kAnalystViewH, ScreenW_Lit, kLiveTimesHeadViewH);
        _liveTimesHeadView.backgroundColor = LTWhiteColor;
        
        UILabel *lab = [[UILabel alloc] init];
        lab.frame = CGRectMake(LTAutoW(16), LTAutoW(24), LTAutoW(200), LTAutoW(17));
        lab.font = autoFontSiz(17);
        lab.text = @"直播时间表";
        lab.textColor = LTTitleColor;
        [_liveTimesHeadView addSubview:lab];
        
        CGFloat lineh = LTAutoW(2);
        UIView *line = [UIView lineFrame:CGRectMake(lab.x_, kLiveTimesHeadViewH - lineh, LTAutoW(24), lineh) color:LTTitleColor];
        [_liveTimesHeadView addSubview:line];
    }
    return _liveTimesHeadView;
}



@end
