//
//  dataModel.h
//  CBSegment
//
//  Created by minrui on 2018/4/10.
//  Copyright © 2018年 com.bingo.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dataModel : NSObject

@property (nonatomic, copy)NSString *name;
@property (nonatomic, strong)NSArray *grades;
@property (nonatomic, strong)NSArray *subjects;
@property (nonatomic, copy)NSString *firstID;

@end
