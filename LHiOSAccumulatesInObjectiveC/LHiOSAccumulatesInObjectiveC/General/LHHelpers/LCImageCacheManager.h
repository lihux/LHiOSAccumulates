//
//  LCImageCacheManager.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/6/24.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCImageCacheConfiguration : NSObject

@property (nonatomic, assign) int64_t cacheTime;
@property (nonatomic, assign) BOOL onDisk;
@property (nonatomic, assign) int64_t memoryCacheSize;
@property (nonatomic, assign) int64_t diskCacheSize;

+ (instancetype)defaultConfiguration;

@end

@interface LCImageCacheManager : NSObject

@end
