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
@interface PositionsVC ()<UITableViewDelegate,UITableViewDataSource,SHFenleiCellDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
//@property (nonatomic,strong)NewPositionCell * postionCell;
@end

@implementation PositionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray =[NSMutableArray array];
    NSNotificationCenter * Center = [NSNotificationCenter defaultCenter];
    [Center addObserver:self selector:@selector(NotificationCenterCommunication:) name:NFC_LocLogin object:nil];
    // UITableView初始化
    [self creatTableViewHeader:YES];
    [self getRequsetType:YES];
    //[self updatasocket];
}
-(void)creatTableViewHeader:(BOOL)hbl
{
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, self.h_ - 158) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = LTBgColor;
    [self.view addSubview:self.tableView];
    
    WS(ws);
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [ws getRequsetType:YES];
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
    NSLog(@"数据源打印:%@ 现在数量:%ld",self.dataArray,self.dataArray.count);
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
    _postionCell.index = 10000+indexPath.row;
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
        NSInteger a =model.volume.doubleValue * 100;
        NSString * vlume =[NSString stringWithFormat:@"%ld",a];
        NSDictionary * dic = @{
                               @"server":[NSUserDefaults objFoKey:TYPE],
                               @"mt4id":[NSUserDefaults objFoKey:MT4ID],
                               @"type":type,
                               @"ticket":model.ticket,
                               @"symbol":model.symbol,
                               @"volume":vlume,
                               @"sl":model.sl,
                               @"tp":model.tp,
                               @"price":@(0),
                               @"expiredDate":@""
                               };
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

-(void)getRequsetType:(BOOL)type
{
    if (notemptyStr([NSUserDefaults objFoKey:MT4ID])) {
    NSString * stringUrl =[NSString stringWithFormat:@"%@%@",BasisUrl,@"/trading/orders"];
    NSDictionary * dic = @{@"server":[NSUserDefaults objFoKey:TYPE],@"mt4id":[NSUserDefaults objFoKey:MT4ID]};
        
    [[NetworkRequests sharedInstance]GET:stringUrl dict:dic succeed:^(id data) {
        
        if ([[data objectForKey:@"code"]integerValue] == 0) {
            NSLog(@"持仓数据打印%@", data);
            
            if (type == YES) {
                // 刷新
                if (self.dataArray.count > 0) {
                    [self.dataArray removeAllObjects];
                    self.dataArray =[postionModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"dataObject"]];
                }else{
                    self.dataArray =[postionModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"dataObject"]];
                }
            }
            [self.tableView reloadData];
        }
        [self.tableView.header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
    }
}
-(void)netWork :(NSDictionary *)dic CellNumder:(NSIndexPath *)numder
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",BasisUrl,@"/trading/execute"];
    
    [[NetworkRequests sharedInstance]POST:urlString dict:dic succeed:^(id data) {
        
//        NSLog(@"平仓网络请求:%@",data);
        if ([[data objectForKey:@"code"]integerValue] == 0) {
            
            WS(ws)
            [self.view showTip:@"平仓成功"];
            [ws.dataArray removeObjectAtIndex:numder.row];
            if (self.dataArray.count == 0) { // 要根据情况直接删除section或者仅仅删除row
             //   [ws.tableView deleteSections:[NSIndexSet indexSetWithIndex:numder.section] withRowAnimation:UITableViewRowAnimationFade];
            } else {
                [ws.tableView deleteRowsAtIndexPaths:@[numder] withRowAnimation:UITableViewRowAnimationFade];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self getRequsetType:YES];
            });
        }else
        {
            [LTAlertView alertMessage:[DataHundel messageObjetCode:[[data objectForKey:@"code"]integerValue]]];
        }
    } failure:^(NSError *error) {
        NSLog(@"平仓网络请求错误:%@",error);
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
    [self getRequsetType:YES];
}

/** 注销通知*/
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NFC_LocLogin object:nil];
}

@end
