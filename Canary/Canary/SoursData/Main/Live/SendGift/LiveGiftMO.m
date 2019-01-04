//
//  LiveGiftMO.m
//  ixit
//
//  Created by litong on 2017/3/30.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "LiveGiftMO.h"



@implementation LiveGiftMO

- (NSAttributedString *)poins_absfmt {
    UIColor *color = LTColorHex(0xF5E02B);
    NSString *str = self.poins;
    NSString *fullstr = [NSString stringWithFormat:@"%@ 积分",str];
    NSAttributedString *ABStr = [fullstr ABStrColor:color font:autoFontSiz(15)  range:NSMakeRange(0, str.length)];
    return ABStr;
}






#define GiftImageFileName   @"giftImgData"
+ (NSString *)giftFileBasePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesPath = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",cachesPath,GiftImageFileName];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:filePath];
    if (!fileExists) {
        BOOL bl = [fileManager createDirectoryAtPath:filePath
                         withIntermediateDirectories:YES
                                          attributes:nil
                                               error:nil];
        if (!bl) {
            NSLog(@"giftFilePathError.");
        }
    }
    return filePath;
}

+ (NSString *)giftDataPath {
    NSString *path = [NSString stringWithFormat:@"%@/%@",[self giftFileBasePath],@"giftImgData"];
    NSLog(@"open %@",path);
    return path;
}

+ (void)saveGiftImgDict:(NSDictionary *)dict {
    [dict writeToFile:[LiveGiftMO giftDataPath] atomically:YES];
}

+ (NSInteger)giftDataVer {
    NSString *path = [LiveGiftMO giftDataPath];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSInteger ver = [dict integerFoKey:kGiftDataVerKey];
    return ver;
}

#define GiftImageNamePrefix @"live_gift_"
+ (NSString *)giftImgKey:(NSString *)gid {
    NSString *imgName = [NSString stringWithFormat:@"%@%@",GiftImageNamePrefix,gid];
    return imgName;
}
+ (NSString *)giftImgUrl:(NSString *)gid {
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[LiveGiftMO giftDataPath]];
    NSLog(@"");
    NSString *imgKey = [LiveGiftMO giftImgKey:gid];
    NSString *imgUrl = [dict stringFoKey:imgKey];
    return imgUrl;
}



@end
