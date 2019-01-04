//
//  WebView.h
//  Canary
//
//  Created by apple on 2018/4/18.
//  Copyright © 2018年 litong. All rights reserved.
//

#import "BaseVCtrl.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjcDelegate <JSExport>
- (void)getCall:(NSString *)callString;
- (void)gettakephoto:(NSString *)callString;

@end
@interface WebView : BaseVCtrl<JSObjcDelegate>
@property (nonatomic,assign)NSInteger state;


@end
