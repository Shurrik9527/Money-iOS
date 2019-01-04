//
//  loadingView.m
//  21cbh_iphone
//
//  Created by 21tech on 14-3-13.
//  Copyright (c) 2014年 ZX. All rights reserved.
//

#import "loadingView.h"

@interface loadingView(){
    UIActivityIndicatorView *_loadImg;
    UIImageView *_finishImgView;
    UILabel *msgLab;
    CGFloat _alpha;
    UIView *mengban;// 蒙版
    BOOL _isFullScreen;
    CGRect _frame;
    UIView *_loadingView;
}

@end

@implementation loadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _alpha = 0.8;
        [self create];
    }
    return self;
}

-(id)initWithTitle:(NSString*)title Frame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.title = title;
        _alpha = 0.8;
        [self create];
    }
    return self;
}

-(id)initWithTitle:(NSString*)title  Frame:(CGRect)frame IsFullScreen:(BOOL)fullScreen{
    self = [super initWithFrame:frame];
    if (self) {
        self.title = title;
        _alpha = 0.5;
        _isFullScreen = fullScreen;
        if (fullScreen) {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 150, 100);
            //            // 创建蒙版视图
            //            CGRect frame = [UIScreen mainScreen].bounds;
            //            mengban = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            //            mengban.backgroundColor = UIColorFromRGB(0x000000);
            //            mengban.alpha = 0.5;
            //            mengban.userInteractionEnabled = NO;
            //            [self.superview addSubview:mengban];
            //            [self.superview bringSubviewToFront:mengban];
            _alpha = 1;
        }
        [self create];
    }
    return self;
}


-(void)create
{
    if (!self.title) {
        self.title = @"数据加载中";
    }
//    self.alpha = _alpha;
//    self.backgroundColor = ThemeColor(@"body_bgcolor"); //ThemeColor(@"klinechart_nav_button_bg_color");
//    self.layer.borderColor = LTColorHex(0xCCCCCC).CGColor;
//    self.layer.borderWidth = 0.5;
//    //ThemeColor(@"klinechart_nav_button_text_color");
//    self.layer.cornerRadius = 0;
//    
//    // 关闭自身按钮
//    UIImage *close = nil;//[UIImage imageNamed:@"ad_delete_btn.png"];
//    UIImageView *closeView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (self.frame.size.height - close.size.height)/2, close.size.width, close.size.height)];
//    closeView.image = close;
//    
//    UIButton *closeButton = [[UIButton alloc] initWithFrame:self.bounds];
//    [closeButton addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:closeButton];
//    [closeButton addSubview:closeView];
//    closeView = nil;
//    closeButton = nil;
//    
//    
//    
//    // 添加加载控件
//    _loadImg = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    _loadImg.color = ThemeColor(@"button_bg_color");
//    if (_isFullScreen) {
//        _loadImg.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//    }
//    CGFloat titleLen = [_title sizeWithFont:fontSiz(14)].width;
//    _loadImg.frame = CGRectMake((self.frame.size.width-titleLen-10-_loadImg.frame.size.width)/2, (self.frame.size.height-_loadImg.frame.size.height)/2, _loadImg.frame.size.width, _loadImg.frame.size.height);
//    [_loadImg startAnimating];
//    if (mengban) {
//        [mengban addSubview:_loadImg];
//    }else{
//        [self addSubview:_loadImg];
//    }
//    
//    _finishImgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-kD_FinishedImg.size.width)/2, (self.frame.size.height-kD_FinishedImg.size.height)/2, kD_FinishedImg.size.width, kD_FinishedImg.size.height)];
//    _finishImgView.image = kD_FinishedImg;
//    [self addSubview:_finishImgView];
//    _finishImgView.hidden = YES;
//    
//    // 添加加载文字
//    UILabel *_lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    _lb.text = self.title;
//    _lb.font = [UIFont fontWithName:kFontName size:14];
//    _lb.textColor = ThemeColor(@"klinechart_nav_button_text_color");
//    _lb.backgroundColor = LTClearColor;
//    _lb.textAlignment = NSTextAlignmentCenter;
//    [_lb sizeToFit];
//    _lb.frame = CGRectMake((_loadImg.frame.size.width+_loadImg.frame.origin.x)+10, (self.frame.size.height-_lb.frame.size.height)/2, _lb.frame.size.width, _lb.frame.size.height);
//    [self addSubview:_lb];
//    _lb = nil;
    if(!_finishImgView)
    {
        [self initLoadingView];
    }
}

