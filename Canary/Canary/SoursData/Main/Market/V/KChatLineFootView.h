//
//  KChatLineFootView.h
//  ixit
//
//  Created by litong on 2017/2/21.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, KChatLineFootViewType) {
    KChatLineFootViewType_GoDeal,//前往交易大厅
    KChatLineFootViewType_Buy,//买涨、买跌
    KChatLineFootViewType_BuyAndClose,//买涨、买跌、平仓
};

typedef void (^KChatLineFootViewBlock)(NSString *txt);

@interface KChatLineFootView : UIView

@property (nonatomic,assign) KChatLineFootViewType viewTyp;
@property (nonatomic,copy) KChatLineFootViewBlock kChatLineFootViewBlock;

//@"平仓"、@"暂无持仓"、@"查看持仓"
- (void)changeThirdBtnWithText:(NSString *)txt;

@end
