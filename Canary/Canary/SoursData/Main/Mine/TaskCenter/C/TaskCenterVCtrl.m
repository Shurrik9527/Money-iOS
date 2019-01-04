//
//  TaskCenterVCtrl.m
//  ixit
//
//  Created by litong on 2017/3/1.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "TaskCenterVCtrl.h"
#import "LTWebCache.h"
#import "PollADView.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

@interface TaskCenterVCtrl ()

@property (nonatomic,strong) NSMutableArray *taskList;
@property (nonatomic,strong) NSMutableArray *bannerList;
@property (nonatomic,strong) UIView *taskHeadView;
@property (nonatomic,strong) PollADView *pollADView;

/** 分享成功回调  */
@property (nonatomic,copy) NSString *callback;

@end

@implementation TaskCenterVCtrl

- (instancetype)init {
    self = [super init];
    if (self) {
        self.taskList = [NSMutableArray array];
        self.bannerList = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navTitle:@"任务中心" backType:BackType_PopVC];
    
    [self createTableViewWithHeader];
    CGRect rect = CGRectMake(0, NavBarTop_Lit, ScreenW_Lit, ScreenH_Lit - NavBarTop_Lit);
    self.tableView.frame = rect;

}




@end
