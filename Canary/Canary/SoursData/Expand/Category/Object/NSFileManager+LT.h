//
//  NSFileManager+LT.h
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (LT)


NSString *pathOfLibraryFile(NSString *fileName);
NSString *pathOfDocumentFile(NSString *fileName);
NSString *pathOfCachesFile(NSString *fileName);
/** 获得某个缓存文件的绝对路径 **/
NSString *GetCacheFullPath(NSString *cacheName);
NSString *GetCacheFullPathAndMd5Name(NSString *cacheName);

/** 获得NSLibraryDirectory的绝对路径 **/
NSString *pathOfLibraryDirectoryPath();
/** 获得NSCachesDirectory的绝对路径 **/
NSString *pathOfCachesDirectoryPath();
/** 获得NSDocumentDirectory的绝对路径 **/
NSString *pathOfDocumentDirectoryPath();
/** 在atpath下创建dire目录 **/
NSString *createDirectory(NSString *dire, NSString *atPath);
/** 判断某个文件是否存在 **/
BOOL hasLocFileWithPath(NSString *path);

+ (void)removeFileWithPath:(NSString *)path;


@end
