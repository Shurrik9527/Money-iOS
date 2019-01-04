//
//  ShopBannerMo.h
//  ixit
//
//  Created by litong on 2017/1/13.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BaseMO.h"

@interface ShopBannerMo : BaseMO

@property (nonatomic,strong) NSString *image_url;//图片URL
@property (nonatomic,strong) NSString *title;//点击跳转网页的title
@property (nonatomic,strong) NSString *url;//点击跳转网页的url

+ (ShopBannerMo *)testMo;

@end
