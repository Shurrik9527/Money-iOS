//
//  NTESDataManager.h
//  NIM
//
//  Created by amao on 8/13/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "NTESService.h"
//#import "NIMSDK.h"
#import "NTESGlobalMacro.h"
//#import "NIMKit.h"
#import <NIMSDK/NIMSDK.h>

@interface NTESDataManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic,strong) UIImage *defaultUserAvatar;

@property (nonatomic,strong) UIImage *defaultTeamAvatar;


@end
