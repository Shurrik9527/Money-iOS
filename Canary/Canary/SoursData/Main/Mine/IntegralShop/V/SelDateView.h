//
//  SelDateView.h
//  ixit
//
//  Created by litong on 2016/12/20.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^SelDateViewShowBlock)(BOOL show);
typedef void(^SelDateBlock)(NSString *ym);

/** 选日期 */
@interface SelDateView : UIView

@property (nonatomic,copy) SelDateViewShowBlock selDateViewShowBlock;
@property (nonatomic,copy) SelDateBlock selDateBlock;

- (instancetype)initWithFrame:(CGRect)frame ym:(NSString *)ym;
- (void)showView:(BOOL)show;

@end
