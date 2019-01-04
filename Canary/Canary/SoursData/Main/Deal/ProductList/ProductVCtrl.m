//
//  ProductVCtrl.m
//  Canary
//
//  Created by Brain on 2017/5/17.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "ProductVCtrl.h"
#import "Masonry.h"
#import "LTUser.h"
#import "ProductCell.h"
#import "BuyView.h"
#import "InputPwdVCtrl.h"
#import "WeiPanMarketViewController.h"

@interface ProductVCtrl ()

@property(strong,nonatomic)NSMutableArray * datas;
@property (nonatomic,strong) BuyView *buyView;

/** 产品列轮询timer */
@property (nonatomic,strong) NSTimer *productsTimer;
@property(copy,nonatomic)NSString * curCodes;//当前codes

@property (nonatomic,strong) UIView *tableHeaderView;

@end

@implementation ProductVCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datas = [NSMutableArray array];
    
    [self createTableViewWithHeader];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(@0);
    }];
    [self.tableView.header beginRefreshing];
    [self createTableHeaderView];
}

- (void)dealloc {
    NFC_RemoveAllObserver;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_datas.count==0) {
        [self loadDataNoError];
    }else{
        [self sendSocket];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


#pragma mark  - TableHeaderView

- (void)createTableHeaderView {
    self.tableHeaderView = [[UIView alloc] init];
    _tableHeaderView.frame = CGRectMake(0, 0, ScreenW_Lit, 0);
    self.tableView.tableHeaderView = _tableHeaderView;
}

- (void)showWarningAddHeader:(BOOL)bl {
    CGFloat h = bl ? 40 : 0;
    [_tableHeaderView setSH:h];
    [self.tableView reloadData];
}

#pragma mark - request

- (void)loadData {
    [self loadDataWithError:YES];
}

- (void)loadDataNoError {
    [self loadDataWithError:NO];
}

- (void)loadDataWithError:(BOOL)bl {
    WS(ws);
    [RequestCenter reqProductList:^(LTResponse *res) {
        if (res.success) {
            NSArray *arr = [ProductMO objsWithList:res.resArr];
            NSArray *list = [NSArray arrayWithArray:arr];
            [ws conifgRes:list];
        } else {
            if (bl) {
                [ws.tableView showTip:res.message];
            }
        }
        [ws endHeadOrFootRef];
    }];
}

- (void)conifgRes:(NSArray *)list {
    if (list.count > 0) {
        [self.datas removeAllObjects];
        [self.datas addObjectsFromArray:list];
        [self.tableView reloadData];
        _curCodes=@"";
        for (int i = 0; i<list.count; i++) {
            ProductMO *mo = list[i];
            NSString *code=[NSString stringWithFormat:@"%@|%@",mo.excode,mo.code];
            if (i!=0) {
                code=[@"," stringByAppendingString:code];
            }
            _curCodes = [_curCodes stringByAppendingString:code];
        }
        NSLog(@"product_curCodes=%@",_curCodes);
        [self addNFC];
        [self sendSocket];//开启socket
        if (!_buyView.hidden) {
        }
    }
}

////产品轮询
//- (void)pollingProducts {
//    [self canclePollingProducts];
//    
//    WS(ws);
//    NSLog(@"---1----产品轮询开启----1---");
//    self.productsTimer = [NSTimer scheduledTimerWithTimeInterval:2.f target:ws selector:@selector(loadDataNoError) userInfo:nil repeats:YES];
//}
//
////取消产品轮询
//- (void)canclePollingProducts {
//    if (self.productsTimer) {
//        NSLog(@"----0---产品轮询关闭----0---");
//        [self.productsTimer setFireDate:[NSDate distantFuture]];
//        [self.productsTimer invalidate];
//        self.productsTimer = nil;
//    }
//}


-(void)rechargeAlert{
    WS(ws);
    [LTAlertView alertTitle:nil message:@"余额不足" sureTitle:@"入金" sureAction:^{
        [ws.buyView showView:NO];
        NFC_PostName(NFC_PushRecharge);
    } cancelTitle:@"取消"];
}
#pragma mark - socket
-(void)addNFC{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateQuotations:) name:NFC_SocketUpdateQuotations object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateQuotationsError:) name:NFC_SocketUpdateQuotationsFailure object:nil];
}
-(void)sendSocket{
    [LTSocketServe sendRTC:_curCodes];
}
//长连接更新数据
- (void)updateQuotations:(NSNotification *)obj {
    NSArray *arr = obj.object;
    NSMutableArray *objs = [NSMutableArray array];
    for (NSDictionary *dict in arr) {
        BOOL bl = [dict boolFoKey:@"success"];
        NSString *type = [dict stringFoKey:@"type"];
        if (bl && [type isEqualToString:kResQP]) {
            NSDictionary *dic = [dict dictionaryFoKey:@"data"];
            Quotation *item = [Quotation objWithDic:dic];
            [objs addObject:item];
        }
    }
    [self reloadDataWithArr:objs];
}

- (void)updateQuotationsError:(NSNotification *)obj {
    //    NSLog(@"home updateQuotationsError...");
    NSArray *arr = obj.object;
    for (NSDictionary *dict in arr) {
        BOOL bl = [dict boolFoKey:@"success"];
        NSString *type = [dict stringFoKey:@"type"];
        if (!bl && [type isEqualToString:kResQP]) {
            [LTSocketServe sendRTC:_curCodes];
        }
    }
}

-(void)reloadDataWithArr:(NSArray *)arr {
    if (!arr) {
        return;
    }
    for (int j=0; j<arr.count; j++) {
        Quotation *item=arr[j];
        NSString *code1=item.code;
        if (!notemptyStr(code1)) {
            NSLog(@"nil code1");
            continue;
        }
        if ([_curCodes containsString:code1]) {
            for (int i=0; i<_datas.count; i++) {
                ProductMO *m=_datas[i];
                NSString *code = m.code;
                if ([code isEqualToString:code1]) {
                    m.buy=item.buy;
                    m.sell=item.out_price;
                    [_datas replaceObjectAtIndex:i withObject:m];
                    [self.tableView reloadData];
                    break;
                }
            }
        }
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ProductCellID";
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSInteger row = indexPath.row;
    ProductMO *mo = _datas[row];
    [cell bindData:mo];
    
    return cell;
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ProductCell cellH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    ProductMO *mo = _datas[row];
    
    ProductCell *cell = (ProductCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell questionBgAction];
    
    BaseVCtrl *vc = [self findBaseVC];
    WeiPanMarketViewController *ctrl = [[WeiPanMarketViewController alloc] initWithCode:mo.code exCode:mo.excode title:mo.name ];
    [vc pushVC:ctrl];
}





@end
