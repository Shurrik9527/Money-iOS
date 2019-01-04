//
//  UITableView+LT.m
//  Canary
//
//  Created by litong on 2017/5/11.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "UITableView+LT.h"

@implementation UITableView (LT)


- (void)reloadRow:(NSInteger)row inSection:(NSInteger)section {
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:row inSection:section];
    NSArray *indexArray = [NSArray arrayWithObject:indexPath];
    [self reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadRow:(NSInteger)row {
    [self reloadRow:row inSection:0];
}

- (void)reloadSection:(NSInteger)section {
    [self reloadSections:[NSIndexSet indexSetWithIndex:section]
        withRowAnimation:UITableViewRowAnimationNone];
}



- (void)registerClass:(nullable Class)cellClass {
    NSString *cellReuseIdf = [UITableView cellReuseIdentifier:cellClass];
    [self registerClass:cellClass forCellReuseIdentifier:cellReuseIdf];
}

+ (NSString *)cellReuseIdentifier:(nullable Class)cellClass {
    NSString *cellReuseIdf = [NSString stringWithFormat:@"k%@Identifier",NSStringFromClass(cellClass)];
    return cellReuseIdf;
}


@end
