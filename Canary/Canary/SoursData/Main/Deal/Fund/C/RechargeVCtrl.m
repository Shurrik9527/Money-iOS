//
//  RechargeVCtrl.m
//  Canary
//
//  Created by litong on 2017/5/16.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "RechargeVCtrl.h"
#import "MJRefresh.h"

@interface RechargeVCtrl ()<UIWebViewDelegate>

@property (nonatomic,strong) NSString *rechargeUrl;//	充值URL
@property (nonatomic,strong) NSString *callBackUrl	;//	fxbtg回调URL

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation RechargeVCtrl

- (instancetype)init {
    self = [super init];
    if (self) {
        [self navPopBackTitle:@"入金"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)createWebView {
    if (!_webView) {
        CGFloat y = 44;
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        _webView.frame = CGRectMake(0, y, self.w_, self.h_ - y);
        _webView.backgroundColor = LTClearColor;
        _webView.opaque = NO;
        [self.view addSubview:_webView];
        [self.view sendSubviewToBack:_webView];
        [self loadWebView];
    }
}

- (void)configBackType:(BackType)backType {
    self.backType = backType;
    CGFloat y = (self.backType == BackType_Dismiss) ? NavBarTop_Lit : 44;
    [self.webView setOY:y];
}

#pragma mark - 添加刷新控件头部

- (void)addMJHeader {
    WS(ws);
    [_webView.scrollView addLegendHeaderWithRefreshingBlock:^{
        NSURLRequest *request = [NSURLRequest requestWithURL:[ws.rechargeUrl toURL]];
        [ws.webView loadRequest:request];
        request = nil;
    }];
}


- (void)reqRechargeUrl {
    WS(ws);
    [RequestCenter reqRechargeWithNotifyUrl:@"" finsh:^(LTResponse *res) {
        if (res.success) {
            NSDictionary *dict = res.resDict;
            ws.rechargeUrl = [dict stringFoKey:@"rechargeUrl"];
            ws.callBackUrl = [dict stringFoKey:@"callBackUrl"];
            [ws loadWebView];
        } else {
            [ws.view showTip:res.message];
        }
    }];
}

- (void)loadWebView {
    if (_rechargeUrl) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[_rechargeUrl toURL]];
        [_webView loadRequest:request];
        request = nil;
    } else {
        [self reqRechargeUrl];
    }
}




#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"req baseURL =====   %@",request.URL.baseURL);
    NSLog(@"req absoluteString =====   %@",request.URL.absoluteString);
    NSLog(@"req absoluteURL =====   %@",request.URL.absoluteURL);
    NSLog(@"req scheme =====   %@",request.URL.scheme);
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showLoadingView];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [_webView.scrollView.header endRefreshing];
    [self hideLoadingView];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_webView.scrollView.header endRefreshing];
    [self hideLoadingView];
    NSLog(@"");
}



@end
