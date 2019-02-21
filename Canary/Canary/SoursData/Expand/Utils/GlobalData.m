

#import "GlobalData.h"

@implementation GlobalData


+ (GlobalData *)instance
{
    static GlobalData *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[GlobalData alloc]init];
    });
    
    return _sharedInstance;
}



- (id)init{
    
    if (self = [super init]) {
        
    }
    return self;
}

@end
