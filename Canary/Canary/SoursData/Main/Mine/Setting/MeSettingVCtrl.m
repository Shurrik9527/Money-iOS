//
//  MeSettingVCtrl.m
//  ixit
//
//  Created by litong on 2016/12/22.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "MeSettingVCtrl.h"
#import "MeSetView.h"
#import "ModifyFw.h"
//#import "UserExchange.h"
//#import "EXLoginOrRegVCtrl.h"
//#import "ExPwdOneStepVCtrl.h"
//#import "ForgetPasswordViewController.h"
//#import "EXForgetPwdVCtrl.h"

#import "ChangeNicknameVCtrl.h"
#import "LTAlertSheetView.h"


#import <AVFoundation/AVBase.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#import "ForgetPwdCtrl.h"

#define btmViewH    77
#define tempLineH   8
#define EXchangeNames    @[@"",@"广贵",@"哈贵",@"农交"]

@interface MeSettingVCtrl ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    CGFloat view3Y;
}
@property (nonatomic,strong) UIScrollView *scView;

@property(assign,nonatomic)BOOL imgUpdating;
@property (nonatomic,strong) LTAlertSheetView *popViewChangeHeadIV;
@property (nonatomic,strong) MeSetView *headView;
@property (nonatomic,strong) MeSetView *nickeNameView;

@property (nonatomic,strong) UIView *btmView;
@property (nonatomic,strong) NSArray *exs;//老用户注册过的交易所
//@property (nonatomic,strong) UserExchange *userExchangeObj;

@property (nonatomic,strong) LTAlertSheetView *popViewChangePwd;

@property (nonatomic,strong)UIImagePickerController *imagePicker;

@end

@implementation MeSettingVCtrl

- (instancetype)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = LTBgRGB;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navPopBackTitle:@"账户设置"];
    [self createScrollView];
    [self createBtmView];
    [self configImagePicker];
    
//    if ([LTUser useUnifyPwd]) {
//        [self useUnifyPwdCell];
//    } else {
//        [self reqCheckIsBind];
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    NSString *nickName = UD_NickName;
    if ([nickName is_PhoneNumber]) {
        nickName = [LTUtils phoneNumMid4Star];
    }
    [self.nickeNameView configSubText:nickName];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action

#pragma mark 退出登录

