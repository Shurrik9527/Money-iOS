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
#import "SelectStocksViewController.h"
#import "LoginVCtrl.h"
#import "WeiPanMarketViewController.h"
#import "NetworkRequests.h"
#import "MarketModel.h"
#import "DataHundel.h"
#import "AsSocket.h"
#import "SocketModel.h"
#import "HomeMarketList+CoreDataClass.h"

/**
 自选表
 */
#import "SelfList+CoreDataClass.h"
/**
 外汇
 */
#import "ForeignCurrencyList+CoreDataClass.h"
/**
 贵金属
 */
#import "MetalList+CoreDataClass.h"
/**
 原油
 */
#import "CrudeList+CoreDataClass.h"
/**
 全球指数
 */
#import "Global+CoreDataClass.h"

#import "JMColumnMenu.h"
#import "UIView+JM.h"
#import "JMConfig.h"
#define kSectionHeight 40
#define kProductScrollViewH 44

@interface MarketVCtrl ()<UITableViewDelegate,UITableViewDataSource,JMColumnMenuDelegate> {
#pragma mark 商品种类摁钮 tag
    NSInteger _proBtnTag;
}
/** menuView */
@property (nonatomic, strong) JMColumnMenu *menu;
@property(nonatomic,strong)MJRefreshHeader *mj_head;
@property(nonatomic,strong)NSMutableArray *datasArray;
@property(nonatomic,strong)NSMutableArray *optiondatas;
@property(nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong) OptionalTableView *marketTable;//行情表table

@property (nonatomic,strong) UIScrollView *productScrollView;
@property (nonatomic,strong) NSArray *productTypes;
// 选择的当前商品种类代码
@property (nonatomic,strong) UIView  *line;
@property (nonatomic,strong) UIView *bottomView;
// 表头
@property (nonatomic,strong) UIView *sectionView;
// 表头上面  蓝色的细线
@property (nonatomic,strong) UIView *sectionViewTopBlueLine;
@property(strong,nonatomic)UIButton * currentTypeBtn;//记录最后一个按钮
@property(copy,nonatomic) NSString *limitStr;//默认无法点击的产品名

@property (nonatomic,strong)NSMutableArray * socketArray;
@property (nonatomic,strong)HomeTableViewCell * cell ;
@property (nonatomic,assign)NSInteger buttonTag;
@property (nonatomic,strong)NSMutableArray *myTagsArrM;
@property (nonatomic,strong)NSMutableArray *otherArrM;
@property (nonatomic,strong)NSMutableArray *marketAllArr;
@end

