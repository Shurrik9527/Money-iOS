//
//  SelfStock.h
//  FMStock
//
//  Created by dangfm on 15/5/2.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SelfStock : NSManagedObject

@property (nonatomic, retain) NSNumber * addtime;
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * guid;
@property (nonatomic, copy) NSString * in_price;
@property (nonatomic, retain) NSNumber * istop;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * out_price;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * change;
@property (nonatomic, copy) NSString * changerate;
@property (nonatomic, copy) NSString * excode;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, copy) NSString * last_price;
@property (nonatomic, copy) NSString * lastclose_price;
@end
