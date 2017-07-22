//
//  LCSDefaultOpenSaveManager.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/7/22.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCSDefaultOpenSaveManager.h"

@interface LCSDefaultOpenSaveManager ()

@property (nonatomic, copy) NSString *record;
@property (nonatomic, strong) NSMutableArray <NSString *>*records;
@property (nonatomic, assign) BOOL isRestoring;

@end

@implementation LCSDefaultOpenSaveManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LCSDefaultOpenSaveManager *_instance;
    dispatch_once(&onceToken, ^{
        _instance = [[LCSDefaultOpenSaveManager alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.record = [[NSUserDefaults standardUserDefaults] objectForKey:[self storeKey]];
    }
    return self;
}

- (BOOL)hasRecords {
    return self.record.length > 0;
}

- (void)startRestore {
    self.isRestoring = YES;
    self.records = [NSMutableArray arrayWithArray:[self.record componentsSeparatedByString:@"-"]];
}

- (NSInteger)restoreARecord {
    NSInteger record = -1;
    if (self.records.count > 0) {
        record = [self.records firstObject].integerValue;
        [self.records removeObjectAtIndex:0];
    }
    
    return record;
}

- (void)finishRestore {
    self.isRestoring = NO;
}

- (void)pushRecord:(NSInteger)record {
    if (!self.isRestoring) {
        self.record = [NSString stringWithFormat:@"%@-%zd", self.record, record];
        NSLog(@"新增一条记录，全部记录是：%@", self.record);
    }
}

- (NSInteger)popRecord {
    NSInteger record = -1;
    if (!self.isRestoring) {
        NSRange range = [self.record rangeOfString:@"-" options:NSBackwardsSearch];
        if (range.location != NSNotFound && range.location > 0) {
            self.record = [self.record substringWithRange:NSMakeRange(0, range.location)];
            NSLog(@"pop出一条记录，全部记录是：%@", self.record);
        }
    }
    return record;
}

- (void)resetRoot:(NSInteger)root {
    if (!self.isRestoring) {
        self.record = [NSString stringWithFormat:@"%zd", root];
    }
}

- (void)clean {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self storeKey]];
}

- (NSString *)storeKey {
    return @"LCSDefaultOpenSaveManager_StoreKey";
}

- (void)dealloc {
    NSLog(@"天灵灵，地灵灵，我背释放了，哈哈哈哈哈哈哈");
    [[NSUserDefaults standardUserDefaults] setObject:self.record forKey:[self storeKey]];
}

@end
