//
//  NavBarView.m
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "NavBarView.h"

@interface NavBarView()

@property (nonatomic,assign) CGFloat w;
@property (nonatomic,assign) CGFloat h;
@property (nonatomic,copy) NSString *titlestring;
@property (nonatomic,assign) BOOL isback;
@property (nonatomic,strong) UIImageView *bgIV;

@end

@implementation NavBarView


#pragma mark 初始化
- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title isBack:(BOOL)isback target:(id)superController{
    if (self = [super initWithFrame:frame]) {
        _w = frame.size.width;
        _h = frame.size.height;
        _titlestring = title;
        _superController = superController;
        _isback = isback;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    if (!_titler) {
        // 标题
        _titler = [[UILabel alloc] init];
        _titler.text = _titlestring;
        _titler.textAlignment=NSTextAlignmentCenter;
        _titler.font = [UIFont boldSystemFontOfSize:17];
        _titler.textColor = NavBarTitleCoror;
        _titler.backgroundColor = LTClearColor;
        CGFloat h = self.frame.size.height + 15;
        _titler.frame = CGRectMake(h, 0, self.frame.size.width-2*h, self.frame.size.height);
        [self addSubview:_titler];
    }
    if (!_backButton && _isback) {
        UIImage *back_imge = [UIImage imageNamed:@"back"];
        if (kChangeImageColor) {
            back_imge = [back_imge changeColor:NavBarSubCoror];
        }
        _backButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, _h)];
        _backButton.backgroundColor=[UIColor clearColor];
        [_backButton setImage:back_imge forState:UIControlStateNormal];
        [_backButton addTarget:_superController action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backButton];
        [_backButton setTag:100];
        back_imge = nil;
    }
    
    [self changeViewBackgroundColor];
}

- (void)leftAction {
    // 子类中重写该方法
}

#pragma mark 背景变化

- (void)changeViewBackgroundColor{
    self.backgroundColor = NavBarBgCoror;
    self.bottomline.backgroundColor = NavBarBtmLineCoror;
    self.titler.textColor = NavBarTitleCoror;
}

- (void)changeBgImage {
#if useNewYearTheme
    if (!_bgIV) {
        _bgIV = [[UIImageView alloc] init];
        _bgIV.frame = CGRectMake(0, 0, self.w_, self.h_);
        _bgIV.image = [UIImage imageNamed:@"NY_navBarBG"];
        
        [self insertSubview:_bgIV atIndex:0];
    }
#else
#endif
}

@end
