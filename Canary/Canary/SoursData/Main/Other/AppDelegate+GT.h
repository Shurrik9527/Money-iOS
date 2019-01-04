//
//  AppDelegate+GT.h
//  Canary
//
//  Created by Brain on 2017/6/3.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (GT)<GeTuiSdkDelegate>
-(void)configGT;
-(void)alertWarmingSheet:(NSDictionary *)data;
-(void)withdrawAlert:(NSDictionary *)data;
@end
