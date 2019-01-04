//
//  WQAnnouncementView.m
//  ixit
//
//  Created by Brain on 16/7/18.
//  Copyright © 2016年 ixit. All rights reserved.
//

#import "WQAnnouncementView.h"
#define hideTime 5
@implementation WQAnnouncementView


- (void)dealloc {
    NSLog(@"WQAnnouncementView dealloc");
}

-(instancetype)initWithFrame:(CGRect)frame Message:(NSString *)msg
{
    NSLog(@"WQAnnouncementView dealloc");
    if (self==[super initWithFrame:frame])
    {
        self.frame=frame;
        self.backgroundColor=LTKLineRed;
        [self initIcon];
        [self initMsgLab];
        _msgLab.text=msg;
    }
    return self;
}
-(void)initIcon
{
    _icon = [[UIImageView alloc]init];
    _icon.frame=CGRectMake(16, 4, 15, 15);
    _icon.image=[UIImage imageNamed:@"horn"];
    _icon.backgroundColor=LTClearColor;
    [self addSubview:_icon];
}
-(void)initMsgLab
{
    _msgLab=[[UILabel alloc]init];
    _msgLab.frame=CGRectMake(32, 0, self.frame.size.width-48, self.frame.size.height);
    _msgLab.backgroundColor=[UIColor clearColor];
    _msgLab.textAlignment=NSTextAlignmentLeft;
    _msgLab.numberOfLines=0;
    _msgLab.textColor=LTSubTitleRGB;
    _msgLab.font=[UIFont systemFontOfSize:12];
    [self addSubview:_msgLab];
}
-(void)show
{
    self.hidden=NO;
    WS(ws);
    [UIView animateWithDuration:hideTime animations:^{
        [ws hide];
    }];
}
-(void)hide
{
    self.hidden=YES;
}
- (void)drawRect:(CGRect)rect {
    _icon.frame=CGRectMake(16, 4, 15, 15);
    _msgLab.frame=CGRectMake(32, 0, self.frame.size.width-48, self.frame.size.height);

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
