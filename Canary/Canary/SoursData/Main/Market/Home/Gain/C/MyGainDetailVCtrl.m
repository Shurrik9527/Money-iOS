//
//  MyGainDetailVCtrl.m
//  ixit
//
//  Created by litong on 2016/11/20.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "MyGainDetailVCtrl.h"
#import "MyGainModel.h"
#import "MyGainDetailView.h"
//#import "UMSocial.h"
//#import "UMSocialWechatHandler.h"

@interface MyGainDetailVCtrl ()
//<UMSocialUIDelegate>

@property (nonatomic,strong) MyGainModel *myGainMo;
@property (nonatomic,strong) MyGainDetailView *gainCell;
@property (nonatomic,strong) UIButton *shareBtn;

@property(retain,nonatomic)UIImageView * shareimg;
@property(copy,nonatomic)NSString * shareUrl;
@property(copy,nonatomic)NSString * content;

@end

@implementation MyGainDetailVCtrl

- (instancetype)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = LTBgColor;
        [self navTitle:@"我的交易记录" backType:BackType_PopVC];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createGainCell];
    [self createShareBtn];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configData:(id)mo {
    NSLog(@"11");
    if ([mo isKindOfClass:[MyGainModel class]]) {
        _myGainMo = mo;
        
        [_gainCell refData:_myGainMo];
        
    } else {
        
    }
    
    [self canShowBtn];
    
}

- (void)loadData {
    if (!_myGainMo) {
        
    }
}

- (void)canShowBtn {
    BOOL canShow = [LTUtils noHide];
    
    if (canShow && [_myGainMo.profitLoss floatValue] > 0) {
        _shareBtn.hidden = NO;
    } else {
        _shareBtn.hidden = YES;
    }
    
}

- (void)createGainCell {
    self.gainCell = [[MyGainDetailView alloc] initWithFrame:CGRectMake(0, LTAutoW(12)+NavBarTop_Lit, self.w_, LTAutoW(MyGainDetailViewH))];
    [self.view addSubview:_gainCell];
}

- (void)createShareBtn {
    CGFloat x = LTAutoW(kLeftMar);
    CGFloat btnW = self.w_-2*x;
    CGFloat btnH = 45;
    self.shareBtn = [UIButton btnWithTarget:self action:@selector(shareAction) frame:CGRectMake(x, _gainCell.yh_+LTAutoW(20), btnW, btnH)];
    [_shareBtn layerRadius:3 bgColor:LTSureFontBlue];
    [self.view addSubview:_shareBtn];
    
    CGFloat labw = 126;
    CGFloat labh = 20;
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = CGRectMake((btnW - labw)/2.0, (btnH - labh)/2.0, labw, labh);
    lab.textAlignment = NSTextAlignmentRight;
    lab.text = @"晒单到朋友圈";
    lab.textColor = LTWhiteColor;
    lab.font = [UIFont fontOfSize:15];
    [_shareBtn addSubview:lab];
    
    UIImageView *iv = [[UIImageView alloc] init];
    iv.image = [UIImage imageNamed:@"wxIcon"];
    iv.frame = CGRectMake(0, 0, labh, labh);
    [lab addSubview:iv];
  
}






- (void)shareAction {
//    if (notemptyStr(_shareUrl)) {
//        [UMSocialData defaultData].extConfig.wechatTimelineData.title = _content;
//        [UMSocialData defaultData].extConfig.wechatTimelineData.url = _shareUrl;
//        [UMSocialWechatHandler setWXAppId:UMeng_wechatAppID appSecret:UMeng_wechatAppSecret url:_shareUrl];
//        [UMSocialSnsService presentSnsIconSheetView:self
//                                             appKey:kUmeng_appkey
//                                          shareText:_content
//                                         shareImage:[UIImage imageNamed:@"shareLogo"]
//                                    shareToSnsNames:@[UMShareToWechatTimeline]
//                                           delegate:self];
//        
//    } else {
//        [self getShareUrl];
//    }
}

- (void)getShareUrl {
    [self showLoadingWithMsg:@"加载中"];
    #warning 暂时注释
//    WS(ws);
//    NSNumber *oid = @([_myGainMo.orderId integerValue]);
//    [RequestCenter requestShareActivityURLWithExchangeId:@(_myGainMo.exchangeId) OrderId:oid finish:^(LTResponse *res) {
//        [ws hideLoadingView];
//        
//        if (res.success) {
//            NSDictionary *dic = res.resDict;
//            if (dic.count > 0) {
//                ws.shareUrl = [dic objectForKey:@"shareUrl"];
//                ws.content = [dic objectForKey:@"content"];
//                [ws shareAction];
//            } else  {
//                [LTAlertView alertMessage:res.message];;
//            }
//        } else {
//            [LTAlertView alertMessage:res.message];;
//        }
//    }];
}

- (void)shareSuccess {
    #warning 暂时注释
//    WS(ws);
//    NSNumber *oid = @([_myGainMo.orderId integerValue]);
//    [RequestCenter requestShareActivitysuccessWithExchangeId:@(_myGainMo.exchangeId) OrderId:oid finish:^(LTResponse *res) {
//        if (res.success) {
////            [LTAlertView alertMessage:res.message];;
//            [ws.view showSuccessWithTitle:@"晒单成功!"];
//            [[NSNotificationCenter defaultCenter] postNotificationName:NFC_ShareGainSuccess object:nil];
//        } else {
//            NSLog(@"getShareUrlError");
//        }
//    }];
}

#warning 暂时注释
//- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
//    //根据`responseCode`得到发送结果,如果分享成功
//    if(response.responseCode == UMSResponseCodeSuccess) {
//        //得到分享到的微博平台名
//        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
//        [self shareSuccess];
//    }
//}




@end
