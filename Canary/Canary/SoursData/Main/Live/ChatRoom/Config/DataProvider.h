//
//  DataProvider.h
//  DemoApplication
//
//  Created by chris on 15/10/7.
//  Copyright © 2015年 chris. All rights reserved.
//

//#import "NIMKit.h"
#import <NIMSDK/NIMSDK.h>

#import <Foundation/Foundation.h>
@interface DataProvider : NSObject

@property (nonatomic, strong) NSString *roomId;
@property (nonatomic, strong) NSArray *members;

@end
