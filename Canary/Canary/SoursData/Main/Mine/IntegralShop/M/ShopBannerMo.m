//
//  ShopBannerMo.m
//  ixit
//
//  Created by litong on 2017/1/13.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "ShopBannerMo.h"

@implementation ShopBannerMo



+ (ShopBannerMo *)testMo {
    ShopBannerMo *mo = [ShopBannerMo new];
    mo.image_url = @"http://m.8caopan.com/images/appContent/list/0/2/570/20170109103735620.png";
    mo.url = @"http://www.8caopan.com/a/20170109ril/";
    mo.title = @"ceshi";
    return mo;
}

@end