-(void)start
{
//    UILabel *lb = (UILabel*)[self.subviews lastObject];
//    lb.text = self.title;
//    lb = nil;
//    self.hidden = NO;
//    _finishImgView.hidden = YES;
//    [_loadImg startAnimating];
    self.hidden=NO;
    if (!_finishImgView)
    {
        [self showLoadingWithMsg:@"加载中"];
    }
    [self loadingAnimation:YES];
}
-(void)stop
{
//    _finishImgView.hidden = YES;
//    [_loadImg stopAnimating];
//    [UIView animateWithDuration:0.3 animations:^{
//        self.alpha = 0;
//    } completion:^(BOOL finish){
//        self.hidden = YES;
//    }];
    self.hidden=YES;
    [self loadingAnimation:NO];

}

-(void)setSelfTitle:(NSString*)title isSuccess:(BOOL)success andSecond:(int)second{
    UILabel *lb = (UILabel*)[self.subviews lastObject];
    lb.text = title;
    lb = nil;
    if (success) {
        _finishImgView.image = kD_FinishedImg;
    }else{
        _finishImgView.image = kD_ErrorImg;
    }
    _loadImg.hidden = YES;
    _finishImgView.hidden = NO;
    // 显示1秒
    [self performSelector:@selector(defaultBackground) withObject:nil afterDelay:second];
}
-(void)setError:(NSString*)title{
//    UILabel *lb = (UILabel*)[self.subviews lastObject];
//    lb.text = title;
//    lb.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    lb = nil;
//    _finishImgView.image = kD_ErrorImg;
//    _loadImg.hidden = YES;
//    _finishImgView.hidden = NO;
    [self->msgLab setText:title];
    [self performSelector:@selector(hideLoadingView) withObject:nil afterDelay:1.5];
//    [self hideLoadingView];
}

-(void)closeSelf{
    NSLog(@"---DFM---关闭加载");
    
//    [self performSelector:@selector(defaultBackground) withObject:nil afterDelay:0.3];
}

-(void)defaultBackground{
    [self stop];
    self.hidden = YES;
    
}

#pragma mark - loading message view
/**
 *  初始化loading动画view
 */
-(void)initLoadingView
{
//    if (!_loadingView)
//    {
//        _loadingView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.3*Screen_width, 0.3*Screen_width)];
//        _loadingView.backgroundColor=LTClearColor;
//        _loadingView.alpha=0.8;
//        _loadingView.tag=100000;
//        [self addSubview:_loadingView];
//    }
    

    _finishImgView=[[UIImageView alloc]init];
    _finishImgView.image=[UIImage imageNamed:@"Loading"];
    _finishImgView.frame=CGRectMake((self.frame.size.width-32)/2.0, (self.frame.size.height-34)/2.0-12, 32, 34);
    _finishImgView.tag = 100001;
    [self addSubview:_finishImgView];
    
    msgLab=[[UILabel alloc]init];
    msgLab.frame=CGRectMake(0, _finishImgView.frame.origin.y+_finishImgView.frame.size.height, self.frame.size.width, 44);
    msgLab.backgroundColor=[UIColor clearColor];
    msgLab.text=@"加载中";
    msgLab.textAlignment=NSTextAlignmentCenter;
    msgLab.numberOfLines=0;
    msgLab.textColor=LTColorHex(0xB4B9CB);
    msgLab.font=[UIFont systemFontOfSize:15];
    msgLab.tag=100002;
    [self addSubview:msgLab];
    
}
/**
 *  显示loading动画
 */
-(void)showLoadingWithMsg:(NSString *)msg;
{
    if (!_finishImgView)
    {
        [self initLoadingView];
    }
//    if (_loadingView.hidden==NO)
//    {
//        return;
//    }
//    _loadingView.hidden=NO;
    if (msg.length>0) {
        msgLab.text=msg;
    }
//    [self bringSubviewToFront:_loadingView];
    [self loadingAnimation:YES];
}
/**
 *  隐藏loading动画
 */
-(void)hideLoading
{
    [self performSelector:@selector(hideLoadingView) withObject:nil afterDelay:0];
}
-(void)hideLoadingView
{
    [self loadingAnimation:NO];
}
/**
 *  loading动画的方法
 *
 *  @param isStart 开始还是停止
 */
-(void)loadingAnimation:(BOOL)isStart
{
    UIImageView *loadImg=[self viewWithTag:100001];
    if (isStart)
    {
        _finishImgView.hidden=NO;
        msgLab.hidden=NO;
        [LTUtils startRotationAnimation:loadImg];
    }
    else
    {
        _finishImgView.hidden=YES;
        msgLab.hidden=YES;
        [LTUtils endAnimation:loadImg];
    }
}
@end
