//
//  LCSDefaultOpenSaveManager.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/7/22.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCSDefaultOpenSaveManager.h"

@interface LCSDefaultOpenSaveManager ()

@property (nonatomic, strong) NSMutableArray <NSString *> *roots;
@property (nonatomic, strong) NSMutableArray <NSString *>*records;
@property (nonatomic, assign) BOOL isRestoring;

@end

static const NSInteger kRootCount = 4;//目前首页只有4个tab，暂存这4个tab的信息
static NSString *kCurrentRootKey = @"kCurrentRootKey_LCSDefaultOpenSaveManager";

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
        [self loadRecords];
    }
    return self;
}

#pragma mark - load and save records
- (void)loadRecords {
    for (NSInteger i = 0; i < kRootCount; i ++) {
        NSString *record = [[NSUserDefaults standardUserDefaults] objectForKey:[self storeKeyForRoot:i]];
        if (record) {
            [self.roots replaceObjectAtIndex:i withObject:record];
        }
    }
    NSNumber *currentRoot = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentRootKey];
    if (currentRoot) {
        self.currtentRoot = currentRoot.integerValue;
    }
}

- (void)saveRecords {
    for (NSInteger i = 0; i < kRootCount; i ++) {
        [[NSUserDefaults standardUserDefaults] setObject:self.roots[i] forKey:[self storeKeyForRoot:i]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(self.currtentRoot) forKey:kCurrentRootKey];
}

#pragma mark - convenient methods
- (NSString *)currtentRecord {
    return [[self.roots objectAtIndex:self.currtentRoot] copy];
}

- (BOOL)hasRecords {
    return [self currtentRecord].length > 0;
}

- (void)startRestore {
    self.isRestoring = YES;
    self.records = [NSMutableArray arrayWithArray:[[self currtentRecord] componentsSeparatedByString:@"-"]];
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
    NSString *temp = [NSString stringWithFormat:@"%zd", record];
    NSString *current = [self currtentRecord];
    if (current.length > 0) {
        temp = [NSString stringWithFormat:@"%@-%@", current, temp];
    }
    [self.roots replaceObjectAtIndex:self.currtentRoot withObject:temp];
    NSLog(@"新增一条记录，全部记录是：%@", temp);
}

- (NSInteger)popRecord {
    NSInteger record = -1;
    NSString *temp = [self currtentRecord];
    NSRange range = [temp rangeOfString:@"-" options:NSBackwardsSearch];
    if (temp.length > 0 && range.location == NSNotFound) {
        [self.roots replaceObjectAtIndex:self.currtentRoot withObject:@""];
        record = [temp integerValue];
    } else if (range.location != NSNotFound && range.location > 0) {
        NSString *firstPart = [temp substringWithRange:NSMakeRange(0, range.location)];
        NSString *secondPart = [temp substringWithRange:NSMakeRange(range.location + 1, temp.length - range.location - 1)];
        [self.roots replaceObjectAtIndex:self.currtentRoot withObject:firstPart];
        record = secondPart.integerValue;
    }
    if (record >= 0) {
        NSLog(@"pop出一条记录，全部记录是：%@", [self currtentRecord]);
    }
    return record;
}

- (NSString *)storeKeyForRoot:(NSInteger)root {
    return [NSString stringWithFormat:@"LCSDefaultOpenSaveManager_StoreKey_Root_%zd", root];
}

- (void)dealloc {
    NSLog(@"天灵灵，地灵灵，我释放了，哈哈哈哈哈哈哈");
    [self saveRecords];
}

#pragma mark - getter and setters
- (NSMutableArray<NSString *> *)roots {
    if (_roots) {
        return _roots;
    }
    _roots = [NSMutableArray arrayWithArray:@[@"", @"", @"", @""]];
    return _roots;
}

- (void)setCurrtentRoot:(NSInteger)currtentRoot {
    if (currtentRoot < 0 || currtentRoot >= kRootCount) {
        return;
    }
    _currtentRoot = currtentRoot;
}

@end
