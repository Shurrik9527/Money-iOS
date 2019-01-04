//
//  LiveDetailVCtrl.m
//  ixit
//
//  Created by litong on 16/10/26.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "LiveDetailVCtrl.h"
#import "PlayView.h"
#import "Masonry.h"
#import "LitMaskView.h"
#import "OutcryVCtrl.h"
#import "ProductMO.h"

#import "LiveDetailVCtrl+ChatRoom.h"
#import "LiveDetailVCtrl+QuickDeal.h"
#import "LiveDetailVCtrl+SendGift.h"

#import "AnalystVCtrl.h"
#import "UIView+LTAnimation.h"


static CGFloat wh = 44;
static CGFloat priceViewH = 36;
static CGFloat segmentViewH = 40;

@interface LiveDetailVCtrl ()<NIMChatroomManagerDelegate,UIGestureRecognizerDelegate,PlayViewDelegate,SegmentViewDelegate,LiveScrollViewDelegate,NIMChatManagerDelegate>
{
    CGFloat PlayHeight;
    BOOL isCloseLivePlay;//是否关闭播放器，只看文字直播和聊天
    BOOL isFullScreen;//是否全屏
    BOOL isShowNav;
    NSInteger personNum;//观看视频人数
    
}
/** 播放器view */
@property (nonatomic,strong) PlayView *playView;

/** 按钮：是否全屏播放 */
@property (nonatomic,strong) UIButton *fullPlayBtn;
@property (nonatomic,strong) OutcryVCtrl *outchryCtrl;
@property (nonatomic,strong) AnalystVCtrl *analystVCtrl;

@property(retain,nonatomic)UILabel * noteLab;/*<警告提示语*/

/** 修改交易所类型 */
@property (nonatomic,strong) UIButton *changeEXBtn;

@property (nonatomic,copy) NSString *curCodes;

@end

@implementation LiveDetailVCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.needHideGift = NO;
    personNum=[self.liveModel.onlineNumber integerValue];
//    self.exType = UD_SelLiveExchangeType;
    [self configFloatingRtmpStream];
    
    PlayHeight = [LiveDetailVCtrl playViewHeight];
    [self createPlayerView];//播放器
    [self createFullBtn];//全屏按钮
    
    [self createNavView];//navBar
    
    //内容view ：价格波动View、文字直播&聊天室切换bar、具体内容scrollview
    [self creatContentView];
    [self reqQuotationList];
    //快速交易view
    [self createQuickDealView];
    [self createSelectProductView];
    
    
    self.canSendPic = self.liveModel.canSendPic;
    [self enterChatRoom];//进入聊天室
    
    [self createGiftListView];
    [self reqGiftList];
    [self reqLiveWatchUserAdd];

    [self loadProductList];
    
    [self showPersonNum:personNum];

    [self addObservers];

    [LitMaskView onceIntoLivePlay];
    
    if([self checkShowNoticeTip]){
        [self createTipsWithMessage:AnnouncementStr time:10];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = LTRGB(36, 39, 62);
    
    [self startSocketServe];
    [self pollingBlackList];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [LTSocketServe stopRTC];
    [self canclePollingBlackList];
    [LitMaskView removeAllMaskView];
}

