//
//  FMBackgroundScrollView.h
//  golden_iphone
//
//  Created by dangfm on 15/6/11.
//  Copyright (c) 2015年 golden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMKLineModel.h"
#import "FMBaseView.h"
typedef void (^ScrollViewOutMoveBlock)(FMKLineModel *model);
@interface FMBackgroundScrollView : UIScrollView
@property (nonatomic,retain) FMBaseView *zoomBox;           // 放大缩小视图
@property (nonatomic,copy) ScrollViewOutMoveBlock scrollViewOutMoveBlock;
@property (nonatomic,copy) ZoomingBlock zoomingBlock;
-(instancetype)initWithFrame:(CGRect)frame Model:(FMKLineModel*)model;
-(void)updateWithModel:(FMKLineModel*)model;
@end
