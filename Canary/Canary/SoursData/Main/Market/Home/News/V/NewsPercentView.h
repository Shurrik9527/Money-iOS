//
//  NewsPercentView.h
//  ixit
//
//  Created by litong on 2016/11/11.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kNewsPercentViewW    140.f
#define kNewsPercentViewH    3.f



/**交易机会（专家解读）--  红色、绿色条 */
@interface NewsPercentView : UIImageView

- (void)setUpValue:(CGFloat)up;


@end