@implementation MarketVCtrl
- (void)viewDidLoad {
    [super viewDidLoad];
    [self navTitle:@"行情列表"];
    
    NSArray * arr = [HomeMarketList searchAll];
    self.marketAllArr = [NSMutableArray arrayWithArray:arr];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    self.datasArray = [NSMutableArray array];
    switch (self.buttonTag) {
        case 0:
        {
            NSArray * arr = [SelfList searchAll];
            self.datasArray = [NSMutableArray arrayWithArray:arr];
        }
            break;
        case 1:
        {
            NSArray * arr = [ForeignCurrencyList searchAll];
            self.datasArray = [NSMutableArray arrayWithArray:arr];
        }
            break;
        case 2:
        {
            NSArray * arr = [MetalList searchAll];
            self.datasArray = [NSMutableArray arrayWithArray:arr];
        }
            break;
        case 3:
        {
        //    NSArray * arr = [CrudeList searchAll];
        //    self.datasArray = [NSMutableArray arrayWithArray:arr];
        }
            break;
        case 4:
        {
            NSArray * arr = [Global searchAll];
            self.datasArray = [NSMutableArray arrayWithArray:arr];
        }
            break;
        default:
            break;
    }
   
    [self createProductListButtons];//创建产品列表
    [self requestTest];
    [self setprice:self.cell cellForRowAtIndexPath:0 isSelect:1];
    
}
#pragma mark - init
//创建头部交易所bar
-(void)createProductListButtons {
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
    [self.view addSubview:_productScrollView];
     _productTypes = @[@"自选",@"外汇",@"贵金属",@"原油",@"全球指数"];
    for (NSString * name in _productTypes) {
        NSString *btnTitle=name;
        UIButton *bt=[UIButton buttonWithType:UIButtonTypeCustom];
        bt.frame = CGRectMake(x, 0, w, h) ;
        [bt setTitle:btnTitle forState:UIControlStateNormal];
        [bt setTitleColor:LTSubTitleRGB forState:UIControlStateNormal];
        bt.titleLabel.font = fontSiz(midFontSize);
        [bt addTarget:self action:@selector(clickMarketTypeButtons:) forControlEvents:UIControlEventTouchUpInside];
        [bt sizeToFit];
        bt.frame = CGRectMake(x, 0, bt.w_+10, h);
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
-(void)addMarketTableView {
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
//    SelectStocksViewController *quotation = [[SelectStocksViewController alloc] initWithDatas:_optiondatas];
//    [self presentViewController:quotation animated:YES completion:nil];
//    quotation = nil;
    //初始化数据
    
    NSArray * arr = [SelfList searchAll];
    NSMutableArray * dataArr = [NSMutableArray arrayWithArray:arr];
    NSArray * arr1 = [ForeignCurrencyList searchAll];
    NSMutableArray * dataArr1 = [NSMutableArray arrayWithArray:arr1];
    NSArray * arr2 = [MetalList searchAll];
    NSMutableArray * dataArr2 = [NSMutableArray arrayWithArray:arr2];
    NSArray * arr3 = [CrudeList searchAll];
    NSMutableArray * dataArr3 = [NSMutableArray arrayWithArray:arr3];
    NSArray * arr4 = [Global searchAll];
    NSMutableArray * dataArr4 = [NSMutableArray arrayWithArray:arr4];
    
    
    _myTagsArrM = [NSMutableArray array];
    _otherArrM = [NSMutableArray array];
    for (MarketModel*model in dataArr) {
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                              model.symbol,@"title",
                              model.symbol_cn,@"title_cn",nil];
        [_myTagsArrM addObject:dic];
    }
    
    for (MarketModel*model in dataArr1) {
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                              model.symbol,@"title",
                              model.symbol_cn,@"title_cn",nil];
        [_otherArrM addObject:dic];
    }
    
    for (MarketModel*model in dataArr2) {
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                              model.symbol,@"title",
                              model.symbol_cn,@"title_cn",nil];
        [_otherArrM addObject:dic];
    }
    
    for (MarketModel*model in dataArr3) {
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                              model.symbol,@"title",
                              model.symbol_cn,@"title_cn",nil];
        [_otherArrM addObject:dic];
    }
    
    for (MarketModel*model in dataArr4) {
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                              model.symbol,@"title",
                              model.symbol_cn,@"title_cn",nil];
        [_otherArrM addObject:dic];
    }
    
    for (int i = 0; i < _myTagsArrM.count; i++) {
        NSString * string = _myTagsArrM[i][@"title"];
        for (int j = 0; j < _otherArrM.count; j++) {
            NSString * string1 = _otherArrM[j][@"title"];
            if ([string isEqualToString:string1]) {
                [_otherArrM removeObjectAtIndex:j];
            }
        }
    }
    
    JMColumnMenu *menuVC = [JMColumnMenu columnMenuWithTagsArrM:_myTagsArrM OtherArrM:_otherArrM Type:JMColumnMenuTypeTencent Delegate:self];
    [self presentViewController:menuVC animated:YES completion:nil];
}
//行情表头 （品种代码，买入价，涨跌幅）
-(void)addSectionView{
    //    int fontsize = 15;
    CGFloat w = (Screen_width)/4.0;
    CGFloat y = _productScrollView.yh_;
    _sectionViewTopBlueLine =[[UIView alloc] initWithFrame:CGRectMake(0, y+0.5, self.view.w_, 0.5)];
    _sectionViewTopBlueLine.backgroundColor = LTBgRGB;
    [self.view addSubview:_sectionViewTopBlueLine];
    
    _sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, y+1, self.view.w_, kSectionHeight)];
    _sectionView.backgroundColor = LTBgRGB;
    [self.view addSubview:_sectionView];
    // 名称
    UILabel *nameLab = [[DataHundel shareDataHundle] createLabWithFrame:CGRectMake(16, 0, w-16, kSectionHeight) text:@"品种代码" fontsize:midFontSize];
    nameLab.textAlignment = NSTextAlignmentLeft;
    [_sectionView addSubview:nameLab];
    nameLab = nil;
    // 最新价
    UILabel *priceLab = [[DataHundel shareDataHundle] createLabWithFrame:CGRectMake(w, 0, w, kSectionHeight) text:@"买入价" fontsize:midFontSize];
    [_sectionView addSubview:priceLab];
    priceLab = nil;
    
    UILabel * buyOutLab =[[DataHundel shareDataHundle]createLabWithFrame:CGRectMake(w*2 , 0, w, kSectionHeight) text:@"卖出价" fontsize:midFontSize];
    [_sectionView addSubview:buyOutLab];
    buyOutLab = nil;
    // 涨跌幅
    UIButton * selectBut = [UIButton buttonWithType:(UIButtonTypeCustom)];
    selectBut.frame = CGRectMake(Screen_width-16-60, 0, 70, kSectionHeight );
    selectBut.titleLabel.font = [UIFont systemFontOfSize:midFontSize];
    [selectBut setTitleColor:LTSubTitleRGB forState:(UIControlStateNormal)];
     [selectBut setTitle:@"涨跌幅 ▼" forState:(UIControlStateNormal)];
    [selectBut addTarget:self action:@selector(seleBut:) forControlEvents:UIControlEventTouchUpInside];
    [_sectionView addSubview:selectBut];
}