- (void)logoutAction {
    WS(ws);
    [LTAlertView alertWithTitle:@"确定退出该用户?" sureAction:^{
        // 确定退出
        [LTUser logout];
        
        
        [ws popVC];
        [[NSNotificationCenter defaultCenter] postNotificationName:NFC_LocLogout object:nil userInfo:nil];
        [ws.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark 检查是否注册交易所，是否合并密码

- (void)reqCheckIsBind {
//    WS(ws);
//    
//    [RequestCenter reqEXCheckIsBind:^(LTResponse *res) {
//        if (res.success) {
//            UserExchange *obj = [UserExchange objWithDict:res.resDict];
//            ws.userExchangeObj = obj;
//            [ws configData];
//        } else {
//            [ws.view showTip:res.message];
//        }
//    }];
}

- (void)configData {
//    BOOL useUnifyPwd = _userExchangeObj.bind;//使用唯一密码
//    BOOL oldExUser = NO;//新老用户：老（注册过交易所）
//    NSMutableArray *arr = [NSMutableArray array];
//    for (UserEx *mo in _userExchangeObj.exchanges) {
//        if (mo.reg) {
//            oldExUser = YES;
//            NSInteger eid = [mo.exchangeId integerValue];
//            [LTUser saveRegisterEX:eid];
//            [arr addObject:@(eid)];
//        }
//    }
//    self.exs = [NSArray arrayWithArray:arr];
//    
//    [LTUser setOldExUser:oldExUser];
//    [LTUser saveUseUnifyPwd:useUnifyPwd];
//    
//    if (useUnifyPwd) {
//        [self useUnifyPwdCell];
//        return;
//    } else {
//        if (oldExUser) {
//            [self oldUserCell];
//        } else {
//            [self newUserCell];
//        }
//    }
    
}

/**
1、设置交易密码
未设置任何交易所密码，且没设置统一密码，点击跳转 设置统一密码
 */
- (void)newUserCell {
//    WS(ws);
//    MeSetView *msView = [[MeSetView alloc] initTitle:@"设置交易密码" y:view3Y +LTAutoW(tempLineH) type:MeSetType_ChangePwd];
//    [_scView addSubview:msView];
//    msView.meSetViewBlock = ^{
//        EXLoginOrRegVCtrl *ctrl = [[EXLoginOrRegVCtrl alloc] init];
//        ctrl.loginType = EXLoginType_UnifyReg;
//        ctrl.loginSuccess = ^{
//            [ws popToRootVC];
//        };
//        [ws pushVC:ctrl];
//    };
//    
//    [self setScViewH:msView.top_];
}

 /**
2、修改交易密码
设置过统一密码，点击跳转 修改统一密码
  */
- (void)useUnifyPwdCell {
//    WS(ws);
//    MeSetView *msView = [[MeSetView alloc] initTitle:@"修改交易密码" y:view3Y +LTAutoW(tempLineH) type:MeSetType_ChangePwd];
//    [_scView addSubview:msView];
//    msView.meSetViewBlock = ^{
//        ForgetPasswordViewController *ctrl = [[ForgetPasswordViewController alloc] init];
//        ctrl.useUnifyPwd = YES;
//        ctrl.titleStr = @"重置交易密码";
//        [ws pushVC:ctrl];
//    };
//    
//    [self setScViewH:msView.top_];
}

 /**
3、统一交易密码  &  修改交易密码     已设置xxx交易所密码
设置过部分或全部交易所密码，但未统一过交易密码
  */

- (void)oldUserCell {
//    WS(ws);
//    MeSetView *msView = [[MeSetView alloc] initTitle:@"统一交易密码" y:view3Y +LTAutoW(tempLineH) type:MeSetType_ChangePwd];
//    [_scView addSubview:msView];
//    msView.meSetViewBlock = ^{
//        ExPwdOneStepVCtrl *ctrl = [[ExPwdOneStepVCtrl alloc] initWithObj:ws.userExchangeObj];
//        [ws pushVC:ctrl];
//    };
//    
//    
//    [self createPopViewChangePwd];
//
//    MeSetView *msView1 = [[MeSetView alloc] initTitle:@"修改交易密码" y:msView.yh_ type:MeSetType_ChangePwd1];
//    NSString *subText = [self hasRegEXName];
//    [msView1 configSubText:subText];
//    [_scView addSubview:msView1];
//    msView1.meSetViewBlock = ^{
//        [ws.popViewChangePwd showView:YES];
//    };
//    
//    [self setScViewH:msView1.top_];
}



#pragma mark - UI

- (void)createScrollView {
    
    _scView = [[UIScrollView alloc] init];
    _scView.frame = CGRectMake(0, NavBarTop_Lit, ScreenW_Lit, ScreenH_Lit - NavBarTop_Lit - LTAutoW(btmViewH));
    _scView.showsHorizontalScrollIndicator = NO;
    _scView.backgroundColor = LTBgRGB;
    [self.view addSubview:_scView];
    
    [self addNorCell];
}



- (void)createBtmView {
    self.btmView = [[UIView alloc] init];
    _btmView.frame = CGRectMake(0, ScreenH_Lit - LTAutoW(btmViewH), ScreenW_Lit, LTAutoW(btmViewH));
    [self.view addSubview:_btmView];
    
    CGFloat logoutBtnH = LTAutoW(45);
    UIButton *logoutBtn = [UIButton btnWithTarget:self action:@selector(logoutAction) frame:CGRectMake(LTAutoW(kLeftMar), (LTAutoW(btmViewH)-logoutBtnH)*0.5, _btmView.w_ - 2*LTAutoW(kLeftMar), logoutBtnH)];
    [logoutBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:LTKLineRed forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = autoFontSiz(17);
    logoutBtn.backgroundColor = LTWhiteColor;
    [_btmView addSubview:logoutBtn];
    
}

//上部分 不变的cell
- (void)addNorCell {
    WS(ws);
    
    self.headView = [[MeSetView alloc] initTitle:@"头像" y:0 type:MeSetType_Head];
    [_headView configHeadImg:UD_Avatar];
    [_scView addSubview:_headView];
    _headView.meSetViewBlock = ^{
        [ws.popViewChangeHeadIV showView:YES];
    };
    
    self.nickeNameView = [[MeSetView alloc] initTitle:@"昵称" y:_headView.yh_+LTAutoW(tempLineH) type:MeSetType_NickName];
    [_scView addSubview:_nickeNameView];
    _nickeNameView.meSetViewBlock = ^{
        ChangeNicknameVCtrl *ctrl = [[ChangeNicknameVCtrl alloc] init];
        [ws pushVC:ctrl];
    };
    
    MeSetView *view2 = [[MeSetView alloc] initTitle:@"当前帐户" y:_nickeNameView.yh_ type:MeSetType_UserName];
    [view2 configSubText:[LTUtils phoneNumMid4Star]];
    [_scView addSubview:view2];
    
    MeSetView *view3 = [[MeSetView alloc] initTitle:@"修改密码" y:view2.yh_ type:MeSetType_ChangePwd];
    [_scView addSubview:view3];
    view3.meSetViewBlock = ^{
        ModifyFw * modify =[[ModifyFw alloc]init];
        [ws pushVC:modify];
    };

}


- (void)createPopViewChangePwd {
    CGRect rect = CGRectMake(0, NavBarTop_Lit, ScreenW_Lit, ScreenH_Lit - NavBarTop_Lit);
    self.popViewChangePwd = [[LTAlertSheetView alloc] initWithFrame:rect];
    [self.view addSubview:_popViewChangePwd];
    NSMutableArray *exns = [NSMutableArray array];
    for (NSNumber *eid in _exs) {
        [exns addObject:EXchangeNames[[eid integerValue]]];
    }
    
//    [_popViewChangePwd configContentView:nil mos:exns];
    [_popViewChangePwd configContentView:@"修改交易密码" mos:exns];
    
//    WS(ws);
//    _popViewChangePwd.alertSheetBlock = ^(NSInteger idx){
//        ExchangeType exType = [ws.exs[idx] integerValue];
//        ForgetPasswordViewController *ctrl = [[ForgetPasswordViewController alloc] init];
//        ctrl.type = exType;
//        NSString *exName = EXchangeNameList[exType];
//        ctrl.titleStr = [NSString stringWithFormat:@"重置%@交易密码",exName];
//        [ws pushVC:ctrl];
//    };
    
}

#pragma mark - Utils



- (NSString *)hasRegEXName {
    NSMutableString *exNames = [[NSMutableString alloc] init];
    NSInteger i = 0;
    NSInteger exsCount = _exs.count;
    for (NSNumber *eid in self.exs) {
        NSString *eName = EXchangeNames[[eid integerValue]];
        if (i == exsCount-1) {
            [exNames appendString:eName];
        } else {
            [exNames appendFormat:@"%@ | ",eName];
        }
        
        i ++;
    }
    
    NSString *subText = [NSString stringWithFormat:@"已设置%@所交易密码",exNames];
    return subText;
}

- (void)setScViewH:(CGFloat)h {
    _scView.contentSize = CGSizeMake(_scView.w_, h);
}


#pragma mark - 换头像

- (void)configImagePicker {
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    
     CGRect rect = CGRectMake(0, NavBarTop_Lit, ScreenW_Lit, ScreenH_Lit - NavBarTop_Lit);
    self.popViewChangeHeadIV = [[LTAlertSheetView alloc] initWithFrame:rect];
    [self.view addSubview:_popViewChangeHeadIV];
    [_popViewChangeHeadIV configContentView:@"设置头像" mos:@[@"拍照",@"相册"]];
    WS(ws);
    _popViewChangeHeadIV.alertSheetBlock = ^(NSInteger idx){
        if (idx == 0) {
            [ws cremaAction];
        } else {
            [ws pictureAction];
        }
    };
}

- (BOOL)canUseCamera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [LTAlertView alertMessage:@"检测不到相机设备"];
        return NO;
    }
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authStatus == AVAuthorizationStatusRestricted ||
        authStatus == AVAuthorizationStatusDenied) {
        [LTAlertView alertMessage:@"相机权限受限"];
        return NO;
    }
    return YES;
}

#pragma mark 相机

- (void)cremaAction {
    if (![self canUseCamera]) {
        return;
    }
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:_imagePicker animated:YES completion:nil];
}

#pragma mark  相册

- (void)pictureAction {
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:_imagePicker animated:YES completion:nil];
}

