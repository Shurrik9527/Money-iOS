//
//  AttachmentsModel.m
//  Canary
//
//  Created by apple on 2018/5/14.
//  Copyright © 2018年 litong. All rights reserved.
//

#import "AttachmentsModel.h"

@implementation AttachmentsModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key  {
    if([key isEqualToString:@"id"])
        self.NewID = value;
}
@end
