//
//  PrivilegedCardInfoVCtrl.m
//  ixit
//
//  Created by litong on 2017/4/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "PrivilegedCardInfoVCtrl.h"
#import "IntegralMo.h"
#import "CardHeadView.h"
#import "CardHistoryHeadView.h"
#import "CardDetailsMo.h"
#import "CardDetailsView.h"
#import "CardFooterView.h"
#import "LTArcProgressView.h"
@interface PrivilegedCardInfoVCtrl ()<UIScrollViewDelegate>
@property(strong,nonatomic)UIScrollView * scroll;
@property(strong,nonatomic)CardHeadView * cardHead;
@property(strong,nonatomic)CardHistoryHeadView * cardHisHead;

@property(strong,nonatomic)CardDetailsView * cardMid;
@property(strong,nonatomic)CardFooterView * cardFooter;
@property (nonatomic,copy) NSString * hid;
@property (nonatomic,copy) NSString * time;
@property (nonatomic,strong) CardDetailsMo * giftDetailsMo;
@end

@implementation PrivilegedCardInfoVCtrl
#define FooterH LTAutoW(60)
- (void)viewDidLoad {
    [super viewDidLoad];
    [self navTitle:_mo.giftName backType:BackType_PopVC];
    [self createDetailsView];
    [self requestCardDetailsData];//特权卡详情

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - initview
//创建详情页
-(void)createDetailsView{
    [self createScrollView];
    [self createHeaderView];
    [self createMidView];
    [self createFooterView];
    
    _scroll.contentSize=CGSizeMake(ScreenW_Lit, _cardMid.yh_+LTAutoW(12));
    if (_fromHistory) {
        _cardFooter.hidden=YES;
        _scroll.frame=CGRectMake(0, 64, ScreenW_Lit, ScreenH_Lit-64);
    }
}
-(void)createScrollView {
    if(!_scroll){
        _scroll=[[UIScrollView alloc]init];
        _scroll.frame=CGRectMake(0, 64, ScreenW_Lit, ScreenH_Lit-FooterH-64);
        _scroll.showsHorizontalScrollIndicator=NO;
        _scroll.delegate=self;
        _scroll.backgroundColor=LTBgColor;
        _scroll.bounces=NO;
        _scroll.contentSize=CGSizeMake(ScreenW_Lit, _scroll.h_);
        [self.view addSubview:_scroll];
    }
}

-(void)createHeaderView{
    if (_fromHistory) {
        if(!_cardHisHead){
            _cardHisHead=[[CardHistoryHeadView alloc]initWithMo:_mo integralMo:_Integralmo];
            _cardHisHead.name=[_mo.giftName replacStr:@"特权-" withStr:@""];
            [_scroll addSubview:_cardHisHead];
        }
    }else{
        if(!_cardHead){
            _cardHead=[[CardHeadView alloc]initWithMo:_mo integralMo:_Integralmo];
            _cardHead.name=[_mo.giftName replacStr:@"特权-" withStr:@""];
            _cardHead.time=!emptyStr(self.endTime) ? [_endTime doubleValue] : 0;
            [_scroll addSubview:_cardHead];
        }
    }
}
-(void)createMidView{
    if(!_cardMid) {
        CGFloat h=_scroll.h_-_cardHead.h_;
        h = h<=0? 200:h;
        _cardMid=[[CardDetailsView alloc]init];
        _cardMid.frame=CGRectMake(0, _cardHead.yh_, ScreenW_Lit, h);
        _cardMid.backgroundColor=LTWhiteColor;
        [_scroll addSubview:_cardMid];
    }
    if (_fromHistory) {
        CGFloat h=_scroll.h_-_cardHisHead.h_;
        h = h<=0? 200:h;
        _cardMid.frame=CGRectMake(0, _cardHisHead.yh_, ScreenW_Lit, h);
    }
}
-(void)createFooterView {
    if (!_cardFooter) {
        _cardFooter=[[CardFooterView alloc]initWithFrame:CGRectMake(0, ScreenH_Lit-FooterH, ScreenW_Lit, FooterH)];
        [_cardFooter refreshWithMo:_mo integralMo:_Integralmo];
        [self.view addSubview:_cardFooter];
        WS(ws);
        _cardFooter.reqGiftChangeBlock = ^{
            [ws reqUserGiftChange];
        };
    }
}
//配置数据
-(void)configureDetailViews {
    //header
    if (_fromHistory) {
        _cardHisHead.timeStr=_time;
        _cardHisHead.detailsMo=self.giftDetailsMo;
        _cardHisHead.cardBGUrl=self.giftDetailsMo.giftBigPic;
    }else{
        self.cardHead.cardBGUrl=self.giftDetailsMo.giftBigPic;
    }
    
    
    //mid
    [_cardMid refreshWithModel:_giftDetailsMo];
    _scroll.contentSize=CGSizeMake(ScreenW_Lit, _cardMid.yh_+LTAutoW(12));
    //footer
    _cardFooter.buyStatus=_giftDetailsMo.buyStatus;
}
#pragma mark - set data
-(void)setFromHistory:(BOOL)fromHistory{
    _fromHistory=fromHistory;
}
-(void)setGiftChangeMO:(GiftChangeMO *)giftChangeMO{
    _hid=giftChangeMO.historyRecId;
    self.time=giftChangeMO.createTimeStr;
    _mo=[giftChangeMO toGfitMO];
}

#pragma mark - delegate
#pragma mark - utils
-(UIButton *)createBtnWithFrame:(CGRect)frame title:(NSString *)title fontsize:(CGFloat)fsize{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:fsize];
    return btn;
}
-(UILabel *)createLabWithFrame:(CGRect)frame text:(NSString *)text fontsize:(CGFloat)fsize{
    UILabel *label=[[UILabel alloc]init];
    label.frame=frame;
    label.backgroundColor=[UIColor clearColor];
    label.text=text;
    label.textAlignment=NSTextAlignmentCenter;
    label.numberOfLines=0;
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:fsize];
    return label;
}
-(UIImageView *)createImgViewWithFrame:(CGRect)frame imageName:(NSString *)image{
    UIImageView *imgv=[[UIImageView alloc]initWithImage:[UIImage imageNamed:image]];
    imgv.frame=frame;
    return imgv;
}