- (void)dealloc {
    NSLog(@"Live dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - init

//播放器高度
+ (CGFloat)playViewHeight {
    //    return (Screen_height<=480) ? 0.4 *Screen_width : 9/16.0 *Screen_width;
    //    return (Screen_height<=480) ? 0.4 *Screen_width : LTAutoW(219.5);
    return (Screen_height<=480) ? 0.4 *Screen_width : LTAutoW(226);
}

//播放器View
- (void)createPlayerView {
    self.playView = [[PlayView alloc] initWithFrame:CGRectMake(0, 20, self.w_, PlayHeight) liveModel:self.liveModel];
    self.playView.delegate = self;
    [self.view addSubview:self.playView];
}

//全屏按钮
- (void)createFullBtn {
    CGRect frame = CGRectMake(self.playView.w_ - wh, self.playView.h_ - wh - 20, wh, wh);
    self.fullPlayBtn = [UIButton btnWithTarget:self action:@selector(clickFullBtn) frame:frame imgName:@"fullPlayViewIcon" selImgName:@"nofullPlayViewIcon"];
    [self.playView addSubview:self.fullPlayBtn];
}
//YES:(隐藏)移除屏幕  NO(显示):进入屏幕
- (void)fullBtnMoveHiden:(BOOL)bl {
    CGRect frame = self.fullPlayBtn.frame;
    if (bl) {//移除屏幕
        frame.origin.x +=wh;
    } else {
        frame.origin.x -=wh;
    }
    self.fullPlayBtn.frame = frame;
}

//NavView
- (void)createNavView {
    NSString *titleStr = self.liveModel ? self.liveModel.channelName : @"聊天室";
    
    [self navTitle:titleStr backType:BackType_PopVC rightImgName:@"closePlayViewIcon" rightSelImgName:@"showPlayViewIcon"];
    [self.header.backButton removeTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [self.header.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIColor *color = LTRGBA(36, 39, 62, 0.8);
    self.header.backgroundColor=color;
    
    [self afterHideNav];
}

- (CGFloat)selectProductViewY {
    return self.contentView.y_ - LTAutoW(6.5);
}

- (CGFloat)buyProductViewY {
    return self.contentView.y_ - LTAutoW(6.5);
}

- (CGFloat)sellProductViewY {
    return self.contentView.y_ + priceViewH;
}

//内容view ：价格波动View、文字直播&聊天室切换bar、具体内容scrollview
- (void)creatContentView {
    self.contentView = [[UIView alloc] init];
    self.contentView.frame = CGRectMake(0, PlayHeight, self.w_, self.h_ - PlayHeight);
    self.contentView.backgroundColor = LTWhiteColor;
    [self.view addSubview:self.contentView];
    
    [self createPriceTipView];
    [self createSegmentView];
    [self createScrollView];
    [self createNoteLab];
}

//价格波动View
- (void)createPriceTipView {
    CGRect frame = CGRectMake(0, 0, self.w_, priceViewH);
    self.priceTipView = [[LiveQuotationView alloc] initWithFrame:frame];
    [self.contentView addSubview:self.priceTipView];
}




//文字直播&聊天室切换bar
- (void)createSegmentView {
    self.segmentView = [[SegmentView alloc] init];
    self.segmentView.frame = CGRectMake(0, priceViewH, self.w_, segmentViewH);
    [self.segmentView setTitles:@[@"聊天室",@"文字直播",@"分析师"]];
    self.segmentView.delegate = self;
    [self.contentView addSubview:self.segmentView];
}

- (void)createScrollView {
    
    CGFloat y = self.segmentView.yh_;
    CGFloat h = self.contentView.h_ - y;
    CGRect frame = CGRectMake(0, y, self.w_, h);
    self.scView = [[LiveScrollView alloc] initWithFrame:frame];
    self.scView.pageNum = 3;
    self.scView.dgt = self;
    self.scView.backgroundColor = LTBgColor;
    [self.contentView addSubview:self.scView];
    
    
    self.outchryCtrl = [[OutcryVCtrl alloc] init];
    self.outchryCtrl.rid = self.liveModel.chatRoomId;
    [self.scView setView:self.outchryCtrl.view toIndex:1];
    self.outchryCtrl.tableView.layer.masksToBounds=NO;
   
    self.analystVCtrl = [[AnalystVCtrl alloc] init];
    self.analystVCtrl.liveModel = self.liveModel;
    [self.scView setView:self.analystVCtrl.view toIndex:2];
    self.analystVCtrl.tableView.layer.masksToBounds=NO;

}
-(void)createNoteLab{
    _noteLab=[[UILabel alloc]init];
    _noteLab.frame=CGRectMake(0,self.scView.h_-44,self.scView.w_,44);
    _noteLab.backgroundColor=LTBgColor;
    _noteLab.text=@"以上为分析师本人观点，不构成买卖依据，请谨慎交易！";
    _noteLab.textAlignment=NSTextAlignmentCenter;
    _noteLab.numberOfLines=0;
    _noteLab.textColor=LTSubTitleRGB;
    _noteLab.font=[UIFont systemFontOfSize:smallFontSize];
    _noteLab.tag=1002;
    [self resetNoteLabFrame];
    [self.scView addSubview:_noteLab];
}


- (void)configFloatingRtmpStream {
    NSString *rtmp = nil;
    if (self.liveModel.isLiving) {
        rtmp = self.liveModel.rtmpDownstreamAddress;
        kPublicData.liveMO = _liveModel;
    } else {
        kPublicData.liveMO = nil;
    }
    [UserDefaults setObject:rtmp forKey:FloatingRtmpStreamKey];
    
    
}


#pragma mark请求行情列表
- (void)reqQuotationList {
    WS(ws);
    NSString *codes = [LTUser homeProductListString];
    
    [RequestCenter requestQuotationDetailWithCodes:codes completion:^(LTResponse *res) {
        if (res.success) {
            NSArray *arr = res.resArr;
            NSArray *list = [Quotation objsWithList:arr];
            ws.priceTipView.pList = list;
        }
    }];
    
}
#pragma mark - 长连接

- (void)startSocketServe {
    [LTSocketServe sendRTCAll];
}


#pragma mark - action
-(BOOL)checkShowNoticeTip{
    NSString *nowTime = [LiveDetailVCtrl getNowDayString];
    NSString *oldTime = UD_ObjForKey(@"oldLiveTime");
    BOOL isShow=NO;
    if (emptyStr(oldTime)) {
        UD_SetObjForKey(nowTime, @"oldLiveTime");
        isShow = YES;
    }else{
        if (![nowTime isEqualToString:oldTime]) {
            isShow=YES;
            UD_SetObjForKey(nowTime, @"oldLiveTime");
        }
    }
    return isShow;
}
#pragma mark - 获取当前天数
+(NSString *)getNowDayString{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSLog(@"%@", localeDate);
    NSString *nowTime=[formatter stringFromDate:localeDate];
    return nowTime;
}
//点击返回按钮
- (void)backAction {
    if (isFullScreen) {
        [self clickFullBtn];
        return;
    }
    
    [self removeObservers];
    [self.playView play:NO];
    [self exitChatRoom];
    [self popVC];
    
    [self operationManagerRemoveAllData];
}


/**        点击右按钮
 
 视频       按钮图片    playview    contentView
 播放          x               显示              往下
 暂停         live             隐藏              往上
 */
- (void)rightBarAction {
    
    if (isFullScreen) {
        [self clickFullBtn];
        return;
    }
    
    isCloseLivePlay = !isCloseLivePlay;
    
    [self rightItemSelect:isCloseLivePlay];//按钮图片切换
    [self.playView play:!isCloseLivePlay];//是否播放视频
    
    if (isCloseLivePlay) {//无视频
        PlayHeight = 0;
        self.header.backgroundColor= LTTitleColor;
        self.contentView.frame = CGRectMake(0, 64, self.w_, self.h_ - 64);
        [self cancelPreviousPerform:@selector(hideNav)];
        self.tips.frame=CGRectMake(self.tips.x_, self.tipsViewY+64, self.w_ , LTAutoW(52));
    } else {
        PlayHeight = [LiveDetailVCtrl playViewHeight];
        self.header.backgroundColor=LTRGBA(36, 39, 62, 0.8);
        self.contentView.frame = CGRectMake(0, PlayHeight, self.w_, self.h_ - PlayHeight);
        [self afterHideNav];
        self.tips.frame=CGRectMake(self.tips.x_, self.tipsViewY, self.w_ , LTAutoW(52));
    }
    [self.scView changeAllFrameH:self.contentView.h_ - self.segmentView.yh_];
    [self resetNoteLabFrame];
}

//点击全屏按钮
- (void)clickFullBtn {
    
    isFullScreen = !isFullScreen;
    self.tips.hidden=YES;
    self.fullPlayBtn.selected = isFullScreen;
    [[UIApplication sharedApplication] setStatusBarHidden:isFullScreen withAnimation:UIStatusBarAnimationSlide];
    self.stateView.hidden=isFullScreen;
    self.contentView.hidden = isFullScreen;
    
    [self cancelPreviousPerform:@selector(hideNav)];
    [self afterHideNav];
    
    WS(ws);
    ws.playView.backgroundColor = LTGrayColor;
    if (isFullScreen) {//全屏
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //播放器相关
            [ws.playView rotate:M_PI_2];
            ws.playView.frame=CGRectMake(0, 0, Screen_width, Screen_height);
            [ws.playView playerFullScreen:YES];
            ws.fullPlayBtn.frame = CGRectMake(self.playView.h_ - wh, self.playView.w_ - wh, wh, wh);
            
            //Nav相关
            ws.header.transform=CGAffineTransformRotate(ws.view.transform, M_PI_2);
            ws.header.backgroundColor=LTRGBA(36, 39, 62, 0.8);
            ws.header.frame=CGRectMake(Screen_width-44,0, 44, Screen_height);
            ws.header.titler.frame=CGRectMake(0,0, Screen_height, 44);
            [ws rightItemFrame:CGRectMake(self.h_ - 44, 0, 44, 44)];
            
        } completion:nil];
        
    } else {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //播放器相关
            [ws.playView rotate:-M_PI_2];
            ws.playView.frame=CGRectMake(0, 20, Screen_width, PlayHeight);
            [ws.playView playerFullScreen:NO];
            ws.fullPlayBtn.frame = CGRectMake(self.playView.w_ - wh, self.playView.h_ - wh-20, wh, wh);
            
            //Nav相关
            ws.header.frame=CGRectMake(0, 20, Screen_width, ws.header.frame.size.height);
            ws.header.transform=ws.view.transform;
            ws.header.backgroundColor=LTRGBA(36, 39, 62, 0.8);
            ws.header.frame=CGRectMake(0,20, Screen_width, 44);
            ws.header.titler.frame=CGRectMake(0,0, Screen_width, 44);
            [ws rightItemFrame:CGRectMake(self.w_ - 44, 0, 44, 44)];
            
        } completion:nil];
    }
}
-(void)resetNoteLabFrame{
    [_noteLab sizeToFit];
    CGRect tableframe =self.outchryCtrl.view.frame;
    tableframe.size.height=self.outchryCtrl.view.h_-_noteLab.h_-4;
    self.outchryCtrl.view.frame=tableframe;
    _noteLab.frame=CGRectMake(ScreenW_Lit,self.outchryCtrl.view.h_,self.scView.w_,_noteLab.h_+4);
}
//隐藏nav
- (void)hideNav {
    WS(ws);
    if (!isFullScreen) {
        [UIView animateWithDuration:0.3 animations:^{
            ws.header.frame=CGRectMake(0,-64, Screen_width, ws.header.frame.size.height);
            [ws fullBtnMoveHiden:YES];
        } completion:^(BOOL finished) {
            isShowNav=YES;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            ws.header.frame=CGRectMake(Screen_width,0,44,Screen_height);
            [ws fullBtnMoveHiden:YES];
        } completion:^(BOOL finished)  {
            isShowNav=YES;
        }];
    }
    [self cancelPreviousPerform:@selector(hideNav)];
}

