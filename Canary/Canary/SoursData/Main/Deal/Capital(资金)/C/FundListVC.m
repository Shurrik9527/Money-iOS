//
//  FundListVC.m
//  Canary
//
//  Created by apple on 2018/4/18.
//  Copyright © 2018年 litong. All rights reserved.
//

#import "FundListVC.h"
#import "FundTableViewCell.h"
#import "MJRefresh.h"
#import "DataHundel.h"
#import "postionModel.h"
@interface FundListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,assign) long lastTime ;
@property (nonatomic,assign)long  nowHM;
@property (nonatomic,assign)long   oneMonth;

@end

@implementation FundListVC
- (instancetype)init
{
    self=[super init];
    if (self) {
        self.page = 1;;
        self.dataArray = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTableView];
    [self getDataSource];
    NSNotificationCenter * Center = [NSNotificationCenter defaultCenter];
    [Center addObserver:self selector:@selector(NotificationCenterCommunication:) name:NFC_LocLogin object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getDataSource];
    self.tableView.frame = CGRectMake(0, 0, Screen_width, self.h_);
}

- (void)getDataSource
{
    NSString * nowTime =[LTUtils getNowTimeString];
    _nowHM =[DataHundel getZiFuChuan:nowTime];
    _oneMonth = 30.0 * 24.0 *60.0*60.0 * 1000.0;
     _lastTime = _nowHM -  _oneMonth * self.page;
    NSNumber *longNumber = [NSNumber numberWithLong:_lastTime];
    NSNumber * statNumber =[NSNumber numberWithLong:_nowHM];
    [self networkStartTime:[DataHundel ConvertStrToTime:[statNumber stringValue]] endTime:[DataHundel ConvertStrToTime:[longNumber stringValue]]];
}

-(void)creatTableView
{
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, self.h_) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self addMJHeader];
    [self addMJFooter];

}
-(void)addMJHeader
{
    __weak UIScrollView *scrollView = self.tableView;
    [scrollView addLegendHeaderWithRefreshingBlock:^{
        MJLog(@"进入下拉刷新");
        self.page = 1;
        [self getDataSource];
    }];
}
-(void)addMJFooter
{
    __weak UIScrollView *scrollView = self.tableView;
    [scrollView addLegendFooterWithRefreshingBlock:^{
        self.page += 1;
        [self getDataSource];
    }];
 
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * string  = @"iden";
    FundTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell =[[FundTableViewCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:string];
    }
    postionModel * mode =[_dataArray objectAtIndex:indexPath.row];
    [cell getModel:mode];
    return cell;
}
-(void)networkStartTime :(NSString * )startTime endTime:(NSString *)endTime
{
//    if (notemptyStr([NSUserDefaults objFoKey:MT4ID])) {
//    NSString * urlString = [NSString stringWithFormat:@"%@%@",BasisUrl,@"/trading/records"];
//    NSDictionary * dic = @{@"server":[NSUserDefaults objFoKey:TYPE],@"mt4id":[NSUserDefaults objFoKey:MT4ID],@"startDate":@"01-01-2000 00:00:00",@"endDate":@"01-01-2030 00:00:00"};
//    [[NetworkRequests sharedInstance]GET:urlString dict:dic succeed:^(id data) {
//        [self.tableView.header endRefreshing];
//        [self.tableView.footer endRefreshing];
//        if ([[data objectForKey:@"code"]integerValue] == 0) {
//            self.dataArray =[postionModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"dataObject"]];
//            [self.tableView reloadData];
//        }
//    } failure:^(NSError *error) {
//        [self.tableView.header endRefreshing];
//        [self.tableView.footer endRefreshing];
//    }];
//    }
    if (![LTUser hasLogin]) {
        return;
    }
    
    
    NSString * stringUrl =[NSString stringWithFormat:@"%@%@",BaseUrl,@"/transactionRecord/getList"];
    
    NSDictionary * dic = @{@"loginName":[NSUserDefaults objFoKey:@"loginName"],@"transactionStatus":@(0)};
    
    [[NetworkRequests sharedInstance] SWDPOST:stringUrl dict:dic succeed:^(id resonseObj, BOOL isSuccess, NSString *message) {
        
        NSLog(@"res == %@",resonseObj);
        if (isSuccess) {
                // 刷新
            if (self.dataArray.count > 0) {
                    [self.dataArray removeAllObjects];
                    self.dataArray = [postionModel mj_objectArrayWithKeyValuesArray:resonseObj[@"list"]];
            }else{
                    self.dataArray = [postionModel mj_objectArrayWithKeyValuesArray:resonseObj[@"list"]];
            }
            [self.tableView reloadData];
        }else{
            
        }
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/** 通知回调*/
- (void)NotificationCenterCommunication:(NSNotification*)sender{
    NSLog(@"调用了");
    [self getDataSource];
}

/** 注销通知*/
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NFC_LocLogin object:nil];
}

@end
