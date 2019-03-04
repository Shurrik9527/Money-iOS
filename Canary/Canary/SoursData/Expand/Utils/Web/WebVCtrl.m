//
//  WebVCtrl.m
//  Canary
//
//  Created by litong on 2017/5/12.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "WebVCtrl.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "JSObj.h"
#import "RechargeVCtrl.h"
#import "ShareVCtrl.h"

#define kVideoHandlerScheme @"videohandler"
#define kVideoHeight 310
#define kVideoPaddingTop 35

@interface WebVCtrl ()<UIWebViewDelegate,JSObjDelegate>

@property(strong,nonatomic)UIView * videoBox;
@property (nonatomic,assign) BOOL isLiveVideo;
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) NSURL *url;
@property (nonatomic,assign) BOOL loginSuccess;

@property(copy,nonatomic)NSString * shareUrl;
@property(copy,nonatomic)NSString * content;
@property(copy,nonatomic)NSString * callback;


@property (nonatomic,copy) NSString *ADTitle;
@property (nonatomic,copy) NSString *ADUrl;

@end

@implementation WebVCtrl

- (instancetype)initWithTitle:(NSString *)title url:(NSURL *)url {
    return [self initWithTitle:title url:url returnType:BackType_Dismiss];
}

- (instancetype)initWithTitle:(NSString*)title url:(NSURL*)url returnType:(BackType)returnType {
    if (self == [super init]) {
        [self navTitle:title backType:returnType];
        _url = [NSURL URLWithString:[LTUtils urlAddDefaultPrams:url]];
        [self createWebView];
    }
    return self;
}

- (instancetype)initWithADTitle:(NSString*)title url:(NSURL*)url {
    if (self == [super init]) {
        [self navTitle:title backType:BackType_Dismiss];
        _url = [NSURL URLWithString:[LTUtils urlAddDefaultPrams:url]];
        [self createWebView];
        [self reqDetailAD];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view endEditing:YES];
    [self cleanCacheAndCookie];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"WebView dealloc!!!");
    _webView=nil;
    
}

- (void)configBackType:(BackType)backType {
    self.backType = backType;
    CGFloat y = (self.backType == BackType_Dismiss) ? NavBarTop_Lit : 44;
    [self.webView setOY:y];
}

- (void)createWebView {
    CGFloat paddingTop = 0;
    if (_isLiveVideo) {
        paddingTop = kVideoPaddingTop;
    }
    
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.backgroundColor = LTClearColor;
        CGFloat y = 44;
        CGRect rect = CGRectMake(0, StateBarHeight + y - paddingTop,ScreenW_Lit, ScreenH_Lit - y + paddingTop - StateBarHeight);
        _webView.frame = rect;
        _webView.opaque = NO;
        _webView.delegate = self;
        [_webView setScalesPageToFit:YES];
        [self.view addSubview:_webView];
        [self.view sendSubviewToBack:_webView];
        [self addMJHeader];
        if (_url) {
            

            NSURLRequest *request = [NSURLRequest requestWithURL:_url];
            [_webView loadRequest:request];
            request = nil;
        }
    }
    
    if (_isLiveVideo) {
        // 注册视频通知
        if (iOSSystemVersion < 7.0) {
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(noApplePush)
                                                         name:@"UIMoviePlayerControllerDidEnterFullscreenNotification"
                                                       object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(receiveApplePush)
                                                         name:@"UIMoviePlayerControllerDidExitFullscreenNotification"
                                                       object:nil];
            
        } else if (iOSSystemVersion < 8.0) {
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(noApplePush)
                                                         name:@"UIWindowDidBecomeHiddenNotification"
                                                       object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(receiveApplePush)
                                                         name:@"UIWindowDidBecomeVisibleNotification"
                                                       object:nil];
            
        } else {
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(receiveApplePush)
                                                         name:@"UIWindowDidBecomeHiddenNotification"
                                                       object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(noApplePush)
                                                         name:@"UIWindowDidBecomeVisibleNotification"
                                                       object:nil];
        }
    }
    
    //     [self showLoadingWithMsg:nil];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [_webView.scrollView.header endRefreshing];
    if (_isLiveVideo) {
        NSString *js = [self playVideoJsonString];
        js = [NSString stringWithFormat:@"%@", js];
        [webView stringByEvaluatingJavaScriptFromString:js];
    }
    [self hideLoadingView];

    [self jsAciont];
}

