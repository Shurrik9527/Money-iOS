//
//  GainDetailVCtrl.m
//  ixit
//
//  Created by litong on 2016/11/23.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "GainDetailVCtrl.h"
#import "RankIV.h"
#import "GainDetailView.h"

@interface GainDetailVCtrl ()

@property (nonatomic,strong) GainModel *mo;

@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UILabel *timeLab;//8月7日排名
@property (nonatomic,strong) RankIV *rankIV;//头像带徽章
@property (nonatomic,strong) UILabel *nameLab;//昵称
@property (nonatomic,strong) UIView *topBtmView;
@property (nonatomic,strong) UILabel *priceLab;//16元
@property (nonatomic,strong) UILabel *rateLab;//200%
@property (nonatomic,strong) UIImageView *ticketIV;//￥168

@property (nonatomic,strong) GainDetailView *gainDetailView;

@end

@implementation GainDetailVCtrl

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self navTitle:@"盈利详情" backType:BackType_PopVC];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self createTopView];
    [self createGainDetailView];
    
    self.view.backgroundColor = LTWhiteColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configData:(GainModel *)mo ranking:(NSInteger)ranking {
    _mo = mo;
    
    _timeLab.text = [mo.closeDate stringFMD:@"MM月dd日排名" withSelfFMT:@"yyyy-MM-dd"];
    _rankIV.ranking = ranking;
    [_rankIV setImgUrlStr:mo.avatar];//设置头像
    _nameLab.text = mo.nickName;
    
    NSString *rateStr = mo.profitRate;
    if (notemptyStr(rateStr)) {
        NSAttributedString *ABRateStr = [rateStr ABStrFont:autoFontSiz(15) range:NSMakeRange(rateStr.length-1, 1)];
        _rateLab.attributedText = ABRateStr;
    }

    NSInteger cu = mo.giveVoucher;
    NSString *imgName = [NSString stringWithFormat:@"quan_icon%ld",(long)cu];
    if (cu < 25) {
        imgName = [NSString stringWithFormat:@"quan_iconR%ld",(long)cu];
    }
    _ticketIV.image = [UIImage imageNamed:imgName];
    
    [self loadData];
}

- (void)refPrice:(NSString *)price {
    NSString *priceStr = [NSString stringWithFormat:@"%@ 元",price];
    NSAttributedString *ABPrictStr = [priceStr ABStrFont:autoFontSiz(15) range:NSMakeRange(priceStr.length-1, 1)];
    _priceLab.attributedText = ABPrictStr;
}

#pragma mark - req

- (void)loadData {
//    WS(ws);
//    [self showLoadingWithMsg:@"正在加载..."];
//    [RequestCenter reqGainDetail:_mo.orderId completion:^(LTResponse *res) {
//        
//        [ws hideLoadingView];
//        
//        if (res.success) {
//            MyGainModel *mo = [MyGainModel objWithDict:res.resDict];
//            [ws refPrice:mo.profitLoss];
//            [ws.gainDetailView refData:mo];
//        } else {
//            [ws.view showTip:res.message];
//        }
//    }];
}


#pragma mark - init 


- (void)createGainDetailView {
    self.gainDetailView = [[GainDetailView alloc] initWithFrame:CGRectMake(0, _topView.yh_, self.w_, LTAutoW(GainDetailViewH))];
    [self.view addSubview:_gainDetailView];
}

static CGFloat bgIVW = 155;
static CGFloat bgIVH = 90.5;

- (void)createTopView {
    
    self.topView = [[UIView alloc] init];
    _topView.frame = CGRectMake(0, NavBarTop_Lit, ScreenW_Lit, LTAutoW(211.f));
    _topView.backgroundColor = LTTitleColor;
    [self.view addSubview:_topView];
    
    CGRect timeLabRect = CGRectMake(0 , 0, ScreenW_Lit, LTAutoW(26));
    self.timeLab = [self lab:timeLabRect fontSize:15.f color:LTSubTitleColor];
    [_topView addSubview:_timeLab];
    
    UIImageView *bgIV = [[UIImageView alloc] init];
    bgIV.frame = CGRectMake((ScreenW_Lit - LTAutoW(bgIVW))/2, LTAutoW(67/2), LTAutoW(bgIVW), LTAutoW(bgIVH));
    bgIV.image = [UIImage imageNamed:@"GainBG_flower"];
    [_topView addSubview:bgIV];
    
    static CGFloat Gain1IVW = 62.5;
    static CGFloat Gain1IVH = 63.5;
    CGRect r1 = CGRectMake((ScreenW_Lit - LTAutoW(Gain1IVW))/2, LTAutoW(38), LTAutoW(Gain1IVW), LTAutoW(Gain1IVH));
    self.rankIV = [[RankIV alloc] initWithFrame:r1];
    [_topView addSubview:_rankIV];
    
    
    CGRect nameLabRect = CGRectMake(0 , _rankIV.yh_+LTAutoW(8), ScreenW_Lit, LTAutoW(15));
    self.nameLab = [self lab:nameLabRect fontSize:15.f color:LTWhiteColor];
    [_topView addSubview:_nameLab];

    [self cretateTopBtmView];
}

