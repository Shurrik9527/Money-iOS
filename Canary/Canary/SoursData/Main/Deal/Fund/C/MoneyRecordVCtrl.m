//
//  MoneyRecordVCtrl.m
//  Canary
//
//  Created by litong on 2017/6/1.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "MoneyRecordVCtrl.h"
#import "SegmentView.h"
#import "LiveScrollView.h"
#import "MoneyRecordListVCtrl.h"
#import "MoneyRecordDeatilVCtrl.h"

@interface MoneyRecordVCtrl ()<SegmentViewDelegate, LiveScrollViewDelegate, MoneyRecordDelegate>

@property (nonatomic,strong) SegmentView *segmentView;
@property (nonatomic,strong) LiveScrollView *scView;

@property (nonatomic,strong) MoneyRecordListVCtrl *inMoneyVC;//入金
@property (nonatomic,strong) MoneyRecordListVCtrl *outMoneyVC;//出金


@end

@implementation MoneyRecordVCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navPopBackTitle:@"出入金记录"];
    
    [self createSegmentView];
    [self createScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init

static CGFloat segmentViewH = 40;
#define kSegmentTittles  @[@"入金", @"出金"]
- (void)createSegmentView {
    self.segmentView = [[SegmentView alloc] init];
    self.segmentView.frame = CGRectMake(0, NavBarTop_Lit, self.w_, segmentViewH);
    [self.segmentView setTitles:kSegmentTittles];
    self.segmentView.delegate = self;
    [self.view addSubview:self.segmentView];
}

- (void)createScrollView {
    
    CGFloat y = self.segmentView.yh_;
    CGFloat h = ScreenH_Lit - y - TabBarH_Lit;
    CGRect frame = CGRectMake(0, y, self.w_, h);
    self.scView = [[LiveScrollView alloc] initWithFrame:frame];
    self.scView.pageNum = kSegmentTittles.count;
    self.scView.dgt = self;
    self.scView.backgroundColor = LTBgColor;
    [self.view addSubview:self.scView];
    
    self.inMoneyVC = [[MoneyRecordListVCtrl alloc] init];
    self.outMoneyVC = [[MoneyRecordListVCtrl alloc] init];
    
    self.inMoneyVC.delegate = self;
    self.outMoneyVC.delegate = self;
    
    self.inMoneyVC.typ = MoneyRecordType_in;
    self.outMoneyVC.typ = MoneyRecordType_out;
    
    [self.scView setView:self.inMoneyVC.view toIndex:0];
    [self.scView setView:self.outMoneyVC.view toIndex:1];
    
    self.inMoneyVC.tableView.layer.masksToBounds = NO;
    self.outMoneyVC.tableView.layer.masksToBounds = NO;
    
}



#pragma mark - MoneyRecordDelegate

- (void)pushDetails:(MoneyRecordMO *)mo typ:(MoneyRecordType)typ {
    MoneyRecordDeatilVCtrl *ctrl = [[MoneyRecordDeatilVCtrl alloc] init];
    ctrl.mo = mo;
    ctrl.typ = typ;
    [self pushVC:ctrl];
}


#pragma mark - SegmentViewDelegate

- (void)selectIdx:(NSInteger)idx {
    NSLog(@"selectIdx == %li",idx);
    [self.scView moveToIdx:idx];
    
    if (idx == 0) {
        [self.inMoneyVC.tableView.header beginRefreshing];
    } else {
        [self.outMoneyVC.tableView.header beginRefreshing];
    }
}

#pragma mark - LiveScrollViewDelegate

- (void)scrollTo:(NSInteger)idx {
    NSLog(@"selectIdx == %li",idx);
    [self.segmentView moveToIdx:idx];
}


@end
