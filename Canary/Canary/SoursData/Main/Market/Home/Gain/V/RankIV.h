//
//  RankIV.h
//  ixit
//
//  Created by litong on 2016/11/21.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>


/** 盈利列表 前3名Cell中 徽章图片 */
@interface RankIV : UIImageView

@property (nonatomic,copy) NSString *imgUrlStr;
@property (nonatomic,assign) NSInteger ranking;

@end