//显示nav
- (void)showNav {
    if (isShowNav)  {
        isShowNav=NO;
        WS(ws);
        if (!isFullScreen)  {
            [UIView animateWithDuration:0.3 animations:^ {
                ws.header.frame=CGRectMake(0, 20, Screen_width, ws.header.frame.size.height);
                [ws fullBtnMoveHiden:NO];
            } completion:^(BOOL finished)  {
                [ws afterHideNav];
            }];
        } else  {
            [UIView animateWithDuration:0.3 animations:^{
                ws.header.frame=CGRectMake(Screen_width-44, 0, 44,Screen_height);
                ws.header.titler.frame=CGRectMake(0,0, Screen_height, 44);
                [ws fullBtnMoveHiden:NO];
            } completion:^(BOOL finished)  {
                [ws afterHideNav];
            }];
        }
    } else {
        [self hideNav];
    }
}

//长连接：刷新行情
- (void)refQuotationLongConn:(NSArray *)list {
    [self.priceTipView refQuotation:list];
}

- (void)configPersonNumAdd {
    personNum +=1;
    [self showPersonNum:personNum];
}
- (void)configPersonNumSub {
    personNum -=1;
    [self showPersonNum:personNum];
}
- (void)showPersonNum:(NSInteger)num{
    if (num<0) {
        num=0;
    }
    personNum=num;
    UIColor *titleColor=LTTitleColor;
    if (_segmentView.curIdx!=0) {
        titleColor=LTSubTitleColor;
    }
    NSString *firstr= [NSString stringWithFormat:@"聊天室("];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:firstr];
    // 设置“聊天室”为LTTitleColor
    [string addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0, 3)];
    
    // 设置“(”为LTSubTitleColor
    [string addAttribute:NSForegroundColorAttributeName value:LTSubTitleColor range:NSMakeRange(3, 1)];
    
    // 创建图片图片附件
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"live_pic_ people"];
    attach.bounds = CGRectMake(0, 0, 9, 10);
    NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
    [string appendAttributedString:attachString];
    
    NSString *personNumStr = [NSString stringWithFormat:@"%li)",num];
    if (num>10000) {
        personNumStr = [NSString stringWithFormat:@"%.1fW)",num*1.0/10000];
    }
    NSMutableAttributedString *personAttr =[[NSMutableAttributedString alloc] initWithString:personNumStr];
    [personAttr addAttribute:NSForegroundColorAttributeName value:LTSubTitleColor range:NSMakeRange(0, personNumStr.length)];
    [personAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, personNumStr.length-1)];
    [personAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(personNumStr.length-1,1)];

    [string appendAttributedString:personAttr];
    
    UIButton *btn=[self.segmentView viewWithTag:kBtnTag];
    [btn setAttributedTitle:string forState:UIControlStateNormal];
    
    attach=nil;
    personAttr=nil;
    string=nil;
}
#pragma mark - utils
- (void)cancelPreviousPerform:(SEL)sel {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:sel object:nil];
}

