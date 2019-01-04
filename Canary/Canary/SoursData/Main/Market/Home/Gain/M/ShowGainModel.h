//
//  ShowGainModel.h
//  ixit
//
//  Created by litong on 2016/11/14.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "BaseMO.h"

@interface ShowGainModel : BaseMO

/** 头像数组，最新嗮单用户头像 */
@property (nonatomic,strong) NSArray *avatars;//
/** 是否休市，2=休市，1=没有休市 */
@property (nonatomic,assign) NSInteger isClose;//1;
/** 当前用户头像 */
@property (nonatomic,strong) NSString *myAvatar;//"http:m.8caopan.com/images/avatar/3/0/70/345/20160915161036543.jpg";
/** 当前用户排名，0=没有排名 */
@property (nonatomic,assign) NSInteger myRanking;//0;
/** 嗮单人数 */
@property (nonatomic,assign) NSInteger showOrderNum;//0;



//avatars =         (
//);
//isClose = 1;
//myAvatar = "http://m.8caopan.com/images/avatar/3/0/70/345/20160915161036543.jpg";
//myRanking = 0;
//showOrderNum = 0;


@end
