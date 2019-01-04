//
//  InGodViewController.m
//  Canary
//
//  Created by apple on 2018/4/18.
//  Copyright © 2018年 litong. All rights reserved.
//

#import "InGodViewController.h"
#import "MJRefresh.h"
#import "DataHundel.h"
#import "OutInGodTableViewCell.h"
#import "INModel.h"
@interface InGodViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,assign)NSInteger page;
@end

@implementation InGodViewController

-(instancetype)init
{
    self=[super init];
    if (self) {
        self.page = 0;
        self.dataArray = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTableView];
    [self dataSource];
    NSNotificationCenter * Center = [NSNotificationCenter defaultCenter];
    [Center addObserver:self selector:@selector(NotificationCenterCommunication:) name:NFC_LocLogin object:nil];
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
    [self.tableView.header endRefreshing];
    
}
-(void)addMJHeader
{
    __weak UIScrollView *scrollView = self.tableView;
    [scrollView addLegendHeaderWithRefreshingBlock:^{
        MJLog(@"进入下拉刷新");
        self.page = 1;
        [self dataSource];
    }];
}
-(void)addMJFooter
{
    __weak UIScrollView *scrollView = self.tableView;
    [scrollView addLegendFooterWithRefreshingBlock:^{
        self.page += 1;
        [self dataSource];
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
    OutInGodTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell =[[OutInGodTableViewCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:string];
    }
    INModel * mode =[self.dataArray objectAtIndex:indexPath.row];
    cell.PayLabel.text = @"充值";
    if ([mode.status isEqualToString:@"SUCCESS"]) {
        cell.messageLabel.text = @"支付成功";
    }else
    {
        cell.messageLabel.text = @" 等待支付";
    }

    cell.dataLabel.text = [DataHundel convertime:mode.date];
    cell.priceLabel.textColor = LTKLineRed;
    cell.priceLabel.text = [NSString stringWithFormat:@"%@%.2f",@"$",mode.amount.floatValue];
    return cell;
}
-(void)dataSource
{
    if (notemptyStr([NSUserDefaults objFoKey:MT4ID])) {
    NSString * urlString = [NSString stringWithFormat:@"%@%@",BasisUrl,@"/payment/records"];
    NSDictionary * dic = @{@"server":[NSUserDefaults objFoKey:TYPE],@"mt4id":[NSUserDefaults objFoKey:MT4ID],@"startDate":@"09-12-1970 12:12:12",@"endDate":@"09-12-2990 12:12:12",@"pageNumber":[NSString stringWithFormat:@"%ld",self.page],@"pageSize":@"20"};
    [[NetworkRequests sharedInstance]GET:urlString dict:dic succeed:^(id data) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if ([[data objectForKey:@"code"]integerValue] == 0) {
            NSMutableDictionary * dic =[data objectForKey:@"dataObject"];
            NSMutableArray * array =[dic objectForKey:@"content"];
            self.dataArray =[INModel mj_objectArrayWithKeyValuesArray:array];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/** 通知回调*/
- (void)NotificationCenterCommunication:(NSNotification*)sender{
    NSLog(@"调用了");
    [self dataSource];
}

/** 注销通知*/
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NFC_LocLogin object:nil];
}

@end
