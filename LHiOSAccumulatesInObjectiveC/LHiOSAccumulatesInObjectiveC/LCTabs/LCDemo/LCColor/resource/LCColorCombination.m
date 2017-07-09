//
//  LCColorCombination.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/7/9.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCColorCombination.h"

#import "UIColor+helper.h"

@implementation LCNamedColor

- (instancetype)initWithName:(NSString *)name rgb:(NSString *)rgb {
    if (self = [super init]) {
        self.name = name;
        NSString *temp = [NSString stringWithFormat:@"0x%@", rgb];
        unsigned long value = strtoul([temp UTF8String], 0, 16);
        self.rgb = (NSInteger)value;
    }
    return self;
}

- (UIColor *)color {
    return [UIColor colorWithHex:self.rgb];
}

@end

@implementation LCColorCombination

+ (NSArray *)colorCombinations {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"100CombinationColors" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSMutableArray *combinations = [NSMutableArray array];
    for (NSString *combinationName in dic.allKeys) {
        LCColorCombination *combination = [[LCColorCombination alloc] init];
        combination.name = combinationName;
        NSMutableArray *colors = [NSMutableArray array];
        NSDictionary *colorDic = dic[combinationName];
        for (NSString *colorName in colorDic.allKeys) {
            [colors addObject:[[LCNamedColor alloc] initWithName:colorName rgb:colorDic[colorName]]];
        }
        combination.colors = colors;
        [combinations addObject:combination];
    }
    return [combinations copy];
}

@end
