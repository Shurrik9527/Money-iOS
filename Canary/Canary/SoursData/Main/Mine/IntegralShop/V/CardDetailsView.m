//
//  CardDetailsView.m
//  ixit
//
//  Created by Brain on 2017/4/6.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "CardDetailsView.h"

@interface CardDetailsView()
@property (nonatomic,strong) UILabel * des;/** < 介绍V */
@property (nonatomic,strong) UILabel * authDesc;/** <兑换条件说明V */
@property (nonatomic,strong) UILabel * rulesDes;/** <使用规则说明V */
@property (nonatomic,strong) UILabel * remark;/** <备注V */

@end

@implementation CardDetailsView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self createView];
    }
    return self;
}
#pragma mark - init view
-(void)createView {
    //特权卡介绍
    if (!_des) {
        _des=[self createLabWithFrame:CGRectMake(0, 0, ScreenW_Lit, 44) text:@"" fontsize:LTAutoW(15)];
        _des.textColor=LTTitleColor;
        [self addSubview:_des];
    }
    //兑换条件
    if (!_authDesc) {
        _authDesc=[self createLabWithFrame:CGRectMake(0, 0, ScreenW_Lit, 44) text:@"" fontsize:LTAutoW(12)];
        [self addSubview:_authDesc];
    }
    //使用规则
    if (!_rulesDes) {
        _rulesDes=[self createLabWithFrame:CGRectMake(0, 0, ScreenW_Lit, 44) text:@"" fontsize:LTAutoW(12)];
        [self addSubview:_rulesDes];
    }
    //注意事项
    if (!_remark) {
        _remark=[self createLabWithFrame:CGRectMake(0, 0, ScreenW_Lit, 44) text:@"" fontsize:LTAutoW(12)];
        _remark.textColor=LTColorHex(0xFF7901);
        [self addSubview:_remark];
    }

    
}
#pragma mark - set data
#pragma mark - private method
/*根据字符串生成view
 *type 1 ：介绍；2：兑换条件；3：使用说明；4：注意事项
 */
-(void)viewWithString:(NSString *)str type:(NSInteger)type {
    if (!emptyStr(str)) {
        CGFloat fs=LTAutoW(12);
        if(type==1){
            fs=LTAutoW(15);
        }
        NSArray *arr=[str componentsSeparatedByString:@"r&n"];
        str =[str replacStr:@"r&n" withStr:@"\n"];
        NSMutableAttributedString *attr=[self attrWithStr:str strArr:arr fs:fs];
        switch (type) {
            case 1:
                _des.attributedText=attr;
                break;
            case 2:
                _authDesc.attributedText=attr;
                break;
            case 3:
                _rulesDes.attributedText=attr;
                break;
            case 4:
                _remark.attributedText=attr;
                break;
            default:
                break;
        }
        attr=nil;
    }
}
-(void)reloadFrame {
    CGFloat left = LTAutoW(16);
    CGFloat width = ScreenW_Lit-LTAutoW(32);
    [_des sizeToFit];
    _des.frame=CGRectMake(left, left, width, _des.h_);
    
    [_authDesc sizeToFit];
    _authDesc.frame=CGRectMake(left, _des.yh_+LTAutoW(24), width, _authDesc.h_);

    [_rulesDes sizeToFit];
    _rulesDes.frame=CGRectMake(left, _authDesc.yh_+LTAutoW(24), width, _rulesDes.h_);

    [_remark sizeToFit];
    _remark.frame=CGRectMake(left, _rulesDes.yh_+LTAutoW(6), width, _remark.h_);
    
    CGRect frame = self.frame;
    frame.size.height=_remark.yh_+LTAutoW(16);
    self.frame=frame;
}
-(NSMutableAttributedString *)attrWithStr:(NSString *)str strArr:(NSArray *)arr fs:(CGFloat)fs {
    NSMutableAttributedString *attr= [[NSMutableAttributedString alloc]
            initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = LTAutoW(7);
    [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];

    if (arr.count>1) {
        NSString *subStr=arr[0];
        NSRange range=[str rangeOfString:subStr];
        [attr addAttribute:NSFontAttributeName value:[UIFont boldFontOfSize:fs] range:range];
    }
    
    return attr;
}
#pragma mark - utils
-(UIView *)createV{
    UIView *v=[[UIView alloc]init];
    v.backgroundColor=LTClearColor;
    return v;
}
-(UIButton *)createBtnWithFrame:(CGRect)frame title:(NSString *)title fontsize:(CGFloat)fsize{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:fsize];
    return btn;
}
-(UILabel *)createLabWithFrame:(CGRect)frame text:(NSString *)text fontsize:(CGFloat)fsize{
    UILabel *label=[[UILabel alloc]init];
    label.frame=frame;
    label.backgroundColor=[UIColor clearColor];
    label.text=text;
    label.textAlignment=NSTextAlignmentLeft;
    label.numberOfLines=0;
    label.textColor=LTSubTitleColor;
    label.font=[UIFont systemFontOfSize:fsize];
    return label;
}
-(UIImageView *)createImgViewWithFrame:(CGRect)frame imageName:(NSString *)image{
    UIImageView *imgv=[[UIImageView alloc]initWithImage:[UIImage imageNamed:image]];
    imgv.frame=frame;
    return imgv;
}

#pragma mark - 外部
-(void)refreshWithModel:(CardDetailsMo *)mo {
    NSString *des = mo.giftDesc;
    [self viewWithString:des type:1];
    
    NSString *authDes = mo.giftAuthDesc;
    [self viewWithString:authDes type:2];

    NSString *rulesDes = mo.giftRuleDesc;
    [self viewWithString:rulesDes type:3];

    NSString *remarkDes = mo.giftRemark;
    [self viewWithString:remarkDes type:4];

    [self reloadFrame];
}



@end
