//
//  BindCardCell.h
//  Canary
//
//  Created by litong on 2017/6/2.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBindCardCellH  44

#define key_BCC_Title                 @"key_BCC_Title"
#define key_BCC_Holder             @"key_BCC_Holder"
#define key_BCC_Next                @"key_BCC_Next"


@interface BindCardCell : UITableViewCell

- (void)bindData:(NSDictionary *)dict;
- (void)changeField:(NSString *)text;
- (NSString *)fieldString;

@end
