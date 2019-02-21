//
//  MarketVCtrl.m
//  Canary
//
//  Created by litong on 2017/5/8.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "MarketVCtrl.h"
#import "OptionalTableView.h"
#import "HomeTableViewCell.h"
#import "MJRefresh.h"
#import "LoginVCtrl.h"
#import "WeiPanMarketViewController.h"
#import "NetworkRequests.h"
#import "DataHundel.h"
#import "SocketModel.h"

#import "JMColumnMenu.h"
#import "UIView+JM.h"
#import "JMConfig.h"

#import "BuySellingModel.h"
#import "WebSocket.h"


#define kSectionHeight 40
#define kProductScrollViewH 44


@interface MarketVCtrl ()<UITableViewDelegate,UITableViewDataSource,JMColumnMenuDelegate> {
#pragma mark 商品种类摁钮 tag
    NSInteger _proBtnTag;
}
/** menuView */
@property (nonatomic, strong) JMColumnMenu *menu;
@property (nonatomic,strong) OptionalTableView *marketTable;//行情表table

@property (nonatomic,strong) UIScrollView *productScrollView;
@property (nonatomic,strong) NSArray *productTypes;
@property (nonatomic,strong) UIView  *line;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIView *sectionView;
@property (nonatomic,strong) UIView *sectionViewTopBlueLine;
@property(strong,nonatomic)UIButton * currentTypeBtn;//记录最后一个按钮

@property (nonatomic,assign)NSInteger buttonTag;

@property (nonatomic,strong)NSMutableArray *myTagsArrM;
@property (nonatomic,strong)NSMutableArray *otherArrM;

@property(nonatomic,strong)NSMutableDictionary *allGoodsDic;
@property(nonatomic,strong)NSMutableArray *allGoodsArray;
@property(nonatomic,assign)NSInteger selectHeaderType;
@property(nonatomic,assign)BOOL reloadView;


@property(nonatomic,strong)NSMutableDictionary *allGoodsSocketDic;
@property(nonatomic,strong)NSMutableDictionary *zxGoodsSocketDic;


@end

@implementation MarketVCtrl
- (void)viewDidLoad {
    [super viewDidLoad];
    [self navTitle:@"行情"];
    
    [self createProductListButtons];//创建产品列表

    [self requestTest];
    [self getAllGoods];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getAllGoods];
    self.reloadView = YES;
    [self getWebScoketData];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.reloadView = NO;
}

