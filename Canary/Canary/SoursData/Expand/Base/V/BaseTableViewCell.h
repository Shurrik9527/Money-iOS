//
//  BaseTableViewCell.h
//  FMStock
//
//  Created by dangfm on 15/4/12.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellFontSize 14
#define kCellPriceFontSize 17
#define kCellCodeFontSize 12
#define kCellChangeFontSize 15


@interface BaseTableViewCell : UITableViewCell
@property (nonatomic,retain) NSString *excode;
@property (nonatomic,assign) CGFloat imageWidth;
@property (nonatomic, assign) BOOL needRedPoint;
-(void)showArrow;


@end