- (void)afterHideNav {
    [self performSelector:@selector(hideNav) withObject:nil afterDelay:5];
}

#pragma mark - req




#pragma mark - 通知

- (void)addObservers {
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reqCheckSendPic) name:NFC_LiveRoomSelectPic object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateQuotations:) name:NFC_SocketUpdateQuotations object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateQuotationsError:) name:NFC_SocketUpdateQuotationsFailure object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liveKeyboardShow:) name:NFC_LiveShowKeyBoard object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liveKeyboardHide:) name:NFC_LiveHideKeyBoard object:nil];

    NFC_AddObserver(NFC_AppDidEnterBackground, @selector(appDidEnterBackground));
    NFC_AddObserver(NFC_AppWillEnterForeground, @selector(appWillEnterForeground));
    
    NFC_AddObserver(NFC_LiveNoticeMsg, @selector(createTipsWithNotice:));
    
    NFC_AddObserver(NFC_LivePeronSub, @selector(configPersonNumSub));
    NFC_AddObserver(NFC_LivePeronAdd, @selector(configPersonNumAdd));

    NFC_AddObserver(NFC_ShowSendGift, @selector(giftButtonAciton));
    NFC_AddObserver(NFC_ReceiveGift, @selector(analystReceiveGift:));
    
}