- (void)getWebScoketData{
    
    
    
    WS(ws)
    [[WebSocket shareDataAsSocket] setReturnValueBlock:^(SocketModel * _Nonnull socketModel) {
//        NSLog(@"code == %@",socketModel.symbolCode);
        
//        dispatch_async(queue, ^{

//        });
        if ([ws.zxGoodsSocketDic.allKeys containsObject:socketModel.symbolCode]) {
            
            NSDictionary *dic = ws.zxGoodsSocketDic[socketModel.symbolCode];
            NSMutableArray *array = [ws.allGoodsDic objectForKey:@"zx"];
            NSInteger index = [dic[@"index"] integerValue];
            BuySellingModel *model = [array objectAtIndex:index];
            model.price = socketModel.price;
            
            if (ws.selectHeaderType == 0) {
                
                NSLog(@"----------------------");
                NSLog(@"code === %@",socketModel.symbolCode);
                NSLog(@"price === %@",socketModel.price);
                NSLog(@"index === %ld",index);
                NSLog(@"dic === %@",dic);
                NSLog(@"----------------------");
                
                
                [ws.marketTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                
            }

        }
        
        if ([ws.allGoodsSocketDic.allKeys containsObject:socketModel.symbolCode]) {
            
            NSDictionary *dic = ws.allGoodsSocketDic[socketModel.symbolCode];
            NSMutableArray *array = [ws.allGoodsDic objectForKey:dic[@"type"]];
            NSInteger index = [dic[@"index"] integerValue];
            BuySellingModel *model = [array objectAtIndex:index];
            model.price = socketModel.price;
            
            NSInteger selectHeaderType = [dic[@"type"] isEqualToString:@"zx"] ?  0 :[dic[@"type"] isEqualToString:@"wh"] ?  1 :[dic[@"type"] isEqualToString:@"gjs"] ?  2 :[dic[@"type"] isEqualToString:@"yy"] ?  3 : 0;
            
            if (ws.selectHeaderType == selectHeaderType) {
                
                
                NSString *key = self.selectHeaderType == 0 ? @"zx" : self.selectHeaderType == 1 ? @"wh": self.selectHeaderType == 2 ? @"gjs": self.selectHeaderType == 3 ? @"yy":@"zx";
                
                NSInteger count = [self.allGoodsDic[key] count];


                if (index < count) {
                    [ws.marketTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                }
                
                
            }
            
        }
        
        
    }];
    
}

#pragma mark - init
//创建头部交易所bar
- (void)createProductListButtons {
    if (_productScrollView) {
        return;
    }
    //创建品种bar
    int i = -1;
    CGFloat x = 16;
    CGFloat y = 64;
    CGFloat w = 70;
    CGFloat h = kProductScrollViewH;
    _productScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,y, self.w_, h)];
    _productScrollView.backgroundColor = [UIColor whiteColor];
    _productScrollView.showsHorizontalScrollIndicator = NO;
    _productScrollView.scrollEnabled = NO;
    [self.view addSubview:_productScrollView];
     _productTypes = @[@"自选",@"外汇",@"贵金属",@"原油"];
    for (NSString * name in _productTypes) {
        NSString *btnTitle=name;
        UIButton *bt= [UIButton buttonWithType:UIButtonTypeCustom];
        bt.frame = CGRectMake(x, 0, w, h) ;
        [bt setTitle:btnTitle forState:UIControlStateNormal];
        [bt setTitleColor:LTSubTitleRGB forState:UIControlStateNormal];
        bt.titleLabel.font = fontSiz(midFontSize);
        [bt addTarget:self action:@selector(clickMarketTypeButtons:) forControlEvents:UIControlEventTouchUpInside];
//        [bt sizeToFit];
//        bt.frame = CGRectMake(x, 0, bt.w_+10, h);
        bt.frame = CGRectMake(Screen_width / 4 * (i + 1), 0, Screen_width / 4, h);
        bt.tag = i+1;
        [_productScrollView addSubview:bt];
        x += bt.w_+15;
        bt = nil;
        i++;
    }
    
    _productScrollView.contentSize = CGSizeMake(x, h);
    UIButton *firstButton = (UIButton*)_productScrollView.subviews.firstObject;
    [firstButton setTitleColor:LTTitleRGB forState:UIControlStateNormal];
    _currentTypeBtn=firstButton;
    
    //移动蓝色标签
    _line = [[UIView alloc] initWithFrame:CGRectMake(firstButton.center.x-5, _productScrollView.frame.size.height-2, 10, 2)];
    _line.backgroundColor = BlueFont;
    [_productScrollView addSubview:_line];
    
    //底部线条
    CGRect bottomFrame=CGRectMake(0, _productScrollView.h_-0.5, _bottomView.w_, 0.5);
    UIView *line=[[UIView alloc]init];
    line.frame=bottomFrame;
    line.backgroundColor=LTLineColor;
    [_productScrollView addSubview:line];
    //创建底部的table显示各种行情
    [self addMarketTableView];
}

