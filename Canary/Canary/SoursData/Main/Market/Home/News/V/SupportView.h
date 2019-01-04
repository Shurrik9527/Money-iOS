//
//  SupportView.h
//  ixit
//
//  Created by litong on 2016/11/11.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsBaseCell.h"

#define SupportViewH   36.f
static NSString *NFC_SupportNewsCell = @"NFC_SupportNewsCell";

typedef NS_ENUM(NSUInteger, SupportType) {
    SupportType_more=1,
    SupportType_less=2,
};

/** 行情预演 -- 底部支持 利多 或 利空 */
@interface SupportView : UIView

@property (nonatomic,assign) SupportType supportType;

- (void)refData:(NewsModel *)mo indexPath:(NSIndexPath *)indexPath;
- (void)refView:(NewsModel *)mo;

@end
