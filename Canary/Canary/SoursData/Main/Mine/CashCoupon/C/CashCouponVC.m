//
//  CashCouponVC.m
//  Canary
//
//  Created by 孙武东 on 2019/1/5.
//  Copyright © 2019 litong. All rights reserved.
//

#import "CashCouponVC.h"
#import "CashCouponCell.h"
#import "AppDelegate.h"

@interface CashCouponVC ()


@end

@implementation CashCouponVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navPopBackTitle:@"我的代金券"];
    
    [self createTableViewWithHeader];
    CGRect rect = CGRectMake(0, NavBarTop_Lit, ScreenW_Lit, ScreenH_Lit - NavBarTop_Lit);
    self.tableView.frame = rect;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:@"CashCouponCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([CashCouponCell class])];
    // Do any additional setup after loading the view.
}

#pragma mark ----- delegete
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CashCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CashCouponCell class]) forIndexPath:indexPath];
    WS(ws)
    
    cell.rightBtnBlock = ^{
        
        [ws goBuyVC];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)goBuyVC{
    [self popToRootVC];
    
    [AppDelegate selectTabBarIndex:TabBarType_Deal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
