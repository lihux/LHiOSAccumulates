//
//  LCDURLHelper.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/6/10.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kLCDURLHost;

@interface LCDURLHelper : NSObject


/**
 拼接URL辅助函数

 @param path url路径，必须要以'/'开头，比如：/hello/lihux
 @return 使用默认host拼接完成的NSURL实例
 */
+ (NSURL *)urlWithPath:(NSString *)path;

@end
