//
//  QuotationScrollView.m
//  ixit
//
//  Created by litong on 2016/11/10.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "QuotationScrollView.h"
#import "QuotationBtn.h"
#import "MarketModel.h"
#import "SocketModel.h"
#import "HomeMarketList+CoreDataClass.h"
static CGFloat tempLineH = 8.f;
static CGFloat pageControlH = 5.f;

@interface QuotationScrollView ()<UIScrollViewDelegate>
{
    NSInteger curPage;
    CGFloat singleW;
    NSInteger allPage;
}

@property (nonatomic,strong) UIScrollView *scView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) NSArray *objs;

@end

@implementation QuotationScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = LTBgColor;
        curPage = 0;
        singleW = self.w_/3.f;
        
    }
    return self;
}


- (void)configNum :(NSArray*)array {
    self.objs = [NSArray arrayWithArray:array];
    allPage = ceilf(_objs.count/3.0);
    
    if (allPage > 0) {
        [self createView];
    }
}

- (void)createView {
    _scView = [[UIScrollView alloc] init];
    _scView.frame = CGRectMake(0, LTAutoW(tempLineH), self.w_, LTAutoW(QuotationBtnH));
    _scView.delegate = self;
    _scView.showsHorizontalScrollIndicator = NO;
    _scView.pagingEnabled = YES;
    _scView.backgroundColor = LTWhiteColor;
    [self addSubview:_scView];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, LTAutoW(QuotationBtnH - pageControlH), self.w_, LTAutoW(pageControlH))];
    _pageControl.currentPage = curPage;
    _pageControl.pageIndicatorTintColor = LTLineColor;
    _pageControl.currentPageIndicatorTintColor = LTColorHex(0xB4B9CB);
    _pageControl.defersCurrentPageDisplay = YES;
    _pageControl.numberOfPages = allPage;
    [self addSubview:_pageControl];
    
    _scView.contentSize = CGSizeMake(allPage*_scView.w_, _scView.h_);
    [self createAllSingleView];
    
    [_scView addLineTop:LTLineColor];
    [_scView addLineBottom:LTLineColor];
}

- (void)createAllSingleView {
    NSInteger i = 0;
    NSInteger objsCount = _objs.count;
    for (i = 0 ; i < objsCount; i ++) {
        QuotationBtn *quotationBtn = [self createSingleView:i];
//        MarketModel * model = _objs[i];
        BuySellingModel *model = _objs[i];
        quotationBtn.stringTag = model.symbolCode;
        [quotationBtn refData:model];
        [_scView addSubview:quotationBtn];
    }
    _homeRefreshHttpDatas ? _homeRefreshHttpDatas() : nil;
}
//给view布局
- (QuotationBtn *)createSingleView:(NSInteger)i {
    QuotationBtn *view = [[QuotationBtn alloc] initWithFrame:CGRectMake(i*singleW, 0, singleW, _scView.h_)];
    return view;
}

//首页行情接口请求下来的model
- (void)refQuotation:(BuySellingModel *)q {
    NSString *code = q.symbolCode;
    QuotationBtn *quotationBtn = (QuotationBtn *)[_scView viewWithStringTag:code];
     [quotationBtn refData:q];
}

-(void)socketdata:(NSMutableArray * )array
{
    for (SocketModel * model in array) {
        for (int i = 0; i < _objs.count; i ++) {
            MarketModel * marketModel =[_objs objectAtIndex:i];
            if ([marketModel.symbol isEqualToString:model.symbol]) {
                marketModel.buy_out = model.buy_out;
                model.closePrice = marketModel.close;
                
                if ([self.symbolArray containsObject:marketModel.symbol]) {
                    QuotationBtn *quotationBtn = (QuotationBtn *)[_scView viewWithStringTag:marketModel.symbol];
                    [quotationBtn socketmodel:model];
                }
                
                [HomeMarketList andkey:marketModel];
      }
   }
    }
    
}

- (void)webSocketdata:(SocketModel *)model
{
        for (int i = 0; i < _objs.count; i ++) {
            BuySellingModel * marketModel =[_objs objectAtIndex:i];
            if ([marketModel.symbolCode isEqualToString:model.symbolCode]) {
                
                
                marketModel.price = model.price;
                
                if ([self.symbolArray containsObject:marketModel.symbolCode]) {
                    QuotationBtn *quotationBtn = (QuotationBtn *)[_scView viewWithStringTag:marketModel.symbolCode];
                    [quotationBtn socketmodel:marketModel];
                }
                
//                [HomeMarketList andkey:marketModel];
            }
        }
    
}

#pragma mark UIScrollerViewDelegate

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    curPage = scrollView.contentOffset.x/ScreenW_Lit;
    _pageControl.currentPage = curPage;
    [self setSymbolArrayContent:curPage];
    
}

- (void)setSymbolArrayContent:(NSInteger )curPage{
//    NSLog(@"当前是第%ld页",curPage);

    [self.symbolArray removeAllObjects];

    for (int i = 0; i < _objs.count; i++) {
        if (i / 3 == curPage) {
            BuySellingModel *model = _objs[i];
//            NSLog(@"%@",model.symbol);
            [self.symbolArray addObject:model.symbolCode];
        }
    }

//    NSLog(@"symbol === %@",self.symbolArray);
}

#pragma mark - 外部
- (void)refDatas:(NSArray *)arr {
    if (allPage <= 0) {
        [self configNum:arr];
    }
    for (MarketModel *q in arr) {
        [self refQuotation:q];
    }
    [self setSymbolArrayContent:curPage];
}

- (void)refDatasSocket:(NSArray *)arr{
    if (allPage <= 0) {
        [self configNum:arr];
    }
    for (BuySellingModel *q in arr) {
        [self refQuotation:q];
    }
    [self setSymbolArrayContent:curPage];
}

+ (CGFloat)viewH {
    return LTAutoW(QuotationBtnH + 1.5*tempLineH);
}

- (NSMutableArray *)symbolArray{
    if (!_symbolArray) {
        _symbolArray = [NSMutableArray array];
    }
    return _symbolArray;
}

@end