- (void)createTipsWithNotice:(NSNotification *)obj {
    NSDictionary *data = [obj.userInfo dictionaryFoKey:@"data"];
    if (data) {
        NSString *msg = [data stringFoKey:@"content"];
        NSString *time = [data stringFoKey:@"times"];
        NSString *roomId = [data stringFoKey:@"roomId"];
        if (notemptyStr(msg) && [roomId isEqualToString:self.liveModel.chatRoomId]) {
            CGFloat timenum = notemptyStr(time)?[time floatValue]:10;
            [self createTipsWithMessage:msg time:timenum];
        }
    }
}
- (void)removeObservers {
    NFC_RemoveAllObserver;
}






//通知：成功接收到行情
- (void)updateQuotations:(NSNotification *)obj {
    NSArray *arr = obj.object;
    NSMutableArray *list = [NSMutableArray array];
    for (NSDictionary *dict in arr) {
        BOOL bl = [dict boolFoKey:@"success"];
        NSString *type = [dict stringFoKey:@"type"];
        if (bl && [type isEqualToString:kResQP]) {
            NSDictionary *dic = [dict dictionaryFoKey:@"data"];
            Quotation *item = [Quotation objWithDic:dic];
            [list addObject:item];
        }
    }
    
    [self refQuotationLongConn:list];
}