#pragma mark - tableView
- (void)addMarketTableView {
    if(!_marketTable) {
        //初始化 添加 表头
        [self addSectionView];
        CGFloat y = _sectionView.yh_;//表头高度
        CGRect rect = CGRectMake(0, y, self.w_, ScreenH_Lit-NavAndTabBarH_Lit- kProductScrollViewH-kSectionHeight);
        _marketTable = [[OptionalTableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _marketTable.delegate = self;
        _marketTable.dataSource = self;
        [self.view addSubview:_marketTable];
        WS(ws);
        _marketTable.clickAddButtonBlock = ^(OptionalTableView *tableview){
            if ([ws checkLocHasLogin:@"添加自选需要登录后才能使用!"]) {
                [ws clickAddButton];
            }
        };
        [self addMJHeader];
    }
}
//添加自选
-(void)clickAddButton{
 
    NSMutableArray *myTagArr = [NSMutableArray array];
    NSMutableArray *otherArr = [NSMutableArray array];
    NSMutableArray *myTagCodeArr = [NSMutableArray array];

    for (BuySellingModel *model in self.allGoodsDic[@"zx"]) {
        NSDictionary *dic = @{@"title_cn":model.symbolName,@"title":model.symbolCode};
        [myTagArr addObject:dic];
        [myTagCodeArr addObject:model.symbolCode];

    }
    
    for (BuySellingModel *model in self.allGoodsArray) {
        
        if (![myTagCodeArr containsObject:model.symbolCode]) {
            NSDictionary *dic = @{@"title_cn":model.symbolName,@"title":model.symbolCode};
            [otherArr addObject:dic];
        }
    }
    
    _myTagsArrM = myTagArr;
    _otherArrM = otherArr;
    
    JMColumnMenu *menuVC = [JMColumnMenu columnMenuWithTagsArrM:_myTagsArrM OtherArrM:_otherArrM Type:JMColumnMenuTypeTencent Delegate:self];
    [self presentViewController:menuVC animated:YES completion:nil];
    
}
//行情表头 （品种代码，买入价，涨跌幅）
-(void)addSectionView{
    //    int fontsize = 15;
    CGFloat w = (Screen_width) / 3.0;
    CGFloat y = _productScrollView.yh_;
    _sectionViewTopBlueLine =[[UIView alloc] initWithFrame:CGRectMake(0, y+0.5, self.view.w_, 0.5)];
    _sectionViewTopBlueLine.backgroundColor = LTBgRGB;
    [self.view addSubview:_sectionViewTopBlueLine];
    
    _sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, y+1, self.view.w_, kSectionHeight)];
    _sectionView.backgroundColor = LTBgRGB;
    [self.view addSubview:_sectionView];
    // 名称
    UILabel *nameLab = [[DataHundel shareDataHundle] createLabWithFrame:CGRectMake(0, 0, w, kSectionHeight) text:@"品种代码" fontsize:midFontSize];
    nameLab.textAlignment = NSTextAlignmentCenter;
    [_sectionView addSubview:nameLab];
    nameLab = nil;
    // 最新价
    UILabel *priceLab = [[DataHundel shareDataHundle] createLabWithFrame:CGRectMake(w, 0, w, kSectionHeight) text:@"买入价" fontsize:midFontSize];
    [_sectionView addSubview:priceLab];
    priceLab = nil;
    
//    UILabel * buyOutLab =[[DataHundel shareDataHundle]createLabWithFrame:CGRectMake(w*2 , 0, w, kSectionHeight) text:@"卖出价" fontsize:midFontSize];
//    [_sectionView addSubview:buyOutLab];
//    buyOutLab = nil;
    // 涨跌幅
    UIButton * selectBut = [UIButton buttonWithType:(UIButtonTypeCustom)];
    selectBut.frame = CGRectMake(w * 2, 0, w, kSectionHeight);
    selectBut.titleLabel.font = [UIFont systemFontOfSize:midFontSize];
    [selectBut setTitleColor:LTSubTitleRGB forState:(UIControlStateNormal)];
     [selectBut setTitle:@"涨跌幅" forState:(UIControlStateNormal)];
    [_sectionView addSubview:selectBut];
}

#pragma mark - 获取自选列表
-(void)requestTest
{
    
//    [self showLoadingView];
    NSString * url = [NSString stringWithFormat:@"%@%@",BaseUrl,@"/userSymbol/getList"];
    NSMutableDictionary * dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"DEMO",@"server",nil];
    
    [[NetworkRequests sharedInstance] SWDPOST:url dict:dic succeed:^(id resonseObj, BOOL isSuccess, NSString *message) {
        NSLog(@"res ==== %@",resonseObj);
        if (isSuccess) {

            NSArray *data = [BuySellingModel mj_objectArrayWithKeyValuesArray:resonseObj[@"list"]];
            
            NSMutableDictionary *socketDic = [NSMutableDictionary dictionary];
            
            for (int i = 0; i < data.count; i++) {
                
                BuySellingModel *model = data[i];
                if (model.symbolCode.length == 0) {
                    continue;
                }
                [socketDic setObject:@{@"type":@"wh",@"index":@(i)} forKey:model.symbolCode];
            }
            
            self.zxGoodsSocketDic = socketDic;
            self.allGoodsDic[@"zx"] = data;

        }
        [self.marketTable.header endRefreshing];
        [self.marketTable reloadData];
        [self hideLoadingView];
    } failure:^(NSError *error) {
        [self.marketTable.header endEditing:YES];
        [self hideLoadingView];
        
    }];
  

}

