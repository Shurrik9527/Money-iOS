//
//  SelectOptionalColumn.h
//  golden_iphone
//
//  Created by dangfm on 15/7/1.
//  Copyright (c) 2015年 golden. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSelectOptionColumn_vertical 4
#define kSelectOptionColumn_padding 16
#define kSelectOptionColumn_padding_between 13

#define kSelectOptionColumn_Width (Screen_width-2*kSelectOptionColumn_padding-(3)*kSelectOptionColumn_padding_between)/kSelectOptionColumn_vertical
#define kSelectOptionColumn_height 36

typedef enum {
    select_moveLeft,
    select_moveRight
} SelectMoveDirection;

@class SelectOptionalColumn;
typedef void (^touchActionBlock)(SelectOptionalColumn* col);
typedef void (^touchMoveEndBlock)(SelectOptionalColumn* col);
@interface SelectOptionalColumn : UIButton
@property (nonatomic,retain) UILabel *titleLb;
@property (nonatomic,copy) touchActionBlock touchActionBlock;
@property (nonatomic,copy) touchMoveEndBlock touchMoveEndBlock;
@property (nonatomic,assign) BOOL isTouchMove;
-(instancetype)initWithFrame:(CGRect)frame Datas:(NSMutableArray*)datas;
@end
