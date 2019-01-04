//
//  LiveDetailVCtrl+QuickDeal.m
//  ixit
//
//  Created by litong on 2017/3/13.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "LiveDetailVCtrl+QuickDeal.h"
#import "LiveDetailVCtrl+SendGift.h"
#import "AppDelegate.h"

@implementation LiveDetailVCtrl (QuickDeal)


#pragma mark - 快速交易

- (void)createQuickDealView {
    CGFloat y = (self.contentView.h_ - kQuickDealViewH)/2.0;
    CGRect frame = CGRectMake(self.w_ - kQuickDealViewW, y, kQuickDealViewW, kQuickDealViewH);
    self.quickDealView = [[QuickDealListView alloc] initWithFrame:frame];
    [self.contentView addSubview:self.quickDealView];
    WS(ws);
    [self.quickDealView setQuickDealBlock:^(NSInteger row) {
        [ws clickQuickBtn:row];
    }];
    
    [self createSellView];
}

- (void)clickQuickBtn:(NSInteger)row {
    if (row == 0) {
        JudgeUserCanUseDeal;
        [self showSelectProductView];
    }
    else if (row == 1) {
        JudgeUserCanUseDeal;
        [self showSellProduct:YES];
    }
    else {
        [self popToRootVC];
        [AppDelegate selectTabBarIndex:1];
    }
}



#pragma mark - 选择产品

//选择产品页
- (void)createSelectProductView {
    self.selectProductView = [[SelectProductView alloc] initWithContentH:ScreenH_Lit - self.selectProductViewY];
    self.selectProductView.delegate = self;
    [self.view addSubview:self.selectProductView];
}

- (void)showSelectProductView {
    if (self.productList.count == 0) {
        [self loadProductList:YES refSelectProuct:YES needShow:YES];
    } else {
        [self.selectProductView configDatas:self.productList];
        [self.selectProductView showView:YES];
    }
}

// 产品列表
- (void)loadProductList {
    [self loadProductList:NO refSelectProuct:NO needShow:NO];
}

//- (void)loadProductList:(BOOL)showError refSelectProuct:(BOOL)refSelectProuct needShow:(BOOL)needShow {
//    WS(ws);
//    if (showError) {
//        [self showLoadingView];
//    }
//    [RequestCenter reqProductList:^(LTResponse *res) {
//        if (showError) {
//            [ws hideLoadingView];
//        }
//        if (res.success) {
//            ws.productList = nil;
//            ws.productList = [NSArray arrayWithArray:resList];
//            if (refSelectProuct) {
//                [ws.selectProductView configDatas:resList];
//            }
//            if (needShow) {
//                [ws showSelectProductView];
//            }
//        } else {
//            if (showError) {
//                [ws.view showTip:res.message];
//            }
//        }
//    }];
//}


#pragma mark - 平仓

- (void)createSellView {
    self.sellProductView = [[SellProductView alloc] initWithContentY:self.sellProductViewY];
    [self.view addSubview:self.sellProductView];
    
    WS(ws);
    [self.sellProductView setShutView:^(ExchangeType exType) {
        [ws canclePollingHoldList];
    }];
    
    [self.sellProductView setSellFinish:^(NSString *msg,NSString *code) {
        [ws.view showSuccessWithTitle:msg];
    }];
}


- (void)showSellProduct:(BOOL)show {
    
    BOOL canNotNext = [self checkTimeOut];
    if (canNotNext) { return; }

    [self.view showLoadingView];
    [self loadHoldListDataOnce];
}


- (void)loadHoldListDataOnce {

}

- (void)loadHoldDatasPolling {
}

//持仓轮询
- (void)pollingHoldList {
    [self canclePollingHoldList];
    
    NSLog(@"持仓轮询开启11111111111");
//    [self loadHoldDatasOnce:YES];
    
    self.holdListTimer = [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(loadHoldDatasPolling) userInfo:nil repeats:YES];
}

//取消持仓轮询
- (void)canclePollingHoldList {
    if (self.holdListTimer) {
        NSLog(@"持仓轮询关闭000000000");
        [self.holdListTimer setFireDate:[NSDate distantFuture]];
        [self.holdListTimer invalidate];
        self.holdListTimer = nil;
    }
}



@end
