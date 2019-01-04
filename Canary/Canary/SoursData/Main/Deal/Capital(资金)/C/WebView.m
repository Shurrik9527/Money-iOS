//
//  WebView.m
//  Canary
//
//  Created by apple on 2018/4/18.
//  Copyright © 2018年 litong. All rights reserved.
//

#import "WebView.h"
#import "DataHundel.h"
#import "AFNetworking.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "LTAlertSheetView.h"
@interface WebView ()<UIWebViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong) NSString * urlString;
@property(nonatomic,strong)UIImagePickerController *imagePicker;
@property (nonatomic,strong) JSContext *jsContext;
@property (nonatomic,copy)NSString * photoType;//身份证正反
@property (nonatomic,copy)NSDictionary * dic;
@property (nonatomic,strong) LTAlertSheetView *popViewChangeHeadIV;
@property(nonatomic,strong) UIProgressView * myProgressView;


@end

@implementation WebView

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.state == 1) {
        [self navTitle:@"充值" backType:BackType_Dismiss];
    }else
    {
        [self navTitle:@"完善信息" backType:BackType_Dismiss];
    }
    if (self.state == 1) {
        NSString * timeStr =[LTUtils getNowTimeString];
        long timer =[DataHundel getZiFuChuan:timeStr];
        NSNumber *longNumber = [NSNumber numberWithLong:timer];
        _urlString =[NSString stringWithFormat:@"%@%@%@%@%@%@",@"http://uc.moyacs.com/my.account-deposit.funds_app_v2.html?v=",[longNumber stringValue],@"&mt4id=",[NSUserDefaults objFoKey:MT4ID],@"&token=",[NSUserDefaults objFoKey:kToken]];
    }else
    {
        _urlString =[NSString stringWithFormat:@"%@%@",@"http://uc.moyacs.com/real_app_v2.html?token=",[NSUserDefaults objFoKey:kToken]];
    }
    UIWebView* webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height - 64)];
    webView.delegate = self;
    for (id subview in webView.subviews)
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
        {
            ((UIScrollView *)subview).bounces = NO;
        }
    NSURL *url = [NSURL URLWithString:_urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    [self showLoadingView];
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (self.state ==1) {
        NSString* reqUrl = request.URL.absoluteString;
        if ([reqUrl hasPrefix:@"alipays://"] || [reqUrl hasPrefix:@"alipay://"]) {
            // NOTE: 跳转支付宝App
            BOOL bSucc = [[UIApplication sharedApplication]openURL:request.URL];
            // NOTE: 如果跳转失败，则跳转itune下载支付宝App
            if (!bSucc) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                               message:@"未检测到支付宝客户端，请安装后重试。"
                                                              delegate:self
                                                     cancelButtonTitle:@"立即安装"
                                                     otherButtonTitles:nil];
                [alert show];
            }
            return NO;
        }
    }else
    {
        return YES;
    }
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideLoadingView];
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext[@"tianbai"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSURL *imageUrl = [info valueForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    //根据url获取asset信息, 并通过block进行回调
    [assetsLibrary assetForURL:imageUrl resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        NSString *imageName = representation.filename;
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSString *urlString =[NSString stringWithFormat:@"%@%@",BasisUrl,@"/upload"];
        NSURL *url = [NSURL URLWithString:urlString];
        NSString * ktoken = [NSUserDefaults objFoKey:kToken];
        AFHTTPSessionManager *session = [[AFHTTPSessionManager alloc] initWithBaseURL:url sessionConfiguration:config];
        NSData *dataimage=UIImageJPEGRepresentation([UIImage imageNamed:@"test.jpg"], 0.5);
        [session.requestSerializer setValue:[NSString stringWithFormat:@"%lu",(unsigned long)dataimage.length] forHTTPHeaderField:@"Content-Length"];
        NSString * exStr = [NSString stringWithFormat:@"multipart/form-data; boundary=----%@",@"WebKitFormBoundary"] ;
        NSString * boundary = [NSString stringWithFormat:@"%@%08X%08X",exStr,arc4random(),arc4random()];
        [session.requestSerializer setValue:boundary forHTTPHeaderField:@"Content-Type"];
        session.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        [session.requestSerializer setValue:[NSString stringWithFormat:@"%@%@",@"Bearer ",ktoken]forHTTPHeaderField:@"Authorization"];
        [session POST:urlString parameters:self.dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            NSData *dataimage=UIImageJPEGRepresentation(image, 0.5);
            NSString *strUrl = [imageName stringByReplacingOccurrencesOfString:@"JPG" withString:@"jpg"];
            [formData appendPartWithFileData:dataimage name:@"file"fileName:strUrl mimeType:@"image/jpg"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",self.dic);
//            NSString * type  = [self.dic objectForKey:@"type"];
//            if ([type isEqualToString:@"ATTA01"]) {
//                [self call:responseObject];
//            }else
//            {
//                [self tokePhoto:responseObject];
//            }
                    [self call:responseObject];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    } failureBlock:^(NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
    
}
-(UIImage *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    return resultImage;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // NOTE: 跳转itune下载支付宝App
    NSString* urlStr = @"https://itunes.apple.com/cn/app/zhi-fu-bao-qian-bao-yu-e-bao/id333206289?mt=8";
    NSURL *downloadUrl = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication]openURL:downloadUrl];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)saveImageDocuments:(UIImage *)image{
    //拿到图片
    UIImage *imagesave = image;
    NSString *path_sandox = NSHomeDirectory();
    //设置一个图片的存储路径
    NSString *imagePath = [path_sandox stringByAppendingString:@"/Documents/test.png"];
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    [UIImagePNGRepresentation(imagesave) writeToFile:imagePath atomically:YES];
}
- (void)call :(NSString*)jasonStr {
    NSLog(@"%@======",jasonStr);
    // 之后在回调js的方法Callback把内容传出去
    JSValue *Callback = self.jsContext[@"Callback"];
    //传值给web端
    [Callback callWithArguments:@[jasonStr]];
}
- (void)tokePhoto :(NSString*)jasonStr{
    // 之后在回调js的方法Callback把内容传出去
    JSValue *takePhotoCallback = self.jsContext[@"takePhotoCallback"];
    //传值给web端
    [takePhotoCallback callWithArguments:@[jasonStr]];
}

- (void)getCall:(NSString *)callString{
    NSLog(@"Get:%@", callString);
    self.dic = [self parseJSONStringToNSDictionary:callString];
    // 成功回调js的方法Callback
    JSValue *Callback = self.jsContext[@"alerCallback"];
    [Callback callWithArguments:nil];
    [self creatPhoto];
}
- (void)gettakephoto:(NSString *)callString{
    self.dic = [self parseJSONStringToNSDictionary:callString];
    // 成功回调js的方法Callback
    JSValue *Callback = self.jsContext[@"alerCallback"];
    [Callback callWithArguments:nil];
    [self creatPhoto];
}
-(void)creatPhoto
{
    self.imagePicker= [[UIImagePickerController alloc] init];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.delegate = self;
    CGRect rect = CGRectMake(0, NavBarTop_Lit, ScreenW_Lit, ScreenH_Lit - NavBarTop_Lit);
    self.popViewChangeHeadIV = [[LTAlertSheetView alloc] initWithFrame:rect];
    [self.view addSubview:_popViewChangeHeadIV];
    [_popViewChangeHeadIV configContentView:@"上传身份证" mos:@[@"拍照",@"相册"]];
    WS(ws);
    _popViewChangeHeadIV.alertSheetBlock = ^(NSInteger idx){
        if (idx == 0) {
            [ws cremaAction];
        } else {
            [ws pictureAction];
        }
    };
    [self.popViewChangeHeadIV showView:YES];
}
-(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
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
-(void)pictureAction
{
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController: self.imagePicker animated:YES completion:nil];
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


@end
