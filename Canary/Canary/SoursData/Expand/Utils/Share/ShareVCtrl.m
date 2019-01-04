//
//  ShareVCtrl.m
//  Canary
//
//  Created by litong on 2017/5/16.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "ShareVCtrl.h"

@interface ShareVCtrl ()

@property (nonatomic,strong) NSString *imgUrl;

@property (nonatomic,strong) UIScrollView *scView;

@property(copy,nonatomic)NSString * shareUrl;
@property(copy,nonatomic)NSString * content;

@end

@implementation ShareVCtrl


- (instancetype)init {
    return [self initWithBackType:BackType_PopVC imgUrl:nil];
}
- (instancetype)initWithBackType:(BackType)backType {
    return [self initWithBackType:backType imgUrl:nil];
}
- (instancetype)initWithBackType:(BackType)backType imgUrl:(NSString *)imgUrl {
    self = [super init];
    if (self) {
        self.backType = backType;
        self.imgUrl = imgUrl;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navTitle:@"分享" backType:self.backType];
    [self creareView];
}

- (void)creareView {
    
}

@end