- (void)getAllGoods{
    
    NSString * url = [NSString stringWithFormat:@"%@%@",BaseUrl,@"/symbolInfo/getList"];
    WS(ws)
    [[NetworkRequests sharedInstance] SWDPOST:url dict:@{@"page":@1,@"pageSize":@100} succeed:^(id resonseObj, BOOL isSuccess, NSString *message) {
        NSLog(@"res == %@",resonseObj);
        
        if (isSuccess) {
            
            NSArray *array = [BuySellingModel mj_objectArrayWithKeyValuesArray:resonseObj[@"list"]];
            
            self.allGoodsArray = [array mutableCopy];
            NSMutableArray *wh = [NSMutableArray array];
            NSMutableArray *gjs = [NSMutableArray array];
            NSMutableArray *yy = [NSMutableArray array];
            
            NSMutableDictionary *socketDic = [NSMutableDictionary dictionary];
            
            for (BuySellingModel *model in array) {
                
                if (model.symbolType == 1) {//wh
                    [socketDic setObject:@{@"type":@"wh",@"index":@(wh.count)} forKey:model.symbolCode];
                    [wh addObject:model];
                }else if (model.symbolType == 2){//gjs
                    [socketDic setObject:@{@"type":@"gjs",@"index":@(gjs.count)} forKey:model.symbolCode];

                    [gjs addObject:model];
                }else if (model.symbolType == 3){//yy
                    [socketDic setObject:@{@"type":@"yy",@"index":@(yy.count)} forKey:model.symbolCode];

                    [yy addObject:model];
                }
                
            }
            
            self.allGoodsSocketDic = socketDic;
            
            ws.allGoodsDic[@"wh"] = wh;
            ws.allGoodsDic[@"gjs"] = gjs;
            ws.allGoodsDic[@"yy"] = yy;
            NSLog(@"wh count ==== %ld",wh.count);
            NSLog(@"gjs count ==== %ld",gjs.count);
            NSLog(@"yy count ==== %ld",yy.count);

            
        }
        
        [self.marketTable reloadData];
        [self.marketTable.header endRefreshing];

    } failure:^(NSError *error) {
        [self.marketTable.header endRefreshing];

        
    }];
    
}

#pragma mark - 表头的点击事件
-(void)clickMarketTypeButtons:(UIButton*)button {
    if (!button) {
        return;
    }
    //如果已经选择当前 button  就不继续下面操作
    if( _proBtnTag  == button.tag ){
        return;
    }
    //将老的按钮变为浅色
    [_currentTypeBtn setTitleColor:LTSubTitleRGB forState:UIControlStateNormal];
    //重置当前的btn
    _currentTypeBtn = button;
    [button setTitleColor:LTTitleRGB forState:UIControlStateNormal];
    _proBtnTag = button.tag;
    NSInteger pre = button.tag-1;
    NSInteger next = button.tag+1;
    if (pre<0) {
        pre = 0;
    }
    if (next> _productTypes.count-1) {
        next = _productTypes.count-1;
    }

    UIButton *preBt = [_productScrollView.subviews objectAtIndex:pre];
    UIButton *nextBt = [_productScrollView.subviews objectAtIndex:next];

    // 检查是否向前或者向后移动若干距离
    if (button.x_>16 && next<_productTypes.count-1 ) {
        if ((button.x_-_productScrollView.contentOffset.x)<preBt.w_) {
            // 向后移动
            [_productScrollView setContentOffset:CGPointMake(preBt.x_, 0) animated:YES];
        }
        if ((_productScrollView.contentOffset.x+_productScrollView.w_)-(button.x_+button.w_)
            <nextBt.w_ ) {
            // 向前移动
            [_productScrollView setContentOffset:CGPointMake(nextBt.x_+nextBt.w_ -_productScrollView.w_, 0) animated:YES];
        }

    }
    [UIView animateWithDuration:0.3 animations:^{
        self.line.frame = CGRectMake(button.center.x-self.line.w_/2.0, self.line.frame.origin.y, self.line.w_, self.line.frame.size.height);
    }];
    self.buttonTag = button.tag;
    self.selectHeaderType = button.tag;
    NSLog(@"button type ==== %ld",self.selectHeaderType);
    if (self.buttonTag > 0) {
    _marketTable.tableFooterView.hidden = YES;
    }else
    {
    [self requestTest];
    _marketTable.tableFooterView.hidden = NO;
    }
    [_marketTable reloadData];
    
}

