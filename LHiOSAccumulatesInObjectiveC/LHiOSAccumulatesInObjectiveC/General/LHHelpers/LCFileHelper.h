//
//  LCFileHelper.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/9/12.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCFileHelper : NSObject

/** 创建指定目录，如果已存在则忽略 */
+ (BOOL)createDirIfNeeded:(NSString *)dirPath;

+ (NSString *)documentDir;

+ (NSString *)cacheDir;

/*
 * 在NSTempDirectory()内生成临时目录，目录名使用[NSProcessInfo globallyUniqueString]
 */
+ (NSString *)tempDirPath;
/*
 * 生成指向NSTempDirectory()目录的临时文件路径，样式为mcctmp_xxxxx
 */
+ (NSString *)tempFilePathInDir:(NSString *)dir;
/*
 * 生成指向NSTempDirectory()目录的临时文件路径，样式为[fileName]_xxxxxx[.extension]
 * @param dir 子目录名，可为nil
 * @param fileName 指定的文件名称，如果为nil，则使用mcctmp
 * @param extension 扩展名，可为nil
 * @note 如果指定dir不存在，则文件直接创建在NSTempDirectory()目录下。
 */
+ (NSString *)tempFilePathInDir:(NSString *)dir fileName:(NSString *)fileName extension:(NSString *)extension;

#pragma mark Preferences

/** 生成Library/Preferences目录下的plist文件路径 */
+ (NSString *)plistFilePathInPrefsDir:(NSString *)fileName;
/** 向指定plist文件写入key-value, 如果文件不存在，自动创建, 否则更新 */
+ (void)setValue:(id)value forKey:(NSString *)key inPlistFile:(NSString *)fileName;

@end