#pragma mark - request
/*获取卡片详情
 success	boolean	是否成功
 errorCode	String	错误编码
 errorInfo	String	错误提示
 pagerManager	JSON	分页对象
 pagerManager.currentPage	int	当前页数
 pagerManager.results	int	每页记录数
 pagerManager.totalResults	int	总记录数
 pagerManager.totalPage	int	总页数
 */
-(void)requestCardDetailsData {
//    WS(ws);
//    [ws showLoadingView];
//    if (!_fromHistory) {
//        [RequestCenter reqUserGiftDetails:_mo.giftId finish:^(LTResponse *res) {
//            [ws hideLoadingView];
//            if (res.success) {
//                NSDictionary *data = [res.resDict dictionaryFoKey:@"data"];
//                if (data.allKeys.count>0) {
//                    ws.giftDetailsMo=[CardDetailsMo objWithDict:data];
//                    [ws configureDetailViews];
//                }
//            }
//        }];
//    }else{
//        [RequestCenter reqUserGiftHistoryDetails:_hid finish:^(LTResponse *res) {
//            [ws hideLoadingView];
//            if (res.success) {
//                NSDictionary *data = [res.resDict dictionaryFoKey:@"data"];
//                if (data.allKeys.count>0) {
//                    ws.giftDetailsMo=[CardDetailsMo objWithDict:data];
//                    [ws configureDetailViews];
//                }
//            } else{
//                NSLog(@"res=%@ ",res);
//            }
//        }];
//    }

}
//兑换特权卡动作
/*
 data =     {
 levelList = "<null>";
 levelName = V7;
 levelNum = 7;
 maxExp = 99999999;
 minExp = 15000000;
 nextLevelRate = "0.95";
 pointsRanking = "95.0%";
 rebateRate = "0.5";
 totalExp = 96146214;
 totalPoints = 151496;
 validPoints = 102600;
 versionNo = 1;
 };
 errorCode = "";
 errorInfo = "";
 pagerManager = "<null>";
 success = 1;
 */
-(void)reqUserGiftChange {
//    WS(ws);
//    
//    if ([_Integralmo.validPoints integerValue]<[_mo.poins integerValue]) {
//        //积分不足
//        [ws.view showTip:@"兑换失败，积分余额不足"];
//    }else {
//        [ws showLoadingView];
//        [RequestCenter reqUserGiftChange:_mo.giftId giftNum:1 versionNo:[[LTUser userVipLv] integerValue] finish:^(LTResponse *res) {
//            [ws hideLoadingView];
//            if (res.success) {
//                NSLog(@"CardChanges=%@",res.resDict);
//                ws.Integralmo.validPoints=[res.resDict objectForKey:@"validPoints"];
//                NSInteger limit = [ws.mo.giftLimitNum integerValue]-1;
//                NSInteger takeNum = [ws.mo.takeNum integerValue]+1;
//                ws.mo.giftLimitNum =[[NSNumber numberWithInteger:limit] stringValue];
//                ws.mo.takeNum =[NSNumber numberWithInteger:takeNum];
//                ws.mo.buyStatus=1;//改变购买状态
//                //1.改变head显示
//                ws.cardHead.surplusNum=limit;
//                ws.cardHead.exchangeNum=takeNum;
//                //2.改变footer显示
//                [ws.cardFooter refreshWithMo:ws.mo integralMo:ws.Integralmo];
//                
//                ws.giftListRefBlock ? ws.giftListRefBlock() : nil;
//            }else {
//                [ws.view showTip:res.message];
//            }
//        }];
//    }
}

@end