#pragma mark - delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSString *key = self.selectHeaderType == 0 ? @"zx" : self.selectHeaderType == 1 ? @"wh": self.selectHeaderType == 2 ? @"gjs": self.selectHeaderType == 3 ? @"yy":@"zx";
    NSInteger count = [self.allGoodsDic[key] count];
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSString *key = self.selectHeaderType == 0 ? @"zx" : self.selectHeaderType == 1 ? @"wh": self.selectHeaderType == 2 ? @"gjs": self.selectHeaderType == 3 ? @"yy":@"zx";
    BuySellingModel *model = self.allGoodsDic[key][indexPath.row];
    
    if ([key isEqualToString:@"zx"] && model.price.length == 0) {
        model.price = model.presentPrice;
    }
    
    [cell.change setTitle:@"0.00%" forState:0];//    }
    cell.name.text = model.symbolName;
    cell.code.text = model.symbolCode;
    
    [cell updateCellContent1:model];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *key = self.selectHeaderType == 0 ? @"zx" : self.selectHeaderType == 1 ? @"wh": self.selectHeaderType == 2 ? @"gjs": self.selectHeaderType == 3 ? @"yy":@"zx";
    BuySellingModel *model = self.allGoodsDic[key][indexPath.row];
    
    WeiPanMarketViewController *kline = [[WeiPanMarketViewController alloc] initWithCode:model.symbolCode exCode:@"" title:model.symbolName];
    kline.buyModel = model;
    [self.navigationController pushViewController:kline animated:YES];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//下拉刷新
-(void)addMJHeader{
    __weak UIScrollView *scrollView = _marketTable;
    [scrollView addLegendHeaderWithRefreshingBlock:^{
        if (self.buttonTag > 0) {
            [self getAllGoods];
        }else
        {
            [self requestTest];
        }
        
    }];
}

#pragma mark - JMColumnMenuDelegate
- (void)columnMenuTagsArr:(NSMutableArray *)tagsArr OtherArr:(NSMutableArray *)otherArr AddString:(NSString *)add ReductionStirng:(NSString *)reduction{
    
    if (tagsArr.count > _myTagsArrM.count) {
        
        NSString * url = [NSString stringWithFormat:@"%@%@",BaseUrl,@"/userSymbol/save"];
        NSMutableDictionary * dic= [NSMutableDictionary dictionaryWithObjectsAndKeys:add,@"symbolCode",nil];
        
        [[NetworkRequests sharedInstance] SWDPOST:url dict:dic succeed:^(id resonseObj, BOOL isSuccess, NSString *message) {
            NSLog(@"res ==== %@",resonseObj);

            if (isSuccess) {
                [self requestTest];
            }else{
                NSLog(@"%@",message);
            }

        } failure:^(NSError *error) {


        }];

        
    }else{
        NSString * url = [NSString stringWithFormat:@"%@%@",BaseUrl,@"/userSymbol/delete"];
        NSMutableDictionary * dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:reduction,@"symbolCode",nil];
        
        
        [[NetworkRequests sharedInstance] SWDPOST:url dict:dic succeed:^(id resonseObj, BOOL isSuccess, NSString *message) {
            NSLog(@"res ==== %@",resonseObj);
            if (isSuccess) {
                [self requestTest];
                
            }else{
                NSLog(@"%@",message);

            }
            
        } failure:^(NSError *error) {
            
            
        }];

    }

}

- (void)columnMenuDidSelectTitle:(NSString *)title Index:(NSInteger)index {
    NSLog(@"点击的标题---%@  对应的index---%zd",title, index);
}

- (NSMutableArray *)allGoodsArray{
    if (!_allGoodsArray) {
        _allGoodsArray = [NSMutableArray array];
    }
    return _allGoodsArray;
}

- (NSMutableDictionary *)allGoodsDic{
    if (!_allGoodsDic) {
        _allGoodsDic = [NSMutableDictionary dictionary];
        
        [_allGoodsDic setValue:[NSMutableArray array] forKey:@"wh"];
        [_allGoodsDic setValue:[NSMutableArray array] forKey:@"gjs"];
        [_allGoodsDic setValue:[NSMutableArray array] forKey:@"yy"];
        [_allGoodsDic setValue:[NSMutableArray array] forKey:@"zx"];

    }
    return _allGoodsDic;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
