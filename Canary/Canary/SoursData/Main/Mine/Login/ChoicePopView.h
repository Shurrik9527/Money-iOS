//
//  ChoicePopView.h
//  Canary
//
//  Created by apple on 2018/4/15.
//  Copyright © 2018年 litong. All rights reserved.
//

#import "BasePopView.h"
typedef void(^CallBackBlcok) (NSString *type ,NSString*mt4id);
typedef void(^TypeBlcok) (NSString *type);

@interface ChoicePopView : BasePopView

#define kBuyViewH  150
@property (nonatomic,strong)NSMutableArray * dataAray;
@property (nonatomic,copy)CallBackBlcok callBackBlock;
@property (nonatomic,copy)TypeBlcok typeblock;
@property (nonatomic,copy)NSString * a;
@end
