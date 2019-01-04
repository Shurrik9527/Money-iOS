//
//  FocusCell.m
//  ixit
//
//  Created by Brain on 2017/4/20.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "FocusCell.h"

@interface FocusCell ()
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UIImageView *headIcon;
@property (nonatomic,strong) UIView *tagV;//标签view
@property (nonatomic,strong) UIButton *focusBtn;//关注按钮

@property (nonatomic,assign) BOOL focusStatus;/**< NO 未关注 默认：YES 已关注*/
@end
@implementation FocusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark -  init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = LTWhiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createCell];
    }
    return self;
}
- (void)createCell {
    _headIcon=[self createImgViewWithFrame:CGRectMake(16, 14, 60, 60) imageName:@""];
    _headIcon.image= [UIImage imageNamed:@"Head80"];
    [self.contentView addSubview:_headIcon];
    
    _nameLab=[self createLabWithFrame:CGRectMake(_headIcon.xw_+16, 24, 160, 15) text:@"老师" fontsize:15];
    _nameLab.textAlignment=NSTextAlignmentLeft;
    _nameLab.textColor=LTTitleColor;
    [self.contentView addSubview:_nameLab];
    
    _focusBtn=[self createBtnWithFrame:CGRectMake(self.w_-16-68, 28, 68, 32) title:@"已关注" fontsize:15];
    _focusBtn.layer.masksToBounds=YES;
    _focusBtn.layer.borderColor=BlueLineColor.CGColor;
    _focusBtn.layer.cornerRadius=3;
    _focusBtn.layer.borderWidth=1;
    [_focusBtn addTarget:self action:@selector(focusAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_focusBtn];
    _focusStatus=1;
    
    _tagV=[[UIView alloc]init];
    _tagV.frame=CGRectMake(_nameLab.x_, _nameLab.yh_+10, ScreenW_Lit-_nameLab.x_, 15);
    _tagV.backgroundColor=LTWhiteColor;
    [self.contentView addSubview:_tagV];
}
#pragma mark - method
//关注按钮
-(void)focusAction {
    self.focusStatus=!_focusStatus;//改变关注状态
}
//关注状态设置
-(void)setFocusStatus:(BOOL)focusStatus{
    _focusStatus=focusStatus;
    [self changeBtnStatus:_focusStatus];
}
//根据关注状态改变关注按钮
-(void)changeBtnStatus:(BOOL)status {
    UIColor *bgColor = LTClearColor;
    UIColor *titleColor = BlueFont;
    NSString *title = @"已关注";
    if (!status) {
        bgColor=BlueLineColor;
        titleColor=LTWhiteColor;
        title = @"+ 关注";
    }
    [_focusBtn setBackgroundColor:bgColor];
    [_focusBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [_focusBtn setTitle:title forState:UIControlStateNormal];
}
-(void)configTagViewWithArray:(NSArray *)tagArr{
//    [_tagV removeAllSubView];//移除老标签
    for (int i =0; i<tagArr.count; i++) {
        NSString *tagStr=tagArr[i];
        if (i<_tagV.subviews.count) {
            UILabel *lab =[_tagV viewWithTag:100 +i];
            if (lab && [lab isKindOfClass:[UILabel class]]) {
                lab.text=tagStr;
            }else {
                
            }
        }else{
            
        }
    }
}
#pragma mark - utils
-(UIButton *)createBtnWithFrame:(CGRect)frame title:(NSString *)title fontsize:(CGFloat)fsize{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:BlueFont forState:UIControlStateNormal];
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
    label.textColor=LTSubTitleColor;
    label.font=[UIFont systemFontOfSize:fsize];
    return label;
}

-(UILabel *)createTagLabWithFrame:(CGRect)frame text:(NSString *)text {
    UILabel *label=[[UILabel alloc]init];
    label.frame=frame;
    label.backgroundColor=[UIColor clearColor];
    label.text=text;
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=LTSubTitleColor;
    label.font=[UIFont systemFontOfSize:12];
    label.layer.masksToBounds=YES;
    label.layer.cornerRadius=2;
    label.layer.borderWidth=1;
    label.layer.borderColor=LTSubTitleColor.CGColor;
    return label;
}

-(UIImageView *)createImgViewWithFrame:(CGRect)frame imageName:(NSString *)image{
    UIImageView *imgv=[[UIImageView alloc]initWithImage:[UIImage imageNamed:image]];
    imgv.frame=frame;
    return imgv;
}

@end
