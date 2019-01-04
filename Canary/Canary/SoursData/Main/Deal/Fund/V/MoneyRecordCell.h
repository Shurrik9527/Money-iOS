//
//  MoneyRecordCell.h
//  Canary
//
//  Created by litong on 2017/6/2.
//  Copyright © 2017年 litong. All rights reserved.
//
//  出金、入金列表Cell

#import <UIKit/UIKit.h>
#import "MoneyRecordMO.h"

typedef NS_ENUM(NSUInteger, MoneyRecordType) {
    MoneyRecordType_in,
    MoneyRecordType_out,
};

#define kMoneyRecordCellH  64

@interface MoneyRecordCell : UITableViewCell

@property (nonatomic,assign) MoneyRecordType typ;
- (void)bindData:(MoneyRecordMO *)mo;

@end