- (NSString *)playVideoJsonString {
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"playVideo" ofType:@".js"];
    NSString *jsonstr = [NSString stringWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:nil];
    
    return jsonstr;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_webView.scrollView.header endRefreshing];
}

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *url = request.URL.relativeString;
    
    if ([url containsString:@"touzile://"] ||
        [url containsString:@"8caopan://"] ||
        [url containsString:@"caopan8://"]) {
        
        [self skipWithStr:url];
        return NO;
    }
    _redirectUrlStr=_redirectUrlStr?_redirectUrlStr:@"";
    if (![url isEqualToString:_url.absoluteString] && [url containsString:_redirectUrlStr])
    {
//        if (!_exType) {
//            _exType = kCurrentExchangeType;
//        }
//        
//        WS(ws);
//        [RequestCenter requestExchangeRegister:_mobile exType:_exType urlStr:url completion:^(LTResponse *res) {
//            if (res.success) {
//                ws.loginSuccess = YES;
//                [self leftAction];
//            } else {
//                ws.loginSuccess = NO;
//                NSLog(@"error");
//            }
//        }];
        
    }
    
    if ([url rangeOfString:@"record.m3u8?sessionid="].location != NSNotFound) {
        // 捕捉视频地址
        url = [url substringFromIndex:[url rangeOfString:@"http://"].location];
        url = [url substringToIndex:[url rangeOfString:@";"].location];
    }
    
    if ([url rangeOfString:kVideoHandlerScheme].location != NSNotFound && _isLiveVideo) {
        NSLog(@"%@", request.URL); //在这里可以获得事件
        // 加载视频
        if (_videoBox.superview) {
            [_videoBox removeFromSuperview];
            _videoBox = nil;
        }
        CGFloat h = kVideoHeight;
        if (self.header.hidden) {
            h = Screen_height;
        }
        _videoBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _webView.frame.size.width, h)];
        _videoBox.backgroundColor = LTClearColor;
        _videoBox.userInteractionEnabled = NO;
        [_webView addSubview:_videoBox];
        [self showLoadingView];
        return NO;
    }
    return YES;
}

#pragma mark - utils


- (void)skipWithStr:(NSString *)str {
    if ([LTUser hasLogin]) {
        if ([LTUtils schemeRegister:str]) {
            [self.view showTip:@"您已注册"];
        }
    };
    
    // 跳转到注册页面（已登录状态跳转到交易界面）
    if (![LTUser hasLogin] || [LTUtils schemeRegister:str]) {
        
        LoginVCtrl *ctrl = [[LoginVCtrl alloc] init];
        [self pushVC:ctrl];
        
    } else {
        
        
        WS(ws);
        
        if ([LTUtils schemeCashin:str]) {
            // 充值界面
            BOOL tokenTimeout = [self checkTimeOut];
            if (tokenTimeout) {
                return;
            }
            RechargeVCtrl *ctrl = [[RechargeVCtrl alloc] init];
            [ctrl configBackType:BackType_Dismiss];
            [self presentVC:ctrl];
        }
        
        else if ([LTUtils schemeTrade:str]) {
            // 交易界面
            [self dismissViewControllerAnimated:NO completion:^{
                [AppDelegate selectTabBarIndex:TabBarType_Deal];
                [ws.navigationController popViewControllerAnimated:NO];
            }];
        }
        
        else if ([LTUtils schemeShare:str]) {
            // 分享页面
//            [self sharePush];
            
            ShareVCtrl *ctrl = [[ShareVCtrl alloc] initWithBackType:BackType_Dismiss];
            [self presentVC:ctrl];
        }
        
        else if ([LTUtils schemeMarket:str]) {
            [self dismissViewControllerAnimated:NO completion:^{
                //看行情界面
                [AppDelegate selectTabBarIndex:TabBarType_Market];
                [ws.navigationController popViewControllerAnimated:NO];
            }];
        }
        
        else if ([LTUtils schemeLiveList:str]) {
            [self dismissViewControllerAnimated:NO completion:^{
                // 跳转直播室
                [self.view showTip:@"暂无直播"];
//                [AppDelegate selectTabBarIndex:TabBarType_Live];
//                [ws.navigationController popViewControllerAnimated:NO];
            }];
        }
        
    }
    
}

