//
//  NSFileManager+LT.m
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "NSFileManager+LT.h"

@implementation NSFileManager (LT)

#pragma mark - 文件处理相关
NSString *pathOfLibraryFile(NSString *fileName) {
    if (!fileName) {
        return nil;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], fileName];
}

NSString *pathOfDocumentFile(NSString *fileName) {
    if (!fileName) {
        return nil;
    }
    
    NSString *locPath = pathOfDocumentDirectoryPath();
    return [NSString stringWithFormat:@"%@/%@", locPath, fileName];
}

NSString *pathOfCachesFile(NSString *fileName) {
    if (!fileName) {
        return nil;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], fileName];
}

/** 获得某个缓存文件的绝对路径 **/
NSString *GetCacheFullPath(NSString *cacheName){
    if (nil == cacheName) {
        return nil;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    if (nil == documentsDirectory) {
        return nil;
    }
    
    return [documentsDirectory stringByAppendingPathComponent:cacheName];
}



NSString *GetCacheFullPathAndMd5Name(NSString *cacheName) {
    return GetCacheFullPath([cacheName md5]);
}

/** 获得NSLibraryDirectory的绝对路径 **/
NSString *pathOfLibraryDirectoryPath() {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}
/** 获得NSCachesDirectory的绝对路径 **/
NSString *pathOfCachesDirectoryPath() {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}
/** 获得NSDocumentDirectory的绝对路径 **/
NSString *pathOfDocumentDirectoryPath() {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDire = [paths objectAtIndex:0];
    return docDire;
}

NSString *createDirectory(NSString *fileName, NSString *atPath) {
    NSString *folderPath = [atPath stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:folderPath];
    if (!fileExists) {
        BOOL bl = [fileManager createDirectoryAtPath:folderPath
                         withIntermediateDirectories:YES
                                          attributes:nil
                                               error:nil];
        return bl ? folderPath : @"";
    } else {
        return folderPath;
    }
}

BOOL hasLocFileWithPath(NSString *path) {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (void)removeFileWithPath:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:path error:nil];
}
@end
