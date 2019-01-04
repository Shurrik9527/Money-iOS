//
//  KLineTianjiNavView.h
//  golden_iphone
//
//  Created by dangfm on 15/7/8.
//  Copyright (c) 2015年 golden. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kLineTianjiNavView_Font fontSiz(14)
#define kLineTianjiNavView_TimeFont     fontSiz(smallFontSize)
#define kLineTianjiNavView_TextColor LTHEX(0x343c48)
#define kLineTianjiNavView_DefaulHighlightsIndex 100

typedef void (^clickTianjiNavViewButtonBlock)(NSInteger tag);

@interface KLineTianjiNavView : UIView
@property (nonatomic,retain) UILabel *time;
@property (nonatomic,assign) int buttonTag;
@property (nonatomic,copy) clickTianjiNavViewButtonBlock clickTianjiNavViewButtonBlock;

@end
