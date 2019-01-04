//
//  NSString+LTPath.m
//  LTDevDemo
//
//  Created by litong on 2017/1/9.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "NSString+LTPath.h"



@implementation NSString (LTPath)


#pragma mark - 判断&创建、删除

+ (BOOL)hasLocPath:(NSString *)path {
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];;
    return fileExists;
}

+ (NSString *)createDir:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    if (!fileExists) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

+ (NSString *)createDir:(NSString *)dir atPath:(NSString *)atPath {
    NSString *path = [atPath stringByAppendingPathComponent:dir];
    return [NSString createDir:path];
}

+ (void)removeFileWithPath:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:path error:nil];
}

#pragma mark - 沙盒路径

+ (NSString *)pathOfSandbox:(NSSearchPathDirectory)dir {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(dir, NSUserDomainMask, YES);
    NSString *docDire = [paths objectAtIndex:0];
    return docDire;
}

//Document：iTunes备份数据、恢复数据时，会备份、恢复此目录
+ (NSString *)dirDocument {
    NSString *path = [self pathOfSandbox:NSDocumentDirectory];
    return path;
}

//Library：主要存储的是默认的设置或其它的状态信息。包含以下两个文件夹：Caches、Preferences
+ (NSString *)dirLibrary {
    NSString *path = [self pathOfSandbox:NSLibraryDirectory];
    return path;
}
//Caches：存储缓存文件，存储应用程序再次启动所需的，itunes不会备份该目录；
+ (NSString *)dirCaches {
    NSString *path = [self pathOfSandbox:NSCachesDirectory];
    return path;
}
//Preferences：存储应用程序偏好设置，一般不修改这里存放的文件；
+ (NSString *)dirPreferences {
    NSString *libraryPath = [self dirLibrary];
    NSString *path = [libraryPath stringByAppendingPathComponent:@"Preferences"];
    return path;
}

//tmp：存储临时文件；iPhone重启tmp目录清空。
+ (NSString *)dirTmp {
    NSString *path = NSTemporaryDirectory();
    return path;
}


#pragma mark - 自定义文件路径

+ (NSString *)documentFileName:(NSString *)fileName {
    NSString *path = [self dirDocument];
    path = [path stringByAppendingPathComponent:fileName];
    return path;
}
+ (NSString *)libraryFileName:(NSString *)fileName {
    NSString *path = [self dirLibrary];
    path = [path stringByAppendingPathComponent:fileName];
    return path;
}
+ (NSString *)cachesFileName:(NSString *)fileName {
    NSString *path = [self dirCaches];
    path = [path stringByAppendingPathComponent:fileName];
    return path;
}
+ (NSString *)tmpFileName:(NSString *)fileName {
    NSString *path = [self dirTmp];
    path = [path stringByAppendingPathComponent:fileName];
    return path;
}

//资源路径
+ (NSString *)resourceName:(NSString *)name ofType:(NSString *)ext {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:ext];
    return path;
}
+ (NSString *)resourceName:(NSString *)name {
    return [NSString resourceName:name ofType:nil];
}

+ (NSString *)stringFromLocPathWithResourceName:(NSString *)name {
    NSString *path = [NSString resourceName:name];
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return str;
}

#pragma mark - 写入Path
- (void)writeToFile:(NSString *)path {
    BOOL bl = [self writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if (bl) {
        NSLog(@"\nNSString+LTPath\n---> writeToFile success\n\n");
    } else {
        NSLog(@"\nNSString+LTPath\n---> writeToFile error\n\n");
    }
}

@end
