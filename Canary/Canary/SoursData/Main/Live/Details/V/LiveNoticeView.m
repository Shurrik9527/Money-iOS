//
//  LiveNoticeView.m
//  ixit
//
//  Created by Brain on 2017/3/15.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "LiveNoticeView.h"
#import "LTArcProgressView.h"

@interface LiveNoticeView()
@property (nonatomic,strong) LTArcProgressView *progressView;//圆形进度条
@property (nonatomic,strong) UIImageView * noticeIcon;
@property (nonatomic,strong) UILabel * msgLab;
@end
@implementation LiveNoticeView
#define Height 42
static CGFloat pvh=22.5;
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor=LTColorHexA(0x6C97FC, 0.92);
    self.alpha=1;
    if (self) {
        [self initNoticeView];
    }
    return self;
}

-(void)initNoticeView {
    [self initImg];
    [self initMsgLab];
}
-(void)initImg {
    CGFloat pvh=22.5;
    if(!_progressView) {
        _progressView = [[LTArcProgressView alloc] initWithFrame:CGRectMake(LTAutoW(kLeftMar), (self.h_-pvh)/2.0, pvh, pvh) type:ArcProgressType_Notice];
        [_progressView changeColor:LTWhiteColor];
        [self addSubview:_progressView];
    }
    if (!_noticeIcon) {
        _noticeIcon= [self createImgViewWithFrame:CGRectMake(0, 0, pvh, pvh) imageName:@"noticeIcon"];
        _noticeIcon.center=_progressView.center;
        [_progressView addSubview:_noticeIcon];
    }
}
-(void)initMsgLab{
    if (!_msgLab) {
        _msgLab=[self createLabWithFrame:CGRectMake(_progressView.xw_+LTAutoW(12), 8, self.w_-_progressView.xw_-LTAutoW(24), self.h_-16) text:@"" fontsize:LTAutoW(12)];
        [self addSubview:_msgLab];
    }
}
#pragma mark - method
//msg 消息体； time 动画时间；
-(void)configNoticeWithMsg:(NSString *)msg time:(NSTimeInterval)time{
    _msgLab.attributedText=[self ABStr:msg];
    [self reloadSubviewFrame];
    [self showWithTime:time];//出现动画
    [self performSelector:@selector(hide) withObject:nil afterDelay:(time+0.2)];
}
- (NSAttributedString *)ABStr:(NSString *)str {
    NSMutableAttributedString *ABStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range = NSMakeRange(0, str.length);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4.f;
    [ABStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [ABStr addAttribute:NSFontAttributeName value:autoFontSiz(12) range:range];
    return ABStr;
}
-(void)reloadSubviewFrame {
    [_msgLab sizeToFit];
    CGFloat h = _msgLab.h_;
    if (h+16>Height) {
        CGRect frame = self.frame;
        frame.size.height=h+16;
        self.frame=frame;
        _msgLab.frame=CGRectMake(_msgLab.x_, 8, _msgLab.w_, h);
        _progressView.frame=CGRectMake(LTAutoW(kLeftMar), (self.h_-_progressView.w_)/2.0, _progressView.w_, _progressView.w_);
        _noticeIcon.frame=CGRectMake(( _progressView.w_-pvh)/2.0,( _progressView.h_-pvh)/2.0,pvh, pvh);
    }else{
        CGRect frame = self.frame;
        frame.size.height=Height;
        _msgLab.frame=CGRectMake(_msgLab.x_, (Height-h)/2.0+2, _msgLab.w_, h);
        _progressView.frame=CGRectMake(LTAutoW(kLeftMar), (Height-_progressView.w_)/2.0, _progressView.w_, _progressView.w_);
        _noticeIcon.frame=CGRectMake(( _progressView.w_-pvh)/2.0,( _progressView.h_-pvh)/2.0,pvh, pvh);
        self.frame=frame;
    }
}
-(void)showWithTime:(NSTimeInterval)time {
    WS(ws);
    self.hidden=NO;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = ws.frame;
        frame.origin.x=0;
        ws.frame=frame;
    } completion:^(BOOL finished) {
        if (finished) {
            [ws.progressView animateWithTime:time fromValue:0 toValue:1];
        }
    }];
}
-(void)hide {
    self.hidden=YES;
    CGRect frame = self.frame;
    frame.origin.x=ScreenW_Lit;
    self.frame=frame;
}
#pragma mark - utils

-(UILabel *)createLabWithFrame:(CGRect)frame text:(NSString *)text fontsize:(CGFloat)fsize{
    UILabel *label=[[UILabel alloc]init];
    label.frame=frame;
    label.backgroundColor=[UIColor clearColor];
    label.text=text;
    label.textAlignment=NSTextAlignmentLeft;
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
-(UIButton *)createBtnWithFrame:(CGRect)frame title:(NSString *)title fontsize:(CGFloat)fsize{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:fsize];
    return btn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
