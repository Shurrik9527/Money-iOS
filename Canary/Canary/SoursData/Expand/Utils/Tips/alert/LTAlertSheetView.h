//
//  LTAlertSheetView.h
//  ixit
//
//  Created by litong on 2016/12/23.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LTAlertSheetBlock)(NSInteger idx);

@interface LTAlertSheetView : UIView

@property (nonatomic,copy) LTAlertSheetBlock alertSheetBlock;

- (void)configSheetH:(CGFloat)sh;
- (void)configContentView:(NSString *)title
                      msg:(NSString *)msg
                   subMsg:(NSString *)subMsg
                      mos:(NSArray *)mos;
- (void)configContentView:(NSString *)title mos:(NSArray *)mos;
- (void)configCancleTitle:(NSString *)cancle;
- (void)showView:(BOOL)show;

@end