//长连接通知：获取行情失败
- (void)updateQuotationsError:(NSNotification *)obj {
    NSArray *arr = obj.object;
    for (NSDictionary *dict in arr) {
        BOOL bl = [dict boolFoKey:@"success"];
        NSString *type = [dict stringFoKey:@"type"];
        if (!bl && [type isEqualToString:kResQP]) {
//            [LTSocketServe sendRTCAll];
        }
    }
}


- (void)keyboardWillShow:(NSNotification *)notification {
    self.quickDealView.hidden = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.quickDealView.hidden = NO;
}

- (void)liveKeyboardShow:(NSNotification *)notification {
    self.quickDealView.hidden = YES;
}

- (void)liveKeyboardHide:(NSNotification *)notification {
    self.quickDealView.hidden = NO;
}
//-(void)livePlay {
//    [self.playView play:YES];
//}

#pragma mark - App前台、后台切换

//切换后台
- (void)appDidEnterBackground {
    [self.playView play:NO];
}
//从后台唤醒app
- (void)appWillEnterForeground {
    [self.playView play:YES];
}

#pragma mark - PlayViewDelegate

- (void)pressPlayView {
    if (isShowNav) {
        [self showNav];
    } else {
        [self hideNav];
    }
}

#pragma mark - SegmentViewDelegate

- (void)selectIdx:(NSInteger)idx {
    NSLog(@"selectIdx == %li",idx);
    [self.scView moveToIdx:idx];
    [self moveToIdx:idx];
    
    
}

- (CGFloat)tipsViewY{
    return PlayHeight+self.segmentView.yh_;
}


- (void)moveToIdx:(NSInteger)idx {
    [self showPersonNum:personNum];
    
    if (idx != 0) {
        self.needHideGift = YES;
        [self hideAndClearGift];
    } else {
        self.needHideGift = NO;
    }
    
    
//    if (idx!=0) {
//        [self.giftManager removeShowGift];
//    }
//    if (idx == 1) {
//        _tips.hidden = NO;
//        [self performSelector:@selector(hidenTips) withObject:nil afterDelay:5];
//    } else {
//        [self cancelPreviousPerform:@selector(hidenTips)];
//        _tips.hidden = YES;
//    }
    
}

- (void)hidenTips {
    _tips.hidden = YES;
}

#pragma mark - LiveScrollViewDelegate

- (void)scrollTo:(NSInteger)idx {
    NSLog(@"selectIdx == %li",idx);
    [self.segmentView moveToIdx:idx];
}







@end
