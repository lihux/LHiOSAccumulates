//
//  LCSDefaultOpenSaveManager.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/7/22.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCSDefaultOpenSaveManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, assign) BOOL recordEnable;

- (BOOL)hasRecords;

//恢复记录按照队列的顺序进行（先进先出）
- (void)startRestore;
- (NSInteger)restoreARecord;
- (void)finishRestore;
- (BOOL)isRestoring;

//记录按照栈的顺序进行（后进先出）
- (void)pushRecord:(NSInteger)record;
- (NSInteger)popRecord;
- (void)resetRoot:(NSInteger)root;
- (void)clean;

@end
