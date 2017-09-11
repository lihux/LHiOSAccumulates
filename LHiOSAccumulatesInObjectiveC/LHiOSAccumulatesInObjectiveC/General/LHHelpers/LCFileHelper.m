//
//  LCFileHelper.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/9/12.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCFileHelper.h"

@implementation LCFileHelper

+ (BOOL)createDirIfNeeded:(NSString *)dirPath {
    BOOL ret;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    BOOL exist = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    if (exist && !isDir) {
        if(![fileManager removeItemAtPath:dirPath error:nil]) {
            return NO;
        } else {
            exist = NO;
        }
    }
    if (!exist) {
        ret = [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        ret = YES;
    }
    return ret;
}

+ (NSString *)documentDir {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

+ (NSString *)cacheDir {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

+ (NSString *)tempFilePathInDir:(NSString *)dir
{
    NSString *path = [self tempFilePathInDir:dir fileName:nil extension:nil];
    return path;
}

+ (NSString *)tempFilePathInDir:(NSString *)dir fileName:(NSString *)fileName extension:(NSString *)extension
{
    NSString *dirPath = NSTemporaryDirectory();
    if (dir.length) {
        dirPath = [dirPath stringByAppendingPathComponent:dir];
        NSFileManager *fileManager = [NSFileManager new];
        BOOL isDir = NO;
        if ([fileManager fileExistsAtPath:dirPath isDirectory:&isDir]) {
            if (!isDir) {
                dirPath = NSTemporaryDirectory();
            }
        } else {
            dirPath = NSTemporaryDirectory();
        }
    }
    
    NSString *suffixStr = [[NSProcessInfo processInfo] globallyUniqueString];
    NSMutableString *completeFileName = [NSMutableString string];
    if (fileName.length) {
        [completeFileName appendString:fileName];
    } else {
        [completeFileName appendString:@"mcctmp"];
    }
    [completeFileName appendFormat:@"_%@", suffixStr];
    if (extension.length) {
        [completeFileName appendFormat:@".%@", extension];
    }
    NSString *tempFile = [dirPath stringByAppendingPathComponent:completeFileName];
    return tempFile;
}

+ (NSString *)tempDirPath
{
    NSString *dirName = [[NSProcessInfo processInfo] globallyUniqueString];
    NSFileManager *fileManager = [NSFileManager new];
    int i = 10;
    while (i > 0 && [fileManager fileExistsAtPath:dirName]) {
        dirName = [[NSProcessInfo processInfo] globallyUniqueString];
        --i;
    }
    NSString *tmpPath = [NSTemporaryDirectory() stringByAppendingPathComponent:dirName];
    return tmpPath;
}

#pragma mark Preferences

+ (NSString *)plistFilePathInPrefsDir:(NSString *)fileName {
    if (!fileName.length) {
        return nil;
    }
    NSString *libPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
    NSString *prefsPath = [libPath stringByAppendingPathComponent:@"Preferences"];
    NSString *filePath = [prefsPath stringByAppendingPathComponent:fileName];
    return filePath;
}

+ (void)setValue:(id)value forKey:(NSString *)key inPlistFile:(NSString *)fileName {
    if (!key.length) {
        return;
    }
    NSString *plistPath = [self plistFilePathInPrefsDir:fileName];
    if (!plistPath.length) {
        return;
    }
    NSFileManager *fileManager = [NSFileManager new];
    NSMutableDictionary *dict;
    if ([fileManager fileExistsAtPath:plistPath]) {
        dict = [[NSDictionary dictionaryWithContentsOfFile:plistPath] mutableCopy];
        if ([[dict objectForKey:key] isEqual:value]) {
            return;
        }
    } else {
        dict = [NSMutableDictionary new];
    }
    [dict setValue:value forKey:key];
    [[NSDictionary dictionaryWithDictionary:dict] writeToFile:plistPath atomically:YES];
}

@end
