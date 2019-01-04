//
//  LiveQuotationView.h
//  ixit
//
//  Created by litong on 2017/4/11.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>


/** V2视频下方  行情价格波动横条 */
@interface LiveQuotationView : UIView

//http请求，重新创建lab
@property (nonatomic,strong) NSArray *pList;

//长连接行情，刷新油、银价格
- (void)refQuotation:(NSArray *)list;

@end
