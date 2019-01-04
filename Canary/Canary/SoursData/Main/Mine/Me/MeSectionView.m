//
//  MeSectionView.m
//  ixit
//
//  Created by litong on 2016/12/9.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "MeSectionView.h"
#import "UIView+LTAnimation.h"

static NSInteger btnTag = 1000;
static NSInteger ivTag = 2000;

@interface MeSectionView ()
{
    CGFloat SW;
    NSInteger count;
}

@property (nonatomic,strong) NSArray *list;
@property (nonatomic,assign) MeSectionType type;

@end

@implementation MeSectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = LTWhiteColor;
    }
    return self;
}

#define Key_MSV_Icon    @"Key_MSV_Icon"
#define Key_MSV_Text    @"Key_MSV_Text"

- (void)configList {
    if (_type == MeSectionType_Logout) {//没登录
        self.list = @[
                        @{
                              Key_MSV_Icon : @"Me_icon_open" ,
                              Key_MSV_Text : @"开通账号"
                          },
                        @{
                            Key_MSV_Icon : @"Me_icon_service" ,
                            Key_MSV_Text : @"在线客服"
                            },
                        @{
                            Key_MSV_Icon : @"Me_icon_setting" ,
                            Key_MSV_Text : @"账号管理"
                            }];
    }
    else if (_type == MeSectionType_NotAuth) {//已登录，未认证 或 未认证成功
        self.list = @[
                      @{
                          Key_MSV_Icon : @"Me_icon_auth" ,
                          Key_MSV_Text : @"实名认证"
                          },
                      @{
                          Key_MSV_Icon : @"Me_icon_service" ,
                          Key_MSV_Text : @"在线客服"
                          },
                      @{
                          Key_MSV_Icon : @"Me_icon_setting" ,
                          Key_MSV_Text : @"账号管理"
                          }];
    }
    else if (_type == MeSectionType_Authed) {//已登录，已认证成功
        self.list = @[
                      @{
                          Key_MSV_Icon : @"Me_icon_service" ,
                          Key_MSV_Text : @"在线客服"
                          },
                      @{
                          Key_MSV_Icon : @"Me_icon_setting" ,
                          Key_MSV_Text : @"账号管理"
                          }];
    }
}

- (void)configType:(MeSectionType)type {
    self.type = type;
    [self removeAllSubView];
    
    [self configList];
    count = _list.count;
    SW = ScreenW_Lit/count;
    [self createView];
}

- (void)createView {
    NSInteger i = 0;
    for (NSDictionary *dict in _list) {
        NSString *text = [dict stringFoKey:Key_MSV_Text];
        NSString *icon = [dict stringFoKey:Key_MSV_Icon];
        
        UIView *view = [self singeView:i text:text imgName:icon];
        [self addSubview:view];
        if (i == 0 && count >= 3) {
            CGFloat hotIVWH = LTAutoW(30);
            UIImageView *hotIV = [[UIImageView alloc] init];
            hotIV.frame = CGRectMake(view.w_- hotIVWH, 0, hotIVWH, hotIVWH);
            hotIV.image = [UIImage imageNamed:@"Me_hotTag"];
            [view addSubview:hotIV];
        }
        if (i != 0) {
            [self addLine:i];
        }
        i ++;
    }
    
    
}

- (void)btnAction:(UIButton *)sender {
    NSInteger idx = sender.tag % btnTag;
    _meSectionBlock ? _meSectionBlock(idx) : nil;
}


#define animationTime 0.3
- (void)animationBegin:(UIView *)view {
    [view animationPulseScale:1.1 repeatCount:1 duration:animationTime];
}


- (UIView *)singeView:(NSInteger)idx text:(NSString *)text imgName:(NSString *)imgName {
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(idx * SW, 0, SW, self.h_);
    
    UIImage *img = [UIImage imageNamed:imgName];
    CGFloat iwh = LTAutoW(31);
    UIImageView *iv = [[UIImageView alloc] init];
    iv.frame = CGRectMake((SW - iwh)/2.0, LTAutoW(22), iwh, iwh);
    iv.image = img;
    iv.tag = ivTag + idx;
    iv.userInteractionEnabled = YES;
    [view addSubview:iv];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(0, LTAutoW(57), SW, LTAutoW(15));
    lab.textColor = LTTitleColor;
    lab.font = autoFontSiz(12);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = text;
    [view addSubview:lab];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, SW, self.h_);
    btn.tag = btnTag + idx;
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    return view;
}

- (void)addLine:(NSInteger)idx {
    UIView *lineView = [[UIView alloc] init] ;
    lineView.frame = CGRectMake(SW*idx, 0, 0.5, self.h_);
    lineView.backgroundColor = LTLineColor;
    [self addSubview:lineView];
}

@end
