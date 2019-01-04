//
//  KLineMACDVerticalView.h
//  ixit
//
//  Created by Brain on 16/7/28.
//  Copyright © 2016年 ixit. All rights reserved.
//

#import "FMBaseView.h"
#import <UIKit/UIKit.h>
typedef void (^clickKLineMACDButtonBlock)(NSString* code);
#define MACDHeight 32

@interface KLineMACDVerticalView : FMBaseView
@property(nonatomic,copy) clickKLineMACDButtonBlock MACDButtonBlock;
//刷新选中
-(void)reloadSelectWithTag:(NSInteger)tag;
@end
