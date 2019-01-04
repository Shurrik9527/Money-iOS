//
//  NewsBaseCell.h
//  ixit
//
//  Created by litong on 2016/11/10.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"

static CGFloat titleFontSize = 12.f;
static CGFloat kNewsTempLineH = 4.f;

#define kNewsBlackColor  LTColorHex(0x373637)
#define kNewsGrayColor  LTSubTitleColor
#define kNewsGrayBgColor  LTBgColor

/** 首页新闻cell */
@interface NewsBaseCell : UITableViewCell

- (void)bindData:(NewsModel *)model;
- (void)addTopLine;

+ (NSAttributedString *)ABStr:(NSString *)title content:(NSString *)content;
+ (CGSize)ABStrH:(NSString *)title content:(NSString *)content;

+ (CGFloat)contectLabW;

+ (CGFloat)cellHWithContent:(NewsModel *)mo;

@end
