//
//  RechargeWebView.m
//  Canary
//
//  Created by bcw on 2019/3/12.
//  Copyright © 2019 litong. All rights reserved.
//

#import "RechargeWebView.h"
#import <WebKit/WebKit.h>
@interface RechargeWebView ()<UIWebViewDelegate>

@end

@implementation RechargeWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebView* webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, NavBarTop_Lit, Screen_width, Screen_height - NavBarTop_Lit)];
//    webView.delegate = self;
    NSURL *url = [NSURL URLWithString:_urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    [self configNavBar];
}
- (void)configNavBar {
    //    [self navTitle:@"交易" backType:BackType_Non rightImgName:@"live_btn_service"];
    [self navTitle:@"交易"];
    //    [self addLeftImageBtn:@"navIcon_tip"];
}

- (void)leftAction {
    NSString *url = URL_DealRule;
    [self pushWeb:url title:@"交易规则"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
