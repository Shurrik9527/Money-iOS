//
//  QuotationScrollView.h
//  ixit
//
//  Created by litong on 2016/11/10.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HomeRefreshHttpDatas)(void);

/** 多个产品行情 */
@interface QuotationScrollView : UIView

@property (nonatomic,copy) HomeRefreshHttpDatas homeRefreshHttpDatas;
@property (nonatomic,copy) NSMutableArray *symbolArray;

-(void)socketdata:(NSMutableArray * )array;
- (void)refDatas:(NSArray *)arr;
+ (CGFloat)viewH;

@end
