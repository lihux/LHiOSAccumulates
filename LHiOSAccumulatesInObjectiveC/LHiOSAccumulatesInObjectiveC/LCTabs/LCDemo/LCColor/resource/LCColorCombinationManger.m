//
//  LCColorCombinationManger.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/7/9.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCColorCombinationManger.h"

@implementation LCColorCombinationManger

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LCColorCombinationManger *_sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        if (!_sharedInstance) {
            _sharedInstance = [[self alloc] init];
        }
    });
    return _sharedInstance;
}

- (NSArray<LCColorCombination *> *)colorCombinations {
    if (_colorCombinations) {
        return _colorCombinations;
    }
    _colorCombinations = [LCColorCombination colorCombinations];
    return _colorCombinations;
}

- (NSArray<LCNamedColor *> *)namedColors {
    NSMutableArray *temp = [NSMutableArray array];
    for (LCColorCombination *combination in self.colorCombinations) {
        [temp addObjectsFromArray:combination.colors];
    }
    return [temp copy];
}

@end