- (void)seleBut:(UIButton *)button {
    [button setSelected:!button.isSelected];
    if (button.isSelected) {
        [button setTitle:@"点 差 ▲" forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:midFontSize];
        [button setTitleColor:LTSubTitleRGB forState:(UIControlStateNormal)];
        [self setprice:self.cell cellForRowAtIndexPath:0 isSelect:2];
        [self homeCellSelect:2];
        [self.cell.change setBackgroundColor:[UIColor clearColor]];
    }else{
        [button setTitle:@"涨跌幅 ▼" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:midFontSize];
        [button setTitleColor:LTSubTitleRGB forState:(UIControlStateNormal)];
        [self setprice:self.cell cellForRowAtIndexPath:0 isSelect:1];
        [self homeCellSelect:1];
    }
}
-(void)homeCellSelect:(NSInteger)isSelect
{
    if (isSelect == 1) {
        for (MarketModel * model in self.datasArray) {
            model.isAllSelect = 1;
            [self.marketTable reloadData];
        }
    }else
    {
        for (MarketModel * model in self.datasArray) {
            model.isAllSelect = 2;
            [self.marketTable reloadData];
        }
    }
}
#pragma mark - 获取自选列表
-(void)requestTest
{
    
    [self showLoadingView];
    NSString * url = [NSString stringWithFormat:@"%@%@",BasisUrl,@"/price/private"];
    NSMutableDictionary * dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"DEMO",@"server",nil];
    [[NetworkRequests sharedInstance]POST:url dict:dic succeed:^(id data) {
        if ([[data objectForKey:@"code"]integerValue] == 0) {
            
            if (self.datasArray.count > 0) {
                [self.datasArray removeAllObjects];
            }
            
            for (NSDictionary * dic in [data objectForKey:@"dataObject"]) {
                MarketModel * model = [MarketModel mj_objectWithKeyValues:dic];
                [self.datasArray addObject:model];
                
                // 先查询表里面是否有数据没有的话 执行添加数据库
                if ([SelfList searchAll].count == 0) {
                    [SelfList AddData:model];
                }else{
                    // 查找数据库里面是否有值
                    NSArray * arr = [SelfList searchConditions:model];
                    // 如果没事执行添加, 如果有执行修改
                    if (arr.count == 0) {
                        [SelfList AddData:model];
                    }else{
                        [SelfList andkey:model];
                    }
                }
            }
//            self.datasArray =[MarketModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"dataObject"]];
            [self.marketTable.header endRefreshing];
            [self.marketTable reloadData];
            [self hideLoadingView];
        }
    } failure:^(NSError *error) {
        [self.marketTable.header endEditing:YES];
        [self hideLoadingView];
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
    if (self.buttonTag > 0) {
    [self creatRequestType:button.tag];
    _marketTable.tableFooterView.hidden = YES;
    }else
    {
    [self requestTest];
    _marketTable.tableFooterView.hidden = NO;
    }
    
}
//选择网络请求类型
-(void)creatRequestType:(NSInteger)type
{
    [self showLoadingView];
    NSString * url = [NSString stringWithFormat:@"%@%@",BasisUrl,@"/price/symbols"];
    NSDictionary * dic = [NSDictionary dictionary];
    if ([[NSUserDefaults objFoKey:TYPE]isEqualToString:@"DEMO"]) {
        dic = @{@"server":[NSUserDefaults objFoKey:TYPE],@"type":[NSString stringWithFormat:@"%ld",type]};
    }else
    {
        dic =@{@"type":[NSString stringWithFormat:@"%ld",type]};
    }
    [[NetworkRequests sharedInstance]GET:url dict:dic succeed:^(id data) {
        if ([[data objectForKey:@"code"]integerValue] == 0) {
            if (self.datasArray.count > 0) {
                [self.datasArray removeAllObjects];
            }
            
            switch (type) {
                case 0:
                {
                    for (NSDictionary * dic in [data objectForKey:@"dataObject"]) {
                        MarketModel * model = [MarketModel mj_objectWithKeyValues:dic];
                        [self.datasArray addObject:model];
                        
                        // 先查询表里面是否有数据没有的话 执行添加数据库
                        if ([SelfList searchAll].count == 0) {
                            [SelfList AddData:model];
                        }else{
                            // 查找数据库里面是否有值
                            NSArray * arr = [SelfList searchConditions:model];
                            // 如果没事执行添加, 如果有执行修改
                            if (arr.count == 0) {
                                [SelfList AddData:model];
                            }else{
                                [SelfList andkey:model];
                            }
                        }
                    }
                }
                    break;
                case 1:
                {
                    for (NSDictionary * dic in [data objectForKey:@"dataObject"]) {
                        MarketModel * model = [MarketModel mj_objectWithKeyValues:dic];
                        [self.datasArray addObject:model];
                        
                        // 先查询表里面是否有数据没有的话 执行添加数据库
                        if ([ForeignCurrencyList searchAll].count == 0) {
                            [ForeignCurrencyList AddData:model];
                        }else{
                            // 查找数据库里面是否有值
                            NSArray * arr = [ForeignCurrencyList searchConditions:model];
                            // 如果没事执行添加, 如果有执行修改
                            if (arr.count == 0) {
                                [ForeignCurrencyList AddData:model];
                            }else{
                                [ForeignCurrencyList andkey:model];
                            }
                        }
                    }
                }
                    break;
                case 2:
                {
                    for (NSDictionary * dic in [data objectForKey:@"dataObject"]) {
                        MarketModel * model = [MarketModel mj_objectWithKeyValues:dic];
                        [self.datasArray addObject:model];
                        
                        // 先查询表里面是否有数据没有的话 执行添加数据库
                        if ([MetalList searchAll].count == 0) {
                            [MetalList AddData:model];
                        }else{
                            // 查找数据库里面是否有值
                            NSArray * arr = [MetalList searchConditions:model];
                            // 如果没事执行添加, 如果有执行修改
                            if (arr.count == 0) {
                                [MetalList AddData:model];
                            }else{
                                [MetalList andkey:model];
                            }
                        }
                    }
                }
                    break;
                case 3:
                {
                    for (NSDictionary * dic in [data objectForKey:@"dataObject"]) {
                        MarketModel * model = [MarketModel mj_objectWithKeyValues:dic];
                        [self.datasArray addObject:model];
                        // 先查询表里面是否有数据没有的话 执行添加数据库
                        if ([CrudeList searchAll].count == 0) {
                            [CrudeList AddData:model];
                        }else{
                            // 查找数据库里面是否有值
                            NSArray * arr = [CrudeList searchConditions:model];
                            // 如果没事执行添加, 如果有执行修改
                            if (arr.count == 0) {
                                [CrudeList AddData:model];
                            }else{
                                [CrudeList andkey:model];
                            }
                        }
                    }
                }
                    break;
                case 4:
                {
                    for (NSDictionary * dic in [data objectForKey:@"dataObject"]) {
                        MarketModel * model = [MarketModel mj_objectWithKeyValues:dic];
                        [self.datasArray addObject:model];
                        // 先查询表里面是否有数据没有的话 执行添加数据库
                        if ([Global searchAll].count == 0) {
                            [Global AddData:model];
                        }else{
                            // 查找数据库里面是否有值
                            NSArray * arr = [Global searchConditions:model];
                            // 如果没事执行添加, 如果有执行修改
                            if (arr.count == 0) {
                                [Global AddData:model];
                            }else{
                                [Global andkey:model];
                            }
                        }
                    }
                }
                    break;
                    
                default:
                    break;
            }
            
        }else{
            switch (self.buttonTag) {
                case 0:
                {
                    NSArray * arr = [SelfList searchAll];
                    self.datasArray = [NSMutableArray arrayWithArray:arr];
                }
                    break;
                case 1:
                {
                    NSArray * arr = [ForeignCurrencyList searchAll];
                    self.datasArray = [NSMutableArray arrayWithArray:arr];
                }
                    break;
                case 2:
                {
                    NSArray * arr = [MetalList searchAll];
                    self.datasArray = [NSMutableArray arrayWithArray:arr];
                }
                    break;
                case 3:
                {
                    NSArray * arr = [CrudeList searchAll];
                    self.datasArray = [NSMutableArray arrayWithArray:arr];
                }
                    break;
                case 4:
                {
                    NSArray * arr = [Global searchAll];
                    self.datasArray = [NSMutableArray arrayWithArray:arr];
                }
                    break;
                default:
                    break;
            }
        }
        [self.marketTable.header endRefreshing];
        [self.marketTable reloadData];
        [self hideLoadingView];
    } failure:^(NSError *error) {
        
        switch (self.buttonTag) {
            case 0:
            {
                NSArray * arr = [SelfList searchAll];
                self.datasArray = [NSMutableArray arrayWithArray:arr];
            }
                break;
            case 1:
            {
                NSArray * arr = [ForeignCurrencyList searchAll];
                self.datasArray = [NSMutableArray arrayWithArray:arr];
            }
                break;
            case 2:
            {
                NSArray * arr = [MetalList searchAll];
                self.datasArray = [NSMutableArray arrayWithArray:arr];
            }
                break;
            case 3:
            {
                NSArray * arr = [CrudeList searchAll];
                self.datasArray = [NSMutableArray arrayWithArray:arr];
            }
                break;
            case 4:
            {
                NSArray * arr = [Global searchAll];
                self.datasArray = [NSMutableArray arrayWithArray:arr];
            }
                break;
            default:
                break;
        }
        
        [self.marketTable.header endRefreshing];
        [self.marketTable reloadData];
        [self hideLoadingView];
        
    }];
}
#pragma mark - delegate
#define kCellHeight 60
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datasArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  NSString *cellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
    HomeTableViewCell *cell = (HomeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (_datasArray != nil && ![_datasArray isEqual:[NSNull null]] && indexPath.row<_datasArray.count) {
        MarketModel * marketModel =[_datasArray objectAtIndex:indexPath.row];
       //涨跌幅和点差切换状态
        if (marketModel.isAllSelect == 2) {
            [cell.change setBackgroundImage:[UIImage imageWithColor:LTHEX(0x999999) size:CGSizeMake(cell.change.frame.size.width, cell.change.frame.size.height)] forState:UIControlStateNormal];
            NSString * percentage =[NSString stringWithFormat:@"%@%@%@",@"%0.",[NSString stringWithFormat:@"%ld",marketModel.digit],@"f"];
            [cell.change setTitle:[NSString stringWithFormat:percentage,@"0"]forState:0];
        }else if (marketModel.isAllSelect == 1)
        {
            [cell.change setTitle:@"0.00%"forState:0];
        }
        [cell updateCellContent:marketModel];
        cell.name.text = marketModel.symbol_cn;
        cell.code.text =marketModel.symbol;
        
        if (!notemptyStr(marketModel.buy_in)) {
            cell.price.textColor = [UIColor blackColor];
            cell.weipanId.textColor = [UIColor blackColor];
            [cell.change setBackgroundImage:[UIImage imageWithColor:LTHEX(0x999999) size:CGSizeMake(cell.change.frame.size.width, cell.change.frame.size.height)] forState:UIControlStateNormal];
            cell.price.text =@"0.000";
            cell.weipanId.text = @"0.000";
            [cell.change setTitle:@"0.000" forState:0];
        }else
        {
            cell.price.text = marketModel.buy_in;
            cell.weipanId.text = marketModel.buy_out;
        }
    }
    return cell;
}
//设置cell上的价格变化
-(void)setprice:(HomeTableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath isSelect:(NSInteger)isSelect;
{
    //block返回装socket数据的数组
    [AsSocket shareDataAsSocket].returnValueBlock = ^(NSMutableArray *socketArray) {
        if (self.datasArray.count > 0 && socketArray.count > 0) {
        for (SocketModel * sockModel in socketArray) {
            for (int i = 0; i < self.datasArray.count; i ++) {
            MarketModel * marketModel =[self.datasArray objectAtIndex:i];
            if ([marketModel.symbol isEqualToString:sockModel.symbol]) {
                marketModel.buy_out = sockModel.buy_out;
                marketModel.buy_in = sockModel.buy_in;
                marketModel.timeStr = sockModel.timeStr;
                marketModel.dataStr = sockModel.dataStr;
                marketModel.isAllSelect = isSelect;
            }
                [self.marketTable reloadData];
#warning 在在这里把行情数据模型按照对应的顺序缓存到本地(多线程异步并发执行)
                switch (self.buttonTag) {
                    case 0:
                    {
                        [SelfList andkey:marketModel];
                    }
                        break;
                    case 1:
                    {
                        [ForeignCurrencyList andkey:marketModel];
                    }
                        break;
                    case 2:
                    {
                        [MetalList andkey:marketModel];
                    }
                        break;
                    case 3:
                    {
                   //     [CrudeList andkey:marketModel];
                    }
                        break;
                    case 4:
                    {
                        [Global andkey:marketModel];
                    }
                        break;
                    default:
                        break;
                }
//                NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:i inSection:0];
//                [self.marketTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
            }
          }
        }
    };
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell *cell = (HomeTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    MarketModel * model =[_datasArray objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    WeiPanMarketViewController *kline = [[WeiPanMarketViewController alloc] initWithCode:cell.code.text exCode:cell.excode title:cell.name.text ];
    kline.price = cell.price.text;
    kline.change= cell.change.titleLabel.text;
    kline.changeCHa = [NSString stringWithFormat:@"%.3f",cell.changerate];
    kline.dataStr = model.dataStr;
    kline.timeStr = model.timeStr;
    kline.close = model.close;
    kline.open = model.open;
    kline.high = model.high;
    kline.low = model.low;
    kline.digit = model.digit;
    kline.code_cn = model.symbol;
    kline.stops_level = model.stops_level;
    [self.navigationController pushViewController:kline animated:YES];
}

//离开这个view
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//下拉刷新
-(void)addMJHeader{
    __weak UIScrollView *scrollView = _marketTable;
    [scrollView addLegendHeaderWithRefreshingBlock:^{
        if (self.buttonTag > 0) {
            [self creatRequestType:self.buttonTag];
        }else
        {
            [self requestTest];
        }
        
    }];
}

#pragma mark - JMColumnMenuDelegate
- (void)columnMenuTagsArr:(NSMutableArray *)tagsArr OtherArr:(NSMutableArray *)otherArr AddString:(NSString *)add ReductionStirng:(NSString *)reduction{
    
    NSString * String;
    if (tagsArr.count > _myTagsArrM.count) {
        
        NSString * url = [NSString stringWithFormat:@"%@%@",BasisUrl,@"/price/add"];
        NSMutableDictionary * dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:add,@"symbol",nil];
        [[NetworkRequests sharedInstance]POST:url dict:dic succeed:^(id data) {
            NSLog(@"%@", data);
            if ([[data objectForKey:@"code"]integerValue] == 0) {
                [self requestTest];
            }
        } failure:^(NSError *error) {
            NSLog(@"错误%@",error);
        }];
        
    }else{
        NSString * url = [NSString stringWithFormat:@"%@%@",BasisUrl,@"/price/delete"];
        NSMutableDictionary * dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:reduction,@"symbol",nil];
        [[NetworkRequests sharedInstance]POST:url dict:dic succeed:^(id data) {
            NSLog(@"%@", data);
            if ([[data objectForKey:@"code"]integerValue] == 0) {
                [self requestTest];
                [SelfList Delete:reduction];
            }
        } failure:^(NSError *error) {
            NSLog(@"错误%@",error);
        }];
    }

}

- (void)columnMenuDidSelectTitle:(NSString *)title Index:(NSInteger)index {
    NSLog(@"点击的标题---%@  对应的index---%zd",title, index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
