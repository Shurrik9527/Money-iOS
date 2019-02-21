//
//  MeSectionView.h
//  ixit
//
//  Created by litong on 2016/12/9.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMeSectionViewH         88

typedef NS_ENUM(NSUInteger, MeSectionType) {
    MeSectionType_Logout,//没登录
    MeSectionType_NotAuth,//已登录，未认证 或 未认证成功
    MeSectionType_Authed,//已登录，已认证成功
};

typedef void(^MeSectionBlock)(NSInteger idx);

@interface MeSectionView : UIView

@property (nonatomic,strong) MeSectionBlock meSectionBlock;

- (void)configType:(MeSectionType)type;

@end
