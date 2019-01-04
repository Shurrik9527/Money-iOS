//
//  MeSetView.h
//  ixit
//
//  Created by litong on 2016/12/22.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MeSetType) {
    MeSetType_Normal,
    MeSetType_Head,
    MeSetType_NickName,
    MeSetType_UserName,
    MeSetType_ChangePwd,
    MeSetType_ChangePwd1,
};

#define MeSetViewHeadH  88
#define MeSetViewH  45

typedef void(^MeSetViewBlock)();

@interface MeSetView : UIView

@property (nonatomic,copy) MeSetViewBlock meSetViewBlock;


- (instancetype)initTitle:(NSString *)title y:(CGFloat)y;
- (instancetype)initTitle:(NSString *)title y:(CGFloat)y type:(MeSetType)msType;

- (void)configTitleText:(NSString *)text;
- (void)configSubText:(NSString *)text;
- (void)configHeadImg:(id)img;

@end
