//
//  KLineHorizontalIndexNavView.h
//  golden_iphone
//
//  Created by dangfm on 15/7/10.
//  Copyright (c) 2015年 golden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMBaseView.h"
typedef void (^clickKLineHorizontalNavButtonBlock)(NSString* code);
@interface KLineHorizontalIndexNavView : FMBaseView

@property(nonatomic,copy) clickKLineHorizontalNavButtonBlock clickKLineHorizontalNavButtonBlock;
//刷新选中
-(void)reloadSelect;
-(void)reloadSelectWithTag:(NSInteger)smatag
                   macdTag:(NSInteger)macdTag;
@end
