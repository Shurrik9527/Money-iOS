//
//  UITableView+LT.h
//  Canary
//
//  Created by litong on 2017/5/11.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (LT)


/*!
 *  @brief 刷新某一行 NSIndexPath.section=section
 */
- (void)reloadRow:(NSInteger)row inSection:(NSInteger)section;
/*!
 *  @brief 刷新row行 NSIndexPath.section=section
 */
- (void)reloadRow:(NSInteger)row;

- (void)reloadSection:(NSInteger)section;


- (void)registerClass:(nullable Class)cellClass;

+ (NSString *_Nullable)cellReuseIdentifier:(nullable Class)cellClass;


@end
