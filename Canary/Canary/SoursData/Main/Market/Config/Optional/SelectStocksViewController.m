//
//  SelectStocksViewController.m
//  golden_iphone
//
//  Created by dangfm on 15/7/1.
//  Copyright (c) 2015年 golden. All rights reserved.
//

#import "SelectStocksViewController.h"
#import "SelfList+CoreDataClass.h"
#import "ForeignCurrencyList+CoreDataClass.h"
#import "MetalList+CoreDataClass.h"
#import "Global+CoreDataClass.h"

#import "JMColumnMenu.h"
#import "UIView+JM.h"
#import "JMConfig.h"

@interface SelectStocksViewController ()<JMColumnMenuDelegate>

/** menuView */
@property (nonatomic, strong) JMColumnMenu *menu;


@end



@implementation SelectStocksViewController


#pragma mark - System
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化数据
    NSMutableArray *myTagsArrM = [NSMutableArray arrayWithObjects:@"要闻",@"视频",@"娱乐",@"军事",@"新时代",@"独家",@"广东",@"社会",@"图文",@"段子",@"搞笑视频", nil];
    NSMutableArray *otherArrM = [NSMutableArray arrayWithObjects:@"八卦",@"搞笑",@"短视频",@"图文段子",@"极限第一人", nil];
    
    JMColumnMenu *menuVC = [JMColumnMenu columnMenuWithTagsArrM:myTagsArrM OtherArrM:otherArrM Type:JMColumnMenuTypeTencent Delegate:self];
    [self presentViewController:menuVC animated:YES completion:nil];
    
}
-(void)viewWillAppear:(BOOL)animated {
    if (self) {
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - InitView
-(instancetype)initWithDatas:(NSMutableArray *)data{
    if (self==[super init]) {
    }
    return self;
}


@end
