//
//  NSString+LTPath.h
//  LTDevDemo
//
//  Created by litong on 2017/1/9.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LTPath)

#pragma mark - 判断&创建、删除

+ (BOOL)hasLocPath:(NSString *)path;
+ (NSString *)createDir:(NSString *)path;
+ (NSString *)createDir:(NSString *)dir atPath:(NSString *)atPath;
+ (void)removeFileWithPath:(NSString *)path;

#pragma mark - 沙盒路径

+ (NSString *)pathOfSandbox:(NSSearchPathDirectory)dir;


#define dirDocumentPath    [NSString dirDocument]
#define dirLibraryPath          [NSString dirLibrary]
#define dirCachesPath         [NSString dirCaches]
#define dirPreferencesPath  [NSString dirPreferences]
#define dirTmpPath              [NSString dirTmp]

//Document：iTunes备份数据、恢复数据时，会备份、恢复此目录
+ (NSString *)dirDocument;

//Library：主要存储的是默认的设置或其它的状态信息。
//包含两个文件夹：Caches、Preferences
+ (NSString *)dirLibrary;
//Caches：存储缓存文件，存储应用程序再次启动所需的，itunes不会备份该目录；
+ (NSString *)dirCaches;
//Preferences：存储应用程序偏好设置，一般不修改这里存放的文件；
+ (NSString *)dirPreferences;

//tmp：存储临时文件；iPhone重启tmp目录清空。
+ (NSString *)dirTmp;


#pragma mark - 自定义文件路径

#define documentFileName(fileName)  [NSString documentFileName:fileName]
#define libraryFileName(fileName)        [NSString libraryFileName:fileName]
#define cachesFileName(fileName)      [NSString cachesFileName:fileName]
#define tmpFileName(fileName)            [NSString tmpFileName:fileName]

+ (NSString *)documentFileName:(NSString *)fileName;
+ (NSString *)libraryFileName:(NSString *)fileName;
+ (NSString *)cachesFileName:(NSString *)fileName;
+ (NSString *)tmpFileName:(NSString *)fileName;

//资源路径
+ (NSString *)resourceName:(NSString *)name ofType:(NSString *)ext;
+ (NSString *)resourceName:(NSString *)name;
+ (NSString *)stringFromLocPathWithResourceName:(NSString *)name;


#pragma mark - 写入Path
- (void)writeToFile:(NSString *)path;


@end
