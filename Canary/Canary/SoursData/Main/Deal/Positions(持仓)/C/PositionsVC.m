//
//  PositionsVC.m
//  Canary
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 litong. All rights reserved.
//

#import "PositionsVC.h"
#import "NetworkRequests.h"
#import "PostionCell.h"
#import "NewPositionCell.h"
#import "postionModel.h"
#import "AsSocket.h"
#import "SocketModel.h"
#import "MJRefresh.h"
#import "DataHundel.h"
#import "JWTHundel.h"
@interface PositionsVC ()<UITableViewDelegate,UITableViewDataSource,SHFenleiCellDelegate>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArray;

@property (nonatomic, strong)NSTimer *timer;

@end

@implementation PositionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray =[NSMutableArray array];
    NSNotificationCenter * Center = [NSNotificationCenter defaultCenter];
    [Center addObserver:self selector:@selector(NotificationCenterCommunication:) name:NFC_LocLogin object:nil];
    // UITableView初始化
    [self creatTableViewHeader:YES];
    [self getRequsetType];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getRequsetType];
    [self createTimer];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeTimer];
}

- (void)createTimer{
    
    if (!self.timer) {
        
        self.timer = [NSTimer timerWithTimeInterval:10 target:self selector:@selector(getRequsetType) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        
    }
    
}

- (void)removeTimer{
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
}

- (void)creatTableViewHeader:(BOOL)hbl
{
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, self.h_ - 158) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = LTBgColor;
    [self.view addSubview:self.tableView];
    
    WS(ws);
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [ws getRequsetType];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width , 5)];
    return view;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * string  = @"iden";
    NewPositionCell * _postionCell =[tableView dequeueReusableCellWithIdentifier:string];
    if (!_postionCell) {
        _postionCell =[[NewPositionCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:string];
        [_postionCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    postionModel * model =[self.dataArray objectAtIndex:indexPath.row];
    _postionCell.model = model;
    _postionCell.delegate = self;
    _postionCell.index = 10000 + indexPath.row;
    _postionCell.goodsViewTouchBlock = ^(UIButton *button, NSInteger index, NSString *type) {
        [self PingChangNetWorkatIndex:index type:type RowIndex:indexPath];
    };
    return _postionCell;
}

#pragma mark 平仓按钮点击代理事件
// 平仓网络请求
- (void)PingChangNetWorkatIndex:(NSInteger)index type:(NSString *)type RowIndex:(NSIndexPath *)row{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请确定是否平仓?" preferredStyle:UIAlertControllerStyleAlert];
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

        
        sign = [[JWTHundel shareHundle] getRSAKEY:sign];
        
        [dic setObject:sign forKey:@"sign"];
        
        [self netWork:dic CellNumder:row];
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark 平仓代理点击方法
- (void)didQueRenBtn:(UIButton *)button atIndex:(NSInteger)index type:(NSString *)type
{
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)getRequsetType
{
    
    if (![LTUser hasLogin]) {
        return;
    }
    
    NSString * stringUrl =[NSString stringWithFormat:@"%@%@",BaseUrl,@"/transactionRecord/getList"];
    
    NSDictionary * dic = @{@"loginName":[NSUserDefaults objFoKey:@"loginName"],@"transactionStatus":@(1)};
    
    [[NetworkRequests sharedInstance] SWDPOST:stringUrl dict:dic succeed:^(id resonseObj, BOOL isSuccess, NSString *message) {
        
        NSLog(@"res == %@",resonseObj);
        if (isSuccess) {

                self.dataArray = [postionModel mj_objectArrayWithKeyValuesArray:resonseObj[@"list"]];
                
            CGFloat totalProfit = 0;
            CGFloat totalPosition = 0;

                for (postionModel *model in self.dataArray) {
                    
                    if (model.ransactionType == 1) {
                        //买涨

                        CGFloat profit = model.presentPrice / model.exponent * model.unitPrice * model.lot;

                        if (profit - model.unitPrice * model.lot < 0) {
                            model.profit = (profit - model.unitPrice * model.lot) * -1;
                        }else{
                            model.profit = profit - model.unitPrice * model.lot;
                        }
                        totalProfit += model.profit;
                        totalPosition += profit;
                    }else{
                        CGFloat profit = model.presentPrice / model.exponent * model.unitPrice * model.lot;
                        if (profit - model.unitPrice * model.lot > 0) {
                            model.profit = (profit - model.unitPrice * model.lot) * -1;
                        }else{
                            model.profit = profit - model.unitPrice * model.lot;
                        }
                        totalProfit += model.profit;
                        totalPosition += profit;

                    }
                    
                
                NSLog(@"proft === %f",totalProfit);
                    
                [[NSNotificationCenter defaultCenter] postNotificationName:NFC_ReloadProfit  object:@{@"profit":@(totalProfit),@"position":@(totalPosition)}];

                
                
            }
            [self.tableView reloadData];
        }else{
            
        }
        [self.tableView.header endRefreshing];

    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        
        
    }];
    
//    }
}
-(void)netWork :(NSDictionary *)dic CellNumder:(NSIndexPath *)numder
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",BaseUrl,@"/transaction/sell"];
    WS(ws)
    [[NetworkRequests sharedInstance] SWDPOST:urlString dict:dic succeed:^(id resonseObj, BOOL isSuccess, NSString *message) {
        NSLog(@"res ===== %@",resonseObj);
        if (resonseObj) {
            
         
            [self.view showTip:@"平仓成功"];
            [ws.dataArray removeObjectAtIndex:numder.row];

            [ws.tableView deleteRowsAtIndexPaths:@[numder] withRowAnimation:UITableViewRowAnimationFade];

            
            
        }else{
            
            [ws.view showTip:message];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    

    
}

//-(void)updatasocket
//{
//    [[AsSocket shareDataAsSocket]setReturnValueBlock:^(NSMutableArray *socketArray) {
//        if (self.dataArray.count > 0 && socketArray.count > 0) {
//            for (SocketModel * sockModel in socketArray) {
//                for (int i = 0; i < self.dataArray.count; i ++) {
//                    postionModel * postionmodel =[self.dataArray objectAtIndex:i];
//                    if ([postionmodel.symbol isEqualToString:sockModel.symbol]) {
//                        postionmodel.price_out = sockModel.buy_out;
//                        postionmodel.price_in = sockModel.buy_in;
//                        [self.tableView reloadData];
//                    }
//                }
//            }
//        }    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


/** 通知回调*/
- (void)NotificationCenterCommunication:(NSNotification*)sender{
    NSLog(@"调用了");
    [self getRequsetType];
}

/** 注销通知*/
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NFC_LocLogin object:nil];
}

@end
