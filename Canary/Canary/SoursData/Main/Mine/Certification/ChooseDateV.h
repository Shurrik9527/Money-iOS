//
//  ChooseSexV.h
//  Canary
//
//  Created by Brain on 2017/6/8.
//  Copyright © 2017年 litong. All rights reserved.
// 选择时间view

#import "BasePopView.h"
typedef void(^dateAction)(NSString *);

@interface ChooseDateV : BasePopView
@property (nonatomic,copy) dateAction chooseDate;

@end
