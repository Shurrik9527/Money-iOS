//
//  SellProductView.h
//  ixit
//
//  Created by litong on 2017/3/13.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShutView)();
typedef void(^SellFinish)(NSString *msg,NSString *code);

/**  平仓 - 卖出产品 */
@interface SellProductView : UIView

@property (nonatomic,copy) ShutView shutView;
@property (nonatomic,copy) SellFinish sellFinish;
/** 从哪个页面跳转过来 */
@property (nonatomic,copy) NSString *fromClassString;

- (instancetype)initWithContentY:(CGFloat)y;


- (void)showView:(BOOL)show;
- (void)refDatas:(NSArray *)holdList;



@end