#pragma mark  imagePickerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [_imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    //将图片存入本地沙盒
    NSString *nameStr = UD_UserId;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@HeadImage.jpg",nameStr]];   //根据用户名 保存文件的名称
    NSData *data = UIImageJPEGRepresentation(image,0.1);//
    [data writeToFile:filePath atomically:YES];
    
    UIImage *img = [image cutedCenterSquare];
    [_headView configHeadImg:img];
    
    [self updateImage:img filePath:filePath];
}

#pragma mark  上传照片

- (void)updateImage:(UIImage *)image filePath:(NSString *)path {
    if (_imgUpdating) {
        return;
    }
    _imgUpdating=YES;
    WS(ws);
    [_imagePicker dismissViewControllerAnimated:YES completion:nil];
    
    [self showLoadingWithMsg:@"上传头像..."];
    [RequestCenter reqChangeHeadImage:path finsh:^(LTResponse *res) {
        [ws hideLoadingView];
        ws.imgUpdating = NO;
        if(res.success) {
            NSString *imgUrl = [res.rawDict stringFoKey:@"data"];
            [self networkUserEdit:imgUrl];
        } else {
//            [LTAlertView alertMessage:@"您的头像修改失败，请重新修改"];
            [ws.view showTip:res.message];
        }
    }];
    
}

- (void)networkUserEdit:(NSString *)userImg{
    
    NSMutableDictionary *dic = [@{
                                  @"userImg":userImg
                                  } mutableCopy];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,@"/user/edit"];
    
    [[NetworkRequests sharedInstance] SWDPOST:url dict:dic succeed:^(id resonseObj, BOOL isSuccess, NSString *message) {
        NSLog(@"res == %@",resonseObj);

        if (isSuccess){
            UD_SetAvatar(userImg);
            [[NSNotificationCenter defaultCenter] postNotificationName:NFC_ChangeHeadImgSuccess object:nil];
            [LTAlertView alertMessage:@"恭喜您的头像修改成功"];
        }else{
            NSLog(@"error === %@",message);
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error === %@",error);
        
        
    }];
    
}


@end
