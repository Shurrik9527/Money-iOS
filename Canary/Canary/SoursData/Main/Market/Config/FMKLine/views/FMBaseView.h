//
//  FMBaseView.h
//  golden_iphone
//
//  Created by dangfm on 15/6/11.
//  Copyright (c) 2015年 golden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMKLineModel.h"
@interface FMBaseView : UIView
@property (nonatomic,assign) BOOL isClear;
-(void)updateWithModel:(FMKLineModel*)model;
@end
