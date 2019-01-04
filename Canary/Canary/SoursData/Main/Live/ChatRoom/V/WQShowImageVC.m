//
//  WQShowImageVC.m
//  ixit
//
//  Created by Brain on 16/3/27.
//  Copyright © 2016年 ixit. All rights reserved.
//

#import "WQShowImageVC.h"
#import "UIImageView+WebCache.h"

@interface WQShowImageVC ()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIImageView *imageView;
@end

@implementation WQShowImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.title = _name;
    UIImage *image = [UIImage imageWithContentsOfFile:_thumbPath];
    CGFloat imgHeight = image ? Screen_width / (image.size.width * 1.0/image.size.height)*1.0:Screen_height;
    _imageView = [[UIImageView alloc]init];
    NSURL *url = [NSURL URLWithString:_imageURL];
    _imageView.frame = CGRectMake(0, 0, Screen_width, imgHeight);
    _imageView.center=self.view.center;
//    [_imageView sd_setImageWithURL:url
//                  placeholderImage:[UIImage imageWithContentsOfFile:_thumbPath]
//                           options:SDWebImageRefreshCached];
    WS(ws);
    [_imageView sd_setImageWithURL:url placeholderImage:[UIImage imageWithContentsOfFile:_thumbPath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [ws resetImgViewFrameWithImage:image];
    }];
    [self.view addSubview:_imageView];
    
    [self addDissMissGesture];
    // Do any additional setup after loading the view.
}
-(void)resetImgViewFrameWithImage:(UIImage *)image
{
    CGSize size = image.size;
    CGFloat rate = size.width*1.0/size.height;
    CGFloat w = size.width>Screen_width ? Screen_width : size.width;
    CGFloat h  = size.width>Screen_width ? Screen_width*1.0 /rate : size.height;
    h=h>Screen_height?Screen_height:h;
    _imageView.frame=CGRectMake(0, 0, w, h);
    _imageView.center = self.view.center;
}
-(void)addDissMissGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissMissAction)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    tap=nil;
}
-(void)dissMissAction
{
//    [self.view removeAllSubView];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    _imageView=nil;
    _imageURL=nil;
    _thumbPath=nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
