//
//  PopADView.m
//  ixit
//
//  Created by litong on 2016/11/15.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "PopADView.h"
#import "UIImageView+WebCache.h"


static NSString *showTimeKey = @"showTimeKey";
static CGFloat leftMar = 16.f;
static CGFloat topMar = 30.f;
static CGFloat btmMar = 30.f;

static CGFloat btnTopMar = 20.f;
static CGFloat btnWH = 36.f;


@interface PopADView ()

@property (nonatomic,strong) UIImageView*ADImgView;
@property (nonatomic,strong) PopADModel *mo;

@property (nonatomic,strong) UIButton*cancleBtn;

/** 每日第几次进入显示广告 */
@property (nonatomic,assign) NSInteger mark;

@end

//static NSInteger maxMak = 1;

@implementation PopADView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.mark = 0;
        [self createBgView];
        [self createView];
    }
    return self;
}

- (void)createBgView {
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, self.w_, self.h_);
    bgView.backgroundColor = LTRGBA(0, 0, 0, 0.6);
    [self addSubview:bgView];
//    [bgView addSingeTap:@selector(shut) target:self];
}


- (void)createView {
    self.ADImgView = [[UIImageView alloc] init];
    _ADImgView.frame = CGRectMake(leftMar, topMar, self.w_- 2*leftMar, self.h_- topMar - btmMar);
    _ADImgView.userInteractionEnabled = YES;
//    _ADImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_ADImgView];
    [_ADImgView addSingeTap:@selector(clickADView) target:self];
    
    
    self.cancleBtn = [UIButton btnWithTarget:self action:@selector(clickCancleAction) frame:CGRectZero];
    [_cancleBtn setNorBGImageName:@"icon_shut"];
    
    [self addSubview:_cancleBtn];
    
    self.hidden = YES;
}

- (void)clickADView {
    [PopADView shut];
    _imgViewAction ? _imgViewAction() : nil;
}

- (void)clickCancleAction {
    [PopADView shut];
}

- (NSDate *)curDateH06String {
    NSString *str = [[NSDate date] chinaYMDString];
    NSString *curH06 = [NSString stringWithFormat:@"%@ 06:00:00",str];
    NSDate *curH06Date = [NSDate dateFromString:curH06 withFMT:kyMd_Hms];;
    return curH06Date;
}

- (void)saveDate {
    NSDate *curH06Date = [self curDateH06String];
    UD_SetObjForKey(curH06Date, showTimeKey);
}
- (BOOL)canShowCheckTime {
    NSDate *oldH06Date = UD_ObjForKey(showTimeKey);
    if (!oldH06Date) {
        return YES;
    }
    
    NSTimeInterval t = [[NSDate date] timeIntervalSinceDate:oldH06Date];
    
    return (t > LIT_ONE_DAY);
}

#pragma mark - 外部

#define PopADViewTag 21800

+ (void)showAction:(ADImgViewAction)imgViewAction {
    PopADView *popADView = [[PopADView alloc] initWithFrame:CGRectMake(0, 0, ScreenW_Lit, ScreenH_Lit)];
    popADView.imgViewAction = imgViewAction;
    popADView.tag = PopADViewTag;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:popADView];
    
    [popADView configData];
}

+ (void)shut {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    PopADView *popADView = [window viewWithTag:PopADViewTag];
    [popADView removeFromSuperview];
}



- (void)configData {
    if (![self canShowCheckTime]) {
        return;
    }
    
    BOOL bl = [UserDefaults boolForKey:kShowHomeImage];
    NSString *aUrl = UD_ObjForKey(kHomeImageUrl);
    if (!bl || emptyStr(aUrl)) {
        return;
    }
    
    self.hidden = NO;
    
    WS(ws);
    [self saveDate];
    [_ADImgView sd_setImageWithURL:[aUrl toURL]
                  placeholderImage:[UIImage imageNamed:@""]
     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
         
         if (!image) {
             [PopADView shut];
             return ;
         }
         
         CGFloat iw = image.size.width;//图片宽
         CGFloat ih = image.size.height;//图片高
         
         CGFloat btnTopH = btnTopMar + btnWH;
         CGFloat ivw = ws.w_- 2*leftMar;
         CGFloat ivh = ws.h_- topMar - btmMar - btnTopH;
         
         if (iw > ih) {//宽图
             if (iw < ivw) {
                 ivw = iw;
             }
             ivh = (ih/iw)*ivw;
             
             if (ih < ivh) {
                 ivh = ih;
                 ivw = (iw/ih)*ivh;
             }
         } else {//高图
             if (ih < ivh) {
                 ivh = ih;
             }
             ivw = (iw/ih)*ivh;
             
             if (iw < ivw) {
                 ivw = iw;
                 ivh = (ih/iw)*ivw;
             }
         }
         
         ws.ADImgView.frame = CGRectMake((ws.w_ - ivw)/2.0, (ws.h_ - ivh)/2.0+10, ivw, ivh);
         ws.cancleBtn.frame = CGRectMake(ws.ADImgView.xw_-btnWH, ws.ADImgView.y_-btnWH-10, btnWH, btnWH);
     }];
}


@end
