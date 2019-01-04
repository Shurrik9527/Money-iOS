//
//  BaseCollectionVCtrl.h
//  ixit
//
//  Created by litong on 2017/3/28.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BaseVCtrl.h"
#import "MJRefresh.h"

@interface BaseCollectionVCtrl : BaseVCtrl <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,assign)NSInteger pageNo;
@property(nonatomic,assign)NSInteger pageSize;
@property(nonatomic,strong)UICollectionView *collectionView;


- (void)createCollectionView:(UICollectionViewLayout *)layout;
- (void)createCollectionViewWithHeader:(UICollectionViewLayout *)layout;
- (void)createCollectionViewWithFooter:(UICollectionViewLayout *)layout;
- (void)createCollectionViewWithHeaderAndFooter:(UICollectionViewLayout *)layout;

- (void)endHeadOrFootRef;


@end
