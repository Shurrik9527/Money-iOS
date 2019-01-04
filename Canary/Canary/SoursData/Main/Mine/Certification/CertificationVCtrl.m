//
//  CertificationVCtrl.m
//  Canary
//
//  Created by Brain on 2017/5/19.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "CertificationVCtrl.h"
#import "CardView.h"
#import "LabelTextFiled.h"
#import "CertificationResultVC.h"
#import "LTAlertSheetView.h"
#import "ChooseDateV.h"

@interface CertificationVCtrl ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>{
    CGFloat keyboardH;
}
@property (nonatomic,strong) UIScrollView * scroll;
@property (nonatomic,strong) UILabel * noteV;//提示view
@property (nonatomic,strong) CardView * cardFront;//正面
@property (nonatomic,strong) UIView * cardFrontMsgV;//正面信息
@property (nonatomic,strong) LabelTextFiled * cardNumTxf;//身份证号码
@property (nonatomic,strong) LabelTextFiled * cardNameTxf;//姓名
@property (nonatomic,strong) LabelTextFiled * cardSexTxf;//性别
@property (nonatomic,strong) LTAlertSheetView *sexV;//选择性别


@property (nonatomic,strong) CardView * cardSide;//反面
@property (nonatomic,strong) UIView * cardSideMsgV;//反面信息
@property (nonatomic,strong) LabelTextFiled * cardValidityEndTxf;//失效期
@property (nonatomic,strong) LabelTextFiled * cardValidityStartTxf;//有效期

@property (nonatomic,strong) UITextField * curTxf;//当前txf

@property (nonatomic,strong) UIView * submitV;//提交
@property (nonatomic,strong) UIButton * submitBtn;//提交按钮
@property (nonatomic,strong) UIButton * protocolBtn;//协议按钮

@property (nonatomic,strong) UILabel * copyrightView;//版权

@property(assign,nonatomic)BOOL isFront;//记录正反面
@property (nonatomic,strong) LTAlertSheetView *popViewChangeHeadIV;

@property(strong,nonatomic)UIImagePickerController * picker;//相机
@property (nonatomic,strong) UIImageView * overView;//框
@property(assign,nonatomic)UIImagePickerControllerSourceType sourceType;//类型

@property(strong,nonatomic)ChooseDateV * datePicker;//时间选取
@property(assign,nonatomic)BOOL isValidity;//是否有效期

@end

@implementation CertificationVCtrl
#define NoteStr @"注册已成功！\n实名认证后，即可开始交易"
#define kLineBlueColor   LTRGB(72, 119, 230)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navTitle:@"实名认证" backType:BackType_PopVC];
    [self createView];
    
//    [self showCardSideMsgV];
//    [self showCardFrontMsgV];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init
-(void)createView{
    [self createScroll];
    [self createNoteView];//提示语
    [self createCardView:YES];//正面
    [self createCardFrontMsgV];//正面信息，号码，姓名，性别
    [self createCardView:NO];//反面
    [self createCardSideMsgV];//反面信息，生日有效期
    [self createSubmitView];//提交
    [self addNotification];//键盘监听
    
}
-(void)createScroll{
    _scroll=[[UIScrollView alloc]init];
    _scroll.bounces=NO;
    _scroll.frame=CGRectMake(0, 64, ScreenW_Lit, ScreenH_Lit-64);
    _scroll.contentSize=CGSizeMake(ScreenW_Lit, _scroll.frame.size.height);
    _scroll.backgroundColor=LTClearColor;
    [self.view addSubview:_scroll];
}

-(void)createNoteView{
    _noteV=[self createLabWithF:CGRectMake(0, 0, ScreenW_Lit,56) text:NoteStr fsize:15];
    _noteV.backgroundColor=BlueFont;
    [_scroll addSubview:_noteV];
}
-(void)createCardView:(BOOL)isFront{
    CGFloat h =(ScreenW_Lit-34) *352/682.0;//宽高比
    CGRect frame = CGRectMake(17, _noteV.yh_+10, ScreenW_Lit-34, h);
    CardView *card=[[CardView alloc]initWithFrame:frame isFront:isFront];
    if (isFront) {
        _cardFront=card;
    }else{
        card.frame=CGRectMake(17, _cardFront.yh_+10, ScreenW_Lit-34, h);
        _cardSide=card;
    }
    WS(ws);
    card.choosePhoto=^{
        [ws showActionSheetWithBool:isFront];
    };
    [_scroll addSubview:card];
}