static CGFloat topBtmViewH = 79.5;
- (void)cretateTopBtmView {
    self.topBtmView = [[UIView alloc] init];
    _topBtmView.frame = CGRectMake(0, self.topView.h_ - LTAutoW(topBtmViewH), self.topView.w_, LTAutoW(topBtmViewH));
    _topBtmView.backgroundColor = _topView.backgroundColor;
    [_topView addSubview:_topBtmView];
    
    
    
    CGFloat labW = _topBtmView.w_ / 3.0;
    CGFloat labTopMar = 12;
    CGFloat labH = 25;
    CGFloat subLabTopMar = 12;
    CGFloat subLabH = 15;
    
    CGRect priceLabRect = CGRectMake(0, LTAutoW(labTopMar), labW, LTAutoW(labH));
    self.priceLab = [self lab:priceLabRect fontSize:labH color:LTKLineRed];
    [_topBtmView addSubview:_priceLab];
    
    CGRect priceSubLabRect = CGRectMake(_priceLab.x_, _priceLab.yh_+LTAutoW(subLabTopMar), labW, LTAutoW(subLabH));
    UILabel *priceSubLab = [self lab:priceSubLabRect fontSize:subLabH color:LTSubTitleColor];
    priceSubLab.text = @"盈利额";
    [_topBtmView addSubview:priceSubLab];
    
    CGRect rateLabRect = CGRectMake(labW, LTAutoW(labTopMar), labW, LTAutoW(labH));
    self.rateLab = [self lab:rateLabRect fontSize:labH color:LTKLineRed];
    [_topBtmView addSubview:_rateLab];
    
    CGRect rateSubLabRect = CGRectMake(_rateLab.x_, _rateLab.yh_+LTAutoW(subLabTopMar), labW, LTAutoW(subLabH));
    UILabel *rateSubLab = [self lab:rateSubLabRect fontSize:subLabH color:LTSubTitleColor];
    rateSubLab.text = @"盈利率";
    [_topBtmView addSubview:rateSubLab];
    
    
    CGFloat ivw = LTAutoW(58);
    CGFloat ivh = LTAutoW(24);
    self.ticketIV = [[UIImageView alloc] init];
    _ticketIV.frame = CGRectMake(2*labW+(labW - ivw)/2.0, LTAutoW(14), ivw, ivh);
    [_topBtmView addSubview:_ticketIV];
    
    CGRect ticketSubLabRect = CGRectMake(2*labW, _ticketIV.yh_+LTAutoW(11), labW, LTAutoW(subLabH));
    UILabel *ticketSubLab = [self lab:ticketSubLabRect fontSize:subLabH color:LTSubTitleColor];
    ticketSubLab.text = @"奖励";
    [_topBtmView addSubview:ticketSubLab];
    
    
    [self topBtmViewAddLine:1];
    [self topBtmViewAddLine:2];
}

static CGFloat lineH = 48;
- (void)topBtmViewAddLine:(NSInteger)idx {
    UIView *line = [UIView lineFrame:CGRectMake(idx*_topBtmView.w_ / 3.0-0.5, LTAutoW(14), 0.5, LTAutoW(lineH)) color:LTRGB(74, 78, 99)];
    [_topBtmView addSubview:line];
}

- (UILabel *)lab:(CGRect)r fontSize:(CGFloat)fontSize color:(UIColor *)color {
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = r;
    lab.textColor = color;
    lab.font = autoFontSiz(fontSize);
    lab.textAlignment = NSTextAlignmentCenter;
    return lab;
}


@end
