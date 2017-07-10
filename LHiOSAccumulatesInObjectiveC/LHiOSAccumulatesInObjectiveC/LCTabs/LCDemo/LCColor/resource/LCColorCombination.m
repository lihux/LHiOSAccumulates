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

+ (NSArray <LCNamedColor *>*)colorsFromArray:(NSArray *)array {
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        [temp addObject:[[LCNamedColor alloc] initWithName:dic[@"name"] rgb:dic[@"rgb"]]];
    }
    return [temp copy];
}

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

- (NSString *)description {
    return [NSString stringWithFormat:@"LCNamedColor:%@, %zd", self.name, self.rgb];
}

@end

@implementation LCColorCombination

+ (NSArray *)colorCombinations {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"100CombinationColors" ofType:@"plist"];
    NSArray *temp = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *combinations = [NSMutableArray array];
    for (int i = 0; i < temp.count; i ++) {
        [combinations addObject:[[LCColorCombination alloc]initWithDic:temp[i] index:i]];
    }
    return [combinations copy];
}

- (instancetype)initWithDic:(NSDictionary *)dic index:(NSInteger)index {
    if (self = [super init]) {
        self.name = dic[@"name"];
        self.imageName = [NSString stringWithFormat:@"100ColorCombinations%zd", index];
        self.colors = [LCNamedColor colorsFromArray:dic[@"namedColors"]];
    }
    return self;
}
@end