-(void)createSubmitView{
    CGFloat btnH=44;
    CGFloat pading = 12;
    CGFloat xyH=16;
    _submitV=[[UIView alloc]init];
    _submitV.frame=CGRectMake(16, _cardSide.yh_+pading, ScreenW_Lit-32, btnH + 5*pading + xyH *2+32);
    _submitV.backgroundColor=LTClearColor;
    [_scroll addSubview:_submitV];
    //图片
    UIView *imgScroll = [self imgScrllV:CGRectMake(0, 0, _submitV.w_,100)];
    [_submitV addSubview:imgScroll];
    _submitV.frame= CGRectMake(16, _cardSide.yh_+pading, ScreenW_Lit-32, btnH + 5*pading + xyH *2+32+imgScroll.h_);
    
    _submitBtn=[self createBtnWithF:CGRectMake(0, imgScroll.yh_, _submitV.w_, btnH) title:@"提交" fsize:18];
    [_submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [_submitBtn setBackgroundColor:LTGrayBtnBGColor];
    [_submitBtn setTitleColor:LTSubTitleColor forState:UIControlStateNormal];
    _submitBtn.layer.cornerRadius=3;
    _submitBtn.layer.masksToBounds=YES;
    _submitBtn.enabled=NO;
    [_submitV addSubview:_submitBtn];
    
    NSString *protocolStr0 = @"点击注册表示您已阅读并同意";
    NSString *protocolStr1 = @"《开户协议》";
    NSString *protocolStr = [NSString stringWithFormat:@"%@%@",protocolStr0,protocolStr1];
    NSMutableAttributedString *ABStr = [[NSMutableAttributedString alloc] initWithString:protocolStr];
    [ABStr addAttribute:NSForegroundColorAttributeName value:LTSubTitleColor range:NSMakeRange(0, protocolStr0.length)];
    [ABStr addAttribute:NSForegroundColorAttributeName value:kLineBlueColor range:NSMakeRange(protocolStr0.length, protocolStr1.length)];
    
    _protocolBtn = [UIButton btnWithTarget:self action:@selector(protocolAction) frame:CGRectMake(16, _submitBtn.yh_ + 3*pading, ScreenW_Lit-32, 20)];
    _protocolBtn.titleLabel.font = fontSiz(13);
    [_protocolBtn setAttributedTitle:ABStr forState:UIControlStateNormal];
    [_submitV addSubview:_protocolBtn];
    
    //版权
    _copyrightView=[self createLabWithF:CGRectMake(0, _submitV.h_-32-16, _submitV.w_, 16) text:@"" fsize:12];
    _copyrightView.textColor=LTSubTitleColor;
    _copyrightView.attributedText=[NSAttributedString copyrightAttr];
    [_submitV addSubview:_copyrightView];
    
    _scroll.contentSize=CGSizeMake(ScreenW_Lit, _submitV.yh_);
}
-(UIView *)imgScrllV:(CGRect)frame{
    UIView *imgScrollV=[[UIView alloc]init];
    imgScrollV.frame =frame;
    
    UILabel *lab = [self createLabWithF:CGRectMake(0, 0, _submitV.w_, 20) text:@"照片要求" fsize:12];
    [lab sizeToFit];
    lab.textColor=LTSubTitleColor;
    [_submitV addSubview:lab];
    CGFloat x = 4;
    CGFloat w = (frame.size.width-5*4)/4;
    CGFloat h = w*(127.0/141);
    CGFloat px=w+4;
    for (int i=0; i<4; i++) {
        CGRect frm = CGRectMake(x, lab.yh_ + 8, w, h);
        NSString *name = [NSString stringWithFormat:@"standCard%i",i];
        UIImageView *img=[self createImgViewWithF:frm imgName:name];
        [imgScrollV addSubview:img];
        x+=px;
    }
    frame.size.height = lab.yh_ + h+24;
    imgScrollV.frame = frame;
    return imgScrollV;

}
-(void)createCardFrontMsgV {
    CGFloat pading= 12;
    CGFloat txfH=44;
    CGFloat labH = 16;
    _cardFrontMsgV=[self createViewWithF:CGRectMake(0, _cardFront.yh_+10, _scroll.w_, pading*3+txfH*3+labH)];
    [_scroll addSubview:_cardFrontMsgV];
    
    CGFloat minw=[LTUtils labelWithFontsize:15 text:@"身份证号码"];
    _cardNumTxf=[self createTxfWithF:CGRectMake(16, 0, _cardFrontMsgV.w_-32, txfH) minLeftW:minw leftTxt:@"身份证号码"];
    [_cardFrontMsgV addSubview:_cardNumTxf];
    
    _cardNameTxf=[self createTxfWithF:CGRectMake(16, _cardNumTxf.yh_+pading, _cardFrontMsgV.w_-32, txfH) minLeftW:minw leftTxt:@"姓名"];
    [_cardFrontMsgV addSubview:_cardNameTxf];
    
    _cardSexTxf=[self createTxfWithF:CGRectMake(16, _cardNameTxf.yh_+pading, _cardFrontMsgV.w_-32, txfH) minLeftW:minw leftTxt:@"性别"];
    [_cardFrontMsgV addSubview:_cardSexTxf];
    
    CGRect fm=_cardSexTxf.frame;
    fm.origin.y=_cardSexTxf.yh_+3;
    fm.size.height=labH;
    NSString *note=@" 若以上信息有误，请重新上传身份证正面照片";
    UILabel *lab=[self createLabWithF:fm text:note fsize:12];
    lab.textAlignment=NSTextAlignmentLeft;
    lab.textColor=BlueFont;
    [_cardFrontMsgV addSubview:lab];
    _cardFrontMsgV.hidden=YES;
}
-(void)createCardSideMsgV {
    CGFloat pading= 12;
    CGFloat txfH=44;
    CGFloat labH = 16;
    _cardSideMsgV=[self createViewWithF:CGRectMake(0, _cardSide.yh_+pading, _scroll.w_, (pading+txfH)*2+labH)];
    [_scroll addSubview:_cardSideMsgV];
    
    CGFloat minw=[LTUtils labelWithFontsize:15 text:@"身份有效日期"];
    _cardValidityStartTxf=[self createTxfWithF:CGRectMake(16, 0, _cardSideMsgV.w_-32, txfH) minLeftW:minw leftTxt:@"身份有效日期"];
    [_cardSideMsgV addSubview:_cardValidityStartTxf];
    
    _cardValidityEndTxf=[self createTxfWithF:CGRectMake(16, _cardValidityStartTxf.yh_+pading, _cardSideMsgV.w_-32, txfH) minLeftW:minw leftTxt:@"身份失效日期"];
    [_cardSideMsgV addSubview:_cardValidityEndTxf];
    
    CGRect fm=_cardValidityStartTxf.frame;
    fm.origin.y=_cardValidityEndTxf.yh_+3;
    fm.size.height=labH;
    NSString *note=@" 若以上信息有误，请重新上传身份证反面照片";
    UILabel *lab=[self createLabWithF:fm text:note fsize:12];
    lab.textAlignment=NSTextAlignmentLeft;
    lab.textColor=BlueFont;
    [_cardSideMsgV addSubview:lab];
    _cardSideMsgV.hidden=YES;
}
-(UIView *)cameraOverlayView{
    if (!_overView) {
        _overView=[[UIImageView alloc]init];
        CGFloat w = 666/675.0*ScreenW_Lit;
        CGFloat h = w/(666/1026.0)-94;
        _overView.frame=CGRectMake((ScreenW_Lit-w)/2.0, 52, w, h);
    }
    NSString *caseName=@"sideCase";
    if (_isFront) {
        caseName=@"frontCase";
    }
    UIImage *caseImg=[UIImage imageNamed:caseName];
    caseImg=[caseImg stretchableImageWithLeftCapWidth:100 topCapHeight:100];
    _overView.image=caseImg;
    return _overView;
}
#pragma mark - action
-(void)leftAction {
    WS(ws);
    [LTAlertView alertTitle:@"要退出实名认证吗？" message:nil sureTitle:@"继续认证" sureAction:nil cancelTitle:@"退出" cancelAction:^{
        [ws.navigationController popVC];
    } sureBtnTextColor:BlueLineColor cancelBtnTextColor:LTSubTitleColor];
}
//显示正面的信息
-(void)showCardFrontMsgV{
    CGFloat pading=12;
    _cardFrontMsgV.hidden=NO;
    _cardSide.frame=CGRectMake(17, _cardFrontMsgV.yh_, ScreenW_Lit-34, _cardSide.h_);
    _cardSideMsgV.frame=CGRectMake(0, _cardSide.yh_+pading, _scroll.w_, _cardSideMsgV.h_);
    if (_cardSideMsgV.hidden) {
        _submitV.frame=CGRectMake(16, _cardSide.yh_+pading, ScreenW_Lit-32, _submitV.h_);
    }else{
        _submitV.frame=CGRectMake(16, _cardSideMsgV.yh_, ScreenW_Lit-32, _submitV.h_);
    }
    _scroll.contentSize=CGSizeMake(ScreenW_Lit, _submitV.yh_);
    [self enableSubmit];
}
//显示反面的信息
-(void)showCardSideMsgV{
    _cardSideMsgV.hidden=NO;
    _cardSideMsgV.frame=CGRectMake(0, _cardSide.yh_+12, _scroll.w_, _cardSideMsgV.h_);
    _submitV.frame=CGRectMake(16, _cardSideMsgV.yh_, ScreenW_Lit-32, _submitV.h_);
    _scroll.contentSize=CGSizeMake(ScreenW_Lit, _submitV.yh_);
    [self enableSubmit];

}
//显示actionsheet

-(void)showSex {
    [self.view endEditing:YES];
    if (!_sexV) {
        NSString *title =@"选择性别";
        CGRect rect = CGRectMake(0, NavBarTop_Lit, ScreenW_Lit, ScreenH_Lit - NavBarTop_Lit);
        _sexV = [[LTAlertSheetView alloc] initWithFrame:rect];
        [self.view addSubview:_sexV];
        [_sexV configContentView:title mos:@[@"男",@"女"]];
        WS(ws);
        _sexV.alertSheetBlock = ^(NSInteger idx){
            if (idx == 0) {
                ws.cardSexTxf.textField.text=@"男";
            } else {
                ws.cardSexTxf.textField.text=@"女";
            }
        };
    }
    [_sexV showView:YES];
}

-(void)showActionSheetWithBool:(BOOL)isFront {
    [self.view endEditing:YES];
    NSString *title =@"选择正面照片";
    if (!isFront) {
        title=@"选择反面照片";
    }
    self.isFront=isFront;
    
    CGRect rect = CGRectMake(0, NavBarTop_Lit, ScreenW_Lit, ScreenH_Lit - NavBarTop_Lit);
    self.popViewChangeHeadIV = [[LTAlertSheetView alloc] initWithFrame:rect];
    [self.view addSubview:_popViewChangeHeadIV];
    [_popViewChangeHeadIV configContentView:title mos:@[@"拍照",@"相册"]];
    WS(ws);
    _popViewChangeHeadIV.alertSheetBlock = ^(NSInteger idx){
        if (idx == 0) {
            if (![LTUtils canUseCamera]) {
                return;
            }
            [ws showPhotoPickerWithType:UIImagePickerControllerSourceTypeCamera];
        } else {
            [ws showPhotoPickerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    };
    [ws.popViewChangeHeadIV showView:YES];
}
//显示相机
-(void)showPhotoPickerWithType:(UIImagePickerControllerSourceType)type {
    if(!_picker){
        _picker=[[UIImagePickerController alloc]init];
        _picker.delegate=self;
    }
    _picker.sourceType=type;
    if (type==UIImagePickerControllerSourceTypeCamera) {
//        _picker.showsCameraControls = NO;//关闭默认的摄像设备
        [_picker.view addSubview:[self cameraOverlayView]];
    }
    _picker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:_picker animated:YES completion:nil];
    [self.popViewChangeHeadIV showView:NO];
}

-(void)showDatePicker {
    [self.view endEditing:YES];
    if (!_datePicker) {
        _datePicker=[[ChooseDateV alloc]init];
        WS(ws);
        _datePicker.chooseDate=^(NSString *day){
            if (ws.isValidity) {
                ws.cardValidityStartTxf.textField.text=day;
            }else{
                ws.cardValidityEndTxf.textField.text=day;
            }
        };
        [AppKeyWindow addSubview:_datePicker];
    }
    keyboardH = 216;
    [self changePoint];
    [_datePicker showView:YES];
}


//检测能否提交
-(void)enableSubmit {
    if (_cardNumTxf.textField.text.length>0 && _cardNameTxf.textField.text.length>0 && _cardSexTxf.textField.text.length>0 && _cardValidityStartTxf.textField.text.length>0 && _cardValidityEndTxf.textField.text.length>0 ) {
        _submitBtn.enabled=YES;
        [_submitBtn setBackgroundColor:BlueFont];
        [_submitBtn setTitleColor:LTWhiteColor forState:UIControlStateNormal];
    }else{
        _submitBtn.enabled=NO;
        [_submitBtn setBackgroundColor:LTGrayBtnBGColor];
        [_submitBtn setTitleColor:LTSubTitleColor forState:UIControlStateNormal];
    }
}

//提交按钮事件
-(void)submitAction {
    WS(ws);
    [LTAlertView alertTitle:nil message:@"提交前请确保是本人信息且真实无误，以免影响出金" sureTitle:@"确认提交" sureAction:^{
        [ws reqSubmit];
    } cancelTitle:@"取消提交"];
}
//跳转结果页
-(void)pushResultVC{
    CertificationResultVC *result=[[CertificationResultVC alloc]init];
    [self.navigationController pushViewController:result animated:YES];
}
//查看开户协议
- (void)protocolAction {
    NSString *url = URL_RealNameAgreement;
    [self pushWeb:url title:@"开户协议"];
}
-(void)addNotification{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark - request

-(void)reqSubmit{
    NSDictionary *dic = @{
                          @"userId":UD_UserId,
                          @"token":UD_Token,
                          @"name":_cardNameTxf.textField.text,
                          @"idNo":_cardNumTxf.textField.text,
                          @"sex":_cardSexTxf.textField.text,
                          @"expiresStart":_cardValidityStartTxf.textField.text,
                          @"expiresEnd":_cardValidityEndTxf.textField.text,
                          };
    WS(ws);
    [RequestCenter reqEXAuthSubmitWithParameter:dic finsh:^(LTResponse *res) {
        if (res.success) {
            UD_SetCardDistStatus(3);
            NSLog(@"提交成功 %ld",UD_CardDistStatus);
            //跳转验证结果页
            [ws pushResultVC];
        }
    }];
}
-(void)reqCardDist:(BOOL) isfront file:(NSString *)file img:(UIImage *)img{
    WS(ws);
    [ws showLoadingView];
    if (isfront) {
        [RequestCenter reqEXIDCardFrontDistWithFile:file finsh:^(LTResponse *res) {
            [ws hideLoadingView];
            if (res.success) {
                NSDictionary *data=res.data;
                if (data.allKeys.count>0) {
                    NSString *idNo=[data stringFoKey:@"idNo"];
                    NSString *name=[data stringFoKey:@"name"];
                    NSString *sex=[data stringFoKey:@"sex"];
                    if (!emptyStr(idNo)) {
                        ws.cardNumTxf.textField.text=idNo;
                    }
                    if (!emptyStr(name)) {
                        ws.cardNameTxf.textField.text=name;
                    }
                    if (!emptyStr(sex)) {
                        ws.cardSexTxf.textField.text=sex;
                    }
                    [ws.cardFront configStatus:YES image:img];
                    [ws showCardFrontMsgV];
                }
                NSLog(@"正面成功");
            }else{
                NSLog(@"正面失败");
                [ws.cardFront configStatus:NO image:nil];
                [ws.view showTip:res.message];
            }
        }];
    }else{
        [RequestCenter reqEXIDCardBackDistWithFile:file finsh:^(LTResponse *res) {
            [ws hideLoadingView];
            if (res.success) {
                NSLog(@"反面成功");
                NSDictionary *data=res.data;
                if (data.allKeys.count>0) {
                    NSString *expirationStart=[data stringFoKey:@"expirationStart"];
                    NSString *expirationEnd=[data stringFoKey:@"expirationEnd"];
                    if (!emptyStr(expirationStart)) {
                        ws.cardValidityStartTxf.textField.text=expirationStart;
                    }
                    if (!emptyStr(expirationEnd)) {
                        ws.cardValidityEndTxf.textField.text=expirationEnd;
                    }
                    [ws.cardSide configStatus:YES image:img];
                    [self showCardSideMsgV];
                }
            }else{
                NSLog(@"反面失败");
                [ws.cardSide configStatus:NO image:nil];
                [ws.view showTip:res.message];
            }
        }];
    }
}
#pragma mark - delegate
#pragma mark - imagePicker delegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [_picker dismissViewControllerAnimated:YES completion:nil];
}

#define maxImgSizeByte  307200
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    //将图片存入本地沙盒
    NSString *cardStr = [NSString stringWithFormat:@"Card_%i",_isFront];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_Image.jpg",cardStr]];   //根据用户名 保存文件的名称
//    图片不可超过307200字节
    CGSize size = CGSizeMake(640, 960);
    UIImage *img = [image scaleToSize:size];
    NSData *data = UIImageJPEGRepresentation(img,0.1);//
    [data writeToFile:filePath atomically:YES];
    [_picker dismissVC];
    [self reqCardDist:_isFront file:filePath img:img];

}


//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification {
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardH = keyboardRect.size.height;
    [self changePoint];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    keyboardH=0;
}
-(void)changePoint {
    // 1.计算键盘的y screenH - keyboardH；
    CGFloat keyboardY = ScreenH_Lit - keyboardH;
    
    // 2.计算textfile在屏幕中的位置
    CGRect rect=[LTUtils viewFrameInWindow:_curTxf];
    CGFloat textFieldY=rect.origin.y+rect.size.height+10;//textfile要完全显示
    // 3.比较计算偏移量
    if (textFieldY>keyboardY) {
        CGFloat subY=textFieldY-keyboardY;
        CGPoint offset = _scroll.contentOffset;
        offset.y += subY;
        _scroll.contentOffset=offset;
    }

}
#pragma mark - textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    _curTxf=textField;
}
//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (_scroll.contentOffset.y+_scroll.h_>_scroll.contentSize.height) {
        CGPoint offset = _scroll.contentOffset;
        offset.y=_scroll.contentSize.height-_scroll.h_;
        _scroll.contentOffset=offset;
    }
}
//注意 在这个方法里 Y值为64  是因为我的视图中有NavigationBar 如果你的没有 可以为0
-(void)textViewDidEndEditing:(UITextView *)textView {
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _curTxf=textField;
    return NO;
//    if (textField==_cardSexTxf.textField) {
//        [self showSex];
//        return NO;
//    }else if (textField==_cardValidityEndTxf.textField){//失效期
//        _isValidity=NO;
//        [self showDatePicker];
//        return NO;
//    }else if (textField==_cardValidityStartTxf.textField){//有效期
//        _isValidity=YES;
//        [self showDatePicker];
//        return NO;
//    }
//    return YES;
}
//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - utils
-(UIView *)createViewWithF:(CGRect)frame{
    UIView *v=[[UIView alloc]init];
    v.frame=frame;
    v.backgroundColor=LTClearColor;
    return v;
}
-(UIButton *)createBtnWithF:(CGRect)frame title:(NSString *)title fsize:(CGFloat)fsize{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:fsize];
    return btn;
}
-(UILabel *)createLabWithF:(CGRect)frame text:(NSString *)text fsize:(CGFloat)fsize{
    UILabel *label=[[UILabel alloc]init];
    label.frame=frame;
    label.backgroundColor=[UIColor clearColor];
    label.text=text;
    label.textAlignment=NSTextAlignmentCenter;
    label.numberOfLines=0;
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:fsize];
    return label;
}
-(UIImageView *)createImgViewWithF:(CGRect)frame imgName:(NSString *)image{
    UIImageView *imgv=[[UIImageView alloc]initWithImage:[UIImage imageNamed:image]];
    imgv.frame=frame;
    return imgv;
}
-(LabelTextFiled *)createTxfWithF:(CGRect)frame minLeftW:(CGFloat)leftW leftTxt:(NSString *)leftTxt {
    LabelTextFiled *txf=[[LabelTextFiled alloc]initWithFrame:frame leftTxt:leftTxt];
    txf.minLabW=leftW;
    WS(ws);
    txf.edit = ^{
        [ws enableSubmit];
    };
    txf.textField.delegate=self;

    return txf;
}
@end
