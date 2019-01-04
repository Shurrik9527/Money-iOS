//
//  CertificationResultVC.m
//  Canary
//
//  Created by Brain on 2017/5/19.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "CertificationResultVC.h"
#import "CertificationVCtrl.h"

@interface CertificationResultVC ()
@property (nonatomic,assign) NSInteger resultType;//验证结果 1：认证失败，2：资料未认证，3：认证中，4：认证成功

@property (nonatomic,strong) UIImageView * statusIcon;
@property (nonatomic,strong) UILabel * resultLab;//结果lab
@property (nonatomic,strong) UILabel * hintLab;//提示lab
@property (nonatomic,strong) UIButton * resultBtn;//根据验证结果去对应事件 0->返回root 1.跳转交易 2.重新提交

@end

@implementation CertificationResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navTitle:@"实名认证" backType:BackType_PopToRoot];
    _resultType=UD_CardDistStatus;
    [self createAuditView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init

-(void)createAuditView{
    CGFloat iconW=90;
    NSString *imgName = @"distStatus_3";
    NSString *resultStr = @"提交成功,信息审核中";
    NSString *hintStr = @"预计审核在24小时内完成\n届时会有工作人员通知您结果";
    NSString *btnTitle = @"返回首页";
    
    CGFloat topPading=64;
    if (ScreenW_Lit==320) {
        topPading=32;
    }
    //状态图标
    _statusIcon=[self createImgViewWithF:CGRectMake((self.view.w_-iconW)/2.0, 90+topPading, iconW, iconW) imgName:imgName];
    [self.view addSubview:_statusIcon];
    
    //结果label
    _resultLab=[self createLabWithF:CGRectMake(0, _statusIcon.yh_+topPading, self.view.w_, 24)  text:resultStr fsize:bigFontSize];
    _resultLab.textColor=LTTitleColor;
    [self.view addSubview:_resultLab];
    [_resultLab sizeToFit];
    _resultLab.frame=CGRectMake(0, _resultLab.y_, self.view.w_, _resultLab.h_);
    
    //提示语
    _hintLab=[self createLabWithF:CGRectMake(0, _resultLab.yh_+8, self.view.w_, 48)  text:hintStr fsize:midFontSize];
    [self.view addSubview:_hintLab];
    [_hintLab sizeToFit];
    _hintLab.frame=CGRectMake(0, _hintLab.y_, self.view.w_, _hintLab.h_);

    //按钮
    _resultBtn=[self createBtnWithF:CGRectMake(16, _hintLab.yh_+topPading, self.view.w_-32, 44) title:btnTitle fsize:midFontSize];
    [self.view addSubview:_resultBtn];
    
    
    
    //版权
    CGFloat coprW=ScreenW_Lit;
    CGFloat coprH=16;
    UILabel *copr;
    copr=[self createLabWithF:CGRectMake(0, self.view.h_-coprH-16, coprW, coprH) text:@"" fsize:12];
    copr.textColor=LTSubTitleColor;
    copr.attributedText=[NSAttributedString copyrightAttr];
    [self.view addSubview:copr];
    [self configView];
}

#pragma mark - setData
-(void)setResultType:(NSInteger)resultType{
    _resultType=resultType;
}
#pragma mark - action
-(void)btnAction {
    switch (_resultType) {
        case 3: {//返回首页
            NFC_PostName(NFC_PushHomeView);
            [self.navigationController popToRootVC];
        }
            break;
            
        case 1: {//审核失败，重新提交
            CertificationVCtrl *cer=[[CertificationVCtrl alloc]init];
            [self.navigationController pushViewController:cer animated:YES];
        }
            break;
        case 4: {//审核成功,开始交易
            NFC_PostName(NFC_PushProductList);
            [self.navigationController popToRootVC];
            [AppDelegate selectTabBarIndex:2];
        }
            break;
        default:
            break;
    }
}
//跳转页面
-(void)leftAction{
    [self.navigationController popVC];
}
//配置页面
-(void)configView{
    NSString *imgName = @"distStatus_3";
    NSString *resultStr = @"实名资料提交中";
    NSString *hintStr = @"预计审核在24小时内完成";
    NSString *btnTitle = @"返回首页";
    
    switch (_resultType) {
            
        case 1: {
            imgName = @"distStatus_1";
            resultStr=@"抱歉！身份信息审核未通过";
            hintStr=@"请点击按钮重新提交！";
            btnTitle=@"重新提交";
        }
            break;
        case 4: {
            imgName = @"distStatus_4";
            resultStr=@"恭喜！实名资料提交成功";
            hintStr=@"";
            btnTitle=@"立即入金，开始交易";
            
        }
            break;
        default:
            break;
    }
    _statusIcon.image=[UIImage imageNamed:imgName];
    _resultLab.text=resultStr;
    _hintLab.text=hintStr;
    [_resultBtn setTitle:btnTitle forState:UIControlStateNormal];
}

#pragma mark - utils
-(UIButton *)createBtnWithF:(CGRect)frame title:(NSString *)title fsize:(CGFloat)fsize{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:BlueLineColor];
    btn.titleLabel.font=[UIFont systemFontOfSize:fsize];
    btn.layer.masksToBounds=YES;
    btn.layer.cornerRadius=3;
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
#pragma mark - request

#pragma mark - delegate


@end