- (void)leftAction {
    
    if (_useGoBack && [_webView canGoBack]) {
        [_webView goBack];
        return;
    }
    
    if (_loginSuccess) {
        self.successBack ? self.successBack() : nil;
    } else {
        self.failureBack ? self.failureBack() : nil;
    }
    [super leftAction];
}

- (void)noApplePush {
    NSLog(@"------进入--------");
    [self hideLoadingView];
}

- (void)receiveApplePush {
    NSLog(@"------退出--------");
}
/**清除缓存和cookie*/
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}


#pragma mark - JSObjDelegate

- (void)openShare:(NSString *)title url:(NSString *)url {
    [self sharePush:title url:url];
}

- (void)shareByJson:(NSString *)jsonStr {
    NSDictionary *dict = [jsonStr jsonStringToDictonary];
    NSString *title = [dict stringFoKey:@"title"];
    NSString *url = [dict stringFoKey:@"url"];
    NSString *pic = [dict stringFoKey:@"pic"];
    NSString *content = [dict stringFoKey:@"content"];
    _callback = [dict stringFoKey:@"callback"];
    self.shareHasWechatTimelineAndWechatSession = YES;
    [self sharePush:url title:title content:content logo:pic];
}

#pragma mark - js

- (void)jsAciont {
    //    http://www.8caopan.com/a/2016120501ril/
    //onclick="share.openShare( '八元官微上线','http://www.8caopan.com/static/user/order/share/')
    
    //http://t.w.8caopan.com/activity/hyyq/?userId=125068&sourceId=10
    //<img src="" width="200" height="200" onClick=“share.shareByJson(‘jsonString’)”/>
    
    JSContext *jsContext = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    JSObj *jsObj = [JSObj new];
    jsObj.delegate = self;
    jsContext[@"share"] = jsObj;
}


#pragma mark - 广告

- (void)reqDetailAD {
//    WS(ws);
//    [RequestCenter reqNewsDetailAD:^(LTResponse *res) {
//        if (res.success) {
//            NSArray *arr = [res.resArr copy];
//            if (arr.count > 0) {
//                NSDictionary *dict = arr[0];
//                NSString *ADTitle = [dict stringFoKey:@"text"];
//                if (notemptyStr(ADTitle)) {
//                    ws.ADTitle = ADTitle;
//                    ws.ADUrl = [dict stringFoKey:@"link"];
//                    [ws refView];
//                }
//            }
//        }
//    }];
}

- (void)refView {
    UIButton *rightBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.header addSubview:rightBt];
    rightBt.layer.cornerRadius = 5;
    NSString *ADTitle = _ADTitle;
    UIFont *font = [UIFont systemFontOfSize:15];
    CGSize size = [ADTitle boundingSize:CGSizeMake(MAXFLOAT, 15) font:font];
    CGFloat rw = size.width+10;
    [rightBt setTitle:ADTitle forState:UIControlStateNormal];
    rightBt.titleLabel.font = font;
    [rightBt setTitleColor:LTBgColor forState:UIControlStateNormal];
    [rightBt addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-10));
        make.width.equalTo(@(rw));
        make.height.equalTo(@25);
        make.centerY.equalTo(@0);
    }];
}

- (void)rightBtnAction {
    if (notemptyStr(_ADUrl) && notemptyStr(_ADTitle)) {
        [self presentWeb:_ADUrl title:_ADTitle];
    } else {
        [self.view showTip:@"链接错误，请联系客服"];
    }
}



#pragma mark - 添加刷新控件头部
- (void)addMJHeader {

    [_webView.scrollView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];

}

- (void)headerRereshing {
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [_webView loadRequest:request];
}

#pragma mark - 分享

