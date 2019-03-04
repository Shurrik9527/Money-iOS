//
//  PutupListVC.m
//  Canary
//
//  Created by 孙武东 on 2019/2/15.
//  Copyright © 2019 litong. All rights reserved.
//

#import "PutupListVC.h"
#import "FundTableViewCell.h"
#import "MJRefresh.h"
#import "DataHundel.h"
#import "postionModel.h"
#import "PutUpCell.h"
@interface PutupListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,assign) long lastTime ;
@property (nonatomic,assign)long  nowHM;
@property (nonatomic,assign)long   oneMonth;


@end

@implementation PutupListVC

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
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, self.h_) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PutUpCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([PutUpCell class])];
    
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
    return 170;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString * string  = @"iden";
    PutUpCell * cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PutUpCell class]) forIndexPath:indexPath];
//    if (!cell) {
//        cell =[[FundTableViewCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:string];
//    }
    postionModel * mode =[_dataArray objectAtIndex:indexPath.row];
    cell.model = mode;
    WS(ws)
    cell.cancelBlock = ^{
        [ws cancelNetWorkatIndex:indexPath.row type:@"" RowIndex:indexPath];
    };
//    [cell getModel:mode];
    return cell;
}

- (void)cancelNetWorkatIndex:(NSInteger)index type:(NSString *)type RowIndex:(NSIndexPath *)row{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请确定是否撤销?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"qvxiao");
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        NSInteger numder = index - 10000;
        postionModel * model =[self.dataArray objectAtIndex:numder];
        
        NSMutableDictionary * dic = [@{
                                       @"loginName":[NSUserDefaults objFoKey:@"loginName"],
                                       @"transactionStatus":@(2),
                                       @"symbolCode":model.symbolCode,
                                       @"ransactionType":@(model.ransactionType),
                                       @"unitPrice":@(model.unitPrice),
                                       @"lot":@(model.lot),
                                       @"id":@([model.id integerValue]),
                                       } mutableCopy];
        NSLog(@"dic === %@",dic);
        NSString *sign = [NSString stringWithFormat:@"id:%@,loginName:%@,lot:%@,ransactionType:%@,symbolCode:%@,transactionStatus:2,unitPrice:%@,url:/transaction/sell",model.id,[NSUserDefaults objFoKey:@"loginName"],@(model.lot),@(model.ransactionType),model.symbolCode,@(model.unitPrice)];
        NSLog(@"json === %@",sign);
        
        
//        sign = [[JWTHundel shareHundle] getRSAKEY:sign];
//
//        [dic setObject:sign forKey:@"sign"];
//
//        [self netWork:dic CellNumder:row];
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)networkStartTime :(NSString * )startTime endTime:(NSString *)endTime
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
    
    NSDictionary * dic = @{@"loginName":[NSUserDefaults objFoKey:@"loginName"],@"transactionStatus":@(3)};
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
