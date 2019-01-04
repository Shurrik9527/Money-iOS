//
//  KLineSMAVerticalView.h
//  ixit
//
//  Created by Brain on 16/7/28.
//  Copyright © 2016年 ixit. All rights reserved.
//

#import "FMBaseView.h"
#import <UIKit/UIKit.h>
typedef void (^clickKLineSMAButtonBlock)(NSString* code);
@interface KLineSMAVerticalView : FMBaseView
@property(nonatomic,copy) clickKLineSMAButtonBlock SMAButtonBlock;
//刷新选中
-(void)reloadSelectWithTag:(NSInteger)tag;

@end
