//
//  MoneyRecordDetailCell.h
//  Canary
//
//  Created by litong on 2017/6/2.
//  Copyright © 2017年 litong. All rights reserved.
//
//  出金、入金详情Cell

#import <UIKit/UIKit.h>

#define kMoneyRecordDetailCellH  44

#define key_MRDC_Title          @"key_MRDC_Title"
#define key_MRDC_Content    @"key_MRDC_Content"

@interface MoneyRecordDetailCell : UITableViewCell

- (void)bindData:(NSDictionary *)dict;

@end
