//
//  JSObj.h
//  ixit
//
//  Created by litong on 2016/11/25.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjProtocol <JSExport>

- (void)openShare:(NSString *)title :(NSString *)url;
- (void)shareByJson:(NSString *)jsonStr;

@end

@protocol JSObjDelegate <NSObject>

- (void)openShare:(NSString *)title url:(NSString *)url;
- (void)shareByJson:(NSString *)jsonStr;

@end


@interface JSObj : NSObject <JSObjProtocol>

@property (nonatomic,assign) id<JSObjDelegate> delegate;

@end
