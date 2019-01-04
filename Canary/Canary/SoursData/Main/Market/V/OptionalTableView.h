//
//  OptionalTableView.h
//  FMStock
//
//  Created by dangfm on 15/4/12.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OptionalTableView;

#pragma mark 点击添加按钮回调
typedef void (^ClickAddButtonBlock)(OptionalTableView *tableView);

@interface OptionalTableView : UITableView
@property (nonatomic,copy) ClickAddButtonBlock clickAddButtonBlock;

#pragma mark SectionView
-(UIView*)SectionView:(int)height;
#pragma mark 改变组视图背景
-(void)changeSectionBackgroundColor;

@end
