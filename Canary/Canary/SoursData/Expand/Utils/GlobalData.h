

#import <Foundation/Foundation.h>

@interface GlobalData : NSObject

@property(nonatomic,strong) NSString *socketUrl;

+ (GlobalData *)instance;

@end
