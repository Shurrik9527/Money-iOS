//
//  BaseCollectionVCtrl.m
//  ixit
//
//  Created by litong on 2017/3/28.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BaseCollectionVCtrl.h"

@interface BaseCollectionVCtrl ()
@end

@implementation BaseCollectionVCtrl


- (id)init {
    self = [super init];
    if (self) {
        self.pageNo = kStartPageNum;
        self.pageSize = kPageSize;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createCollectionView:(UICollectionViewLayout *)layout {
    [self createCollectionViewWithHeader:NO Footer:NO layout:layout];
}
- (void)createCollectionViewWithHeader:(UICollectionViewLayout *)layout {
    [self createCollectionViewWithHeader:YES Footer:NO layout:layout];
}
- (void)createCollectionViewWithFooter:(UICollectionViewLayout *)layout {
    [self createCollectionViewWithHeader:NO Footer:YES layout:layout];
}
- (void)createCollectionViewWithHeaderAndFooter:(UICollectionViewLayout *)layout  {
    [self createCollectionViewWithHeader:YES Footer:YES layout:layout];
}


- (void)createCollectionViewWithHeader:(BOOL)hbl Footer:(BOOL)fbl layout:(UICollectionViewLayout *)layout {
    CGRect rect = CGRectMake(0, NavBarTop_Lit, self.w_, self.h_ - NavBarTop_Lit - TabBarH_Lit);
    self.collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = LTBgRGB;
    [self.view addSubview:self.collectionView];
    
    if (hbl) {
        [self.collectionView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
//        [self.collectionView addHeaderWithTarget:self action:@selector(headerRereshing)];
    }
    
    if (fbl) {
        [self.collectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
//        [self.collectionView addFooterWithTarget:self action:@selector(footerRereshing)];
    }
    
}


#pragma mark - action

- (void)loadData {}
/**
 *  @brief  下拉刷新
 */
- (void)headerRereshing {
    self.pageNo = kStartPageNum;
    [self loadData];
}

/**
 *  @brief  上提刷新
 */
- (void)footerRereshing {
    self.pageNo ++ ;
    [self loadData];
}

- (void)endHeadOrFootRef {
    if (_pageNo == kStartPageNum) {
        [self.collectionView.header endRefreshing];
    } else {
        [self.collectionView.footer endRefreshing];
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    
}

@end
