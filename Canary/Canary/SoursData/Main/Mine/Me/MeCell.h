//
//  MeCell.h
//  ixit
//
//  Created by litong on 2016/12/9.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMeCellH    45

#define kUserUnReadMessageCountKey @"kUserUnReadMessageCountKey"
#define UD_UnReadMessageCount [UserDefaults integerForKey:kUserUnReadMessageCountKey]
#define UD_SetUnReadMessageCount(messageCount) [UserDefaults setInteger:messageCount forKey:kUserUnReadMessageCountKey]


@interface MeCell : UITableViewCell

- (void)bindData:(NSString *)data;

@end
