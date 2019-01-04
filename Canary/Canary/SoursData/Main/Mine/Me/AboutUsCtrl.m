//
//  AboutUsCtrl.m
//  ixit
//
//  Created by litong on 2016/12/23.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "AboutUsCtrl.h"
#import "MeSetView.h"
#import "FTCoreTextView.h"
//#import "UIView+Draggable.h"

@interface AboutUsCtrl ()<FTCoreTextViewDelegate>

@property (nonatomic,strong) UIImageView *logoIV;

@end

@implementation AboutUsCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navPopBackTitle:@"关于我们"];
    [self createView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
//    [self.logoIV updateSnapPoint];
}


- (void)createView {
    CGFloat logoWH = LTAutoW(80);
    UIImage *logo = [UIImage imageNamed:@"app_icon"];
    self.logoIV = [[UIImageView alloc] initWithImage:logo];
    _logoIV.frame = CGRectMake((ScreenW_Lit - logoWH)*0.5, NavBarTop_Lit + LTAutoW(36), logoWH, logoWH);
    [self.view addSubview:_logoIV];
    self.logoIV.userInteractionEnabled = YES;
//    [self.logoIV makeDraggable];
    
    UILabel *appNameLab = [[UILabel alloc] init];
    appNameLab.frame = CGRectMake(0, _logoIV.yh_ + LTAutoW(16), ScreenW_Lit, LTAutoW(20));
    appNameLab.font = autoFontSiz(15);
    appNameLab.textColor = LTTitleColor;
    appNameLab.textAlignment = NSTextAlignmentCenter;
    appNameLab.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    [self.view addSubview:appNameLab];
    
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    NSString *ver = [dict objectForKey:@"CFBundleShortVersionString"];
    if (!IXIT_RELEASE) {
        ver = [NSString stringWithFormat:@"%@",[dict objectForKey:@"CFBundleVersion"] ];
    }
    UILabel *appVersionLab = [[UILabel alloc] init];
    appVersionLab.frame = CGRectMake(0, appNameLab.yh_ , ScreenW_Lit, LTAutoW(20));
    appVersionLab.font = autoFontSiz(12);
    appVersionLab.textColor = LTSubTitleColor;
    appVersionLab.textAlignment = NSTextAlignmentCenter;
    appVersionLab.text = [NSString stringWithFormat:@"v%@",ver];;
    [self.view addSubview:appVersionLab];
    
    
//    WS(ws);
//    MeSetView *view = [[MeSetView alloc] initTitle:@"关于我们" y:(appVersionLab.yh_ + LTAutoW(26))];
//    [self.view addSubview:view];
//    view.meSetViewBlock = ^{
//        NSString *str =  [ThemeJson(@"aboutus") objectForKey:[NSString stringWithFormat:@"%d",kAPPType]];
//        [ws pushDetailViewWithContent:str Title:@"关于我们"];
//    };
//    
//    MeSetView *view1 = [[MeSetView alloc] initTitle:@"风险提示" y:view.top_];
//    [self.view addSubview:view1];
//    view1.meSetViewBlock = ^{
//        NSString *str = [ThemeJson(@"risktip") objectForKey:@"content"];
//        [ws pushDetailViewWithContent:str Title:@"风险提示"];
//    };
    
}


- (void)pushDetailViewWithContent:(NSString*)html Title:(NSString*)title{
//    BaseVCtrl *aboutus = [[BaseVCtrl alloc] init];
//    [aboutus navBackWithTitle:title];
//    FTCoreTextView *content = [[FTCoreTextView alloc] initWithFrame:CGRectMake(20, aboutus.point.y+30, aboutus.size.width-40, aboutus.size.height)];
//    FTCoreTextStyle *style = [FTCoreTextStyle new];
//    style.color = ThemeColor(@"font_color");
//    style.textAlignment = FTCoreTextAlignementJustified;
//    style.font = [UIFont fontWithName:kFontName size:13];
//    style.minLineHeight = 15;
//    [content addStyle:style];
//    FTCoreTextStyle *linkStyle = [style copy];
//    linkStyle.name = FTCoreTextTagLink;
//    linkStyle.font = [UIFont systemFontOfSize:15];
//    linkStyle.color = ThemeColor(@"footer_font_highlights_color");
//    [content addStyle:linkStyle];
//    
//    NSString *about = html;
//    [content setText:about];
//    content.delegate = self;
//    [aboutus.view addSubview:content];
//    content = nil;
//    style = nil;
//    aboutus.view.backgroundColor=[UIColor whiteColor];
//    [self.navigationController pushViewController:aboutus animated:YES];
//    aboutus = nil;
    
}




@end
