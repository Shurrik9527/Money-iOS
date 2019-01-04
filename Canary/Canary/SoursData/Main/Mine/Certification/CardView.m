//
//  CardView.m
//  Canary
//
//  Created by Brain on 2017/5/23.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "CardView.h"
typedef void(^UpdatePhotoBlock)(UIImage *img);

@interface CardView()
@property(assign,nonatomic)BOOL isFront;//是否正面

@property(strong,nonatomic)UIImageView * cardIcon;
@property(strong,nonatomic)UIImageView * addIcon;
@property(strong,nonatomic)UILabel * noteLab;
@property(strong,nonatomic)UIButton * addBtn;


@end
#define FrontStr @"身份证正面照片扫描"
#define SideStr @"身份证反面照片扫描"
#define AddImgName @"addPhotoIcon"
#define FrontImgName @"cardFrontBG"
#define SideImgName @"cardSideBG"

@implementation CardView

#pragma mark - init
-(instancetype)initWithFrame:(CGRect)frame isFront:(BOOL)isFront{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius=3;
        self.layer.masksToBounds=YES;
        self.backgroundColor=LTWhiteColor;
        [self createView];
        self.isFront=isFront;
    }
    return self;
}
-(void)createView{
    CGFloat imgW=103;
    CGFloat imgH=70;
    CGFloat addW=25;
    CGFloat noteH=16;
    CGFloat pading=23.5;
    CGFloat x = (self.w_-imgW)/2.0;
    CGFloat y = (self.h_-imgH-pading-noteH)/2.0;
    //身份证卡片
    _cardIcon=[self createImgViewWithF:CGRectMake(x, y, imgW, imgH) imgName:FrontImgName];
    [self addSubview:_cardIcon];
    //加号icon
    _addIcon=[self createImgViewWithF:CGRectMake(_cardIcon.xw_-addW/2.0, _cardIcon.yh_-addW/2.0, addW, addW) imgName:AddImgName];
    [self addSubview:_addIcon];
    //提示语
    _noteLab=[self createLabWithF:CGRectMake(0, _cardIcon.yh_+pading, self.w_, noteH) text:FrontStr fsize:15];
    [self addSubview:_noteLab];
    //点击事件
    _addBtn=[self createBtnWithF:self.frame];
    [self addSubview:_addBtn];
}
-(void)setIsFront:(BOOL)isFront {
    _isFront=isFront;
    NSString *imgName = SideImgName;
    NSString *noteStr = SideStr;
    if (isFront) {
        imgName=FrontImgName;
        noteStr = FrontStr;
    }
    _cardIcon.image=[UIImage imageNamed:imgName];
    _noteLab.text=noteStr;
}
#pragma mark - action
-(void)btnAction{
    _choosePhoto?_choosePhoto():nil;
}
-(void)configStatus:(BOOL)isSuccess image:(UIImage *)image{
    if (!_photoImg) {
        _photoImg =[self createImgViewWithF:CGRectMake(0, 0, self.w_, self.h_) imgName:@""];
        [self insertSubview:_photoImg belowSubview:_addBtn];
    }
    if (isSuccess && image) {
        _photoImg.hidden=NO;
        _photoImg.image=image;
        _photoImg.frame=CGRectMake(0, 0, self.w_, self.h_);
    }else{
        _photoImg.hidden=YES;
        _noteLab.attributedText=[self failAttr];
    }
}
#pragma mark - request
#pragma mark - delegate

#pragma mark - utils
-(UIButton *)createBtnWithF:(CGRect)frame{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
-(UILabel *)createLabWithF:(CGRect)frame text:(NSString *)text fsize:(CGFloat)fsize{
    UILabel *label=[[UILabel alloc]init];
    label.frame=frame;
    label.backgroundColor=[UIColor clearColor];
    label.text=text;
    label.textAlignment=NSTextAlignmentCenter;
    label.numberOfLines=0;
    label.textColor=LTSubTitleColor;
    label.font=[UIFont systemFontOfSize:fsize];
    return label;
}
-(UIImageView *)createImgViewWithF:(CGRect)frame imgName:(NSString *)image{
    UIImageView *imgv=[[UIImageView alloc]initWithImage:[UIImage imageNamed:image]];
    imgv.frame=frame;
    return imgv;
}
-(NSMutableAttributedString *)failAttr{
    
    NSMutableAttributedString *attr=[[NSMutableAttributedString alloc]init];
    //图片
    NSTextAttachment *attachment=[[NSTextAttachment alloc] initWithData:nil ofType:nil];
        UIImage *img=[UIImage imageNamed:@"errorIcon"];
    attachment.image=img;
    attachment.bounds=CGRectMake(0, 0, 12.5, 12.5);
    NSAttributedString *imgAttachString = [NSAttributedString attributedStringWithAttachment:attachment];
    [attr appendAttributedString:imgAttachString];
    
    NSMutableAttributedString *subAttr=[[NSMutableAttributedString alloc] initWithString:@"上传失败，点击重试"];
    NSRange range = NSMakeRange(subAttr.length-2, 2);
    //下滑线
    NSDictionary *attrDic=@{NSFontAttributeName :[UIFont systemFontOfSize:15],
                            NSForegroundColorAttributeName:BlueFont,
                            NSUnderlineStyleAttributeName:@(1),
                            NSUnderlineColorAttributeName:BlueFont
                            };
    [subAttr setAttributes:attrDic range:range];
    [attr appendAttributedString:subAttr];
    return attr;
}
@end