- (void)getShareUrl {
//    WS(ws);
//    [RequestCenter requestShareURL:^(LTResponse *res) {
//        if (res.success) {
//            NSDictionary *datadic= res.resDict;
//            ws.shareUrl=[datadic objectForKey:@"shareUrl"];
//            ws.content=[datadic objectForKey:@"content"];
//            [ws sharePush];
//        } else {
//            NSLog(@"getShareUrlError");
//        }
//    }];
    
}

//分享按钮动作
//- (void)sharePush {
//    if (!_shareUrl){
//        [self getShareUrl];
//    } else {
//        
//        NSArray *shareToSnsNames = @[UMShareToWechatTimeline];
//        if (self.shareHasWechatTimelineAndWechatSession) {
//            shareToSnsNames = @[UMShareToWechatSession,UMShareToWechatTimeline];
//        }
//        
//        UMengEvent(web_share_click);
//        [UMSocialData defaultData].extConfig.wechatTimelineData.title = _content;
//        [UMSocialData defaultData].extConfig.wechatTimelineData.url = _shareUrl;
//        [UMSocialWechatHandler setWXAppId:UMeng_wechatAppID appSecret:UMeng_wechatAppSecret url:_shareUrl];
//        [UMSocialSnsService presentSnsIconSheetView:self
//                                             appKey:kUmeng_appkey
//                                          shareText:_content
//                                         shareImage:[UIImage imageNamed:@"shareLogo"]
//                                    shareToSnsNames:shareToSnsNames
//                                           delegate:self];
//    }
//}
//
- (void)sharePush:(NSString *)title url:(NSString *)url {
//    if (!url) {
//        [self.webview showTip:@"分享链接为空，稍后重试"];
//        return;
//    }
//    
//    NSArray *shareToSnsNames = @[UMShareToWechatTimeline];
//    if (self.shareHasWechatTimelineAndWechatSession) {
//        shareToSnsNames = @[UMShareToWechatSession,UMShareToWechatTimeline];
//    }
//    
//    UMengEvent(web_share_click);
//    [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
//    [UMSocialWechatHandler setWXAppId:UMeng_wechatAppID appSecret:UMeng_wechatAppSecret url:url];
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:kUmeng_appkey
//                                      shareText:title
//                                     shareImage:[UIImage imageNamed:@"shareLogo"]
//                                shareToSnsNames:shareToSnsNames
//                                       delegate:self];
}
//
- (void)sharePush:(NSString *)url title:(NSString *)title content:(NSString *)content logo:(id)logo {
//    if (!url) {
//        [self.webview showTip:@"分享链接为空，稍后重试"];
//        return;
//    }
//    
//    
//    logo = [UIImage imageNamed:@"shareLogo"];
//    
//    
//    NSArray *shareToSnsNames = @[UMShareToWechatTimeline];
//    if (self.shareHasWechatTimelineAndWechatSession) {
//        shareToSnsNames = @[UMShareToWechatSession,UMShareToWechatTimeline];
//    }
//    
//    UMengEvent(web_share_click);
//    [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
//    [UMSocialWechatHandler setWXAppId:UMeng_wechatAppID appSecret:UMeng_wechatAppSecret url:url];
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:kUmeng_appkey
//                                      shareText:content
//                                     shareImage:logo
//                                shareToSnsNames:shareToSnsNames
//                                       delegate:self];
}


#pragma mark UMShareDelegate

//- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
//    //根据`responseCode`得到发送结果,如果分享成功
//    if(response.responseCode == UMSResponseCodeSuccess) {
//        //得到分享到的微博平台名
//        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
//        UMengEvent(web_share_success);
//        
//        [self shareSuccess];
//    }
//}
//
//- (void)shareSuccess {
//    
//    [self.view showLoadingWithMsg:@"分享成功"];
//    if (_callback) {
//        WS(ws);
//        [RequestCenter reqSharesuccess:_callback finish:^(LTResponse *res) {
//            [ws.view hideLoadingView];
//            
//            if (res.success) {
//                [ws JSShareSuccessBlock];
//            } else  {
//                
//            }
//        }];
//    }
//    
//}

- (void)JSShareSuccessBlock {
    _webJSShareSuccessBlock ? _webJSShareSuccessBlock() : nil;
}


@end
