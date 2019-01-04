//
//  SelTypeView.h
//  ixit
//
//  Created by litong on 2016/12/21.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^SelTypeViewShowBlock)(BOOL show);
typedef void(^SelTypeBlock)(NSString *typeStr,NSInteger row);

/** 选类型 */
@interface SelTypeView : UIView

@property (nonatomic,copy) SelTypeViewShowBlock selTypeViewShowBlock;
@property (nonatomic,copy) SelTypeBlock selTypeBlock;

- (instancetype)initWithFrame:(CGRect)frame selRow:(NSInteger)selRow typeList:(NSArray *)typeList;
- (void)showView:(BOOL)show;

@end
