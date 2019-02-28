//
//  LCDParent.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2019/2/28.
//  Copyright © 2019年 Lihux. All rights reserved.
//

#import "LCDParent.h"

@implementation LCDParent {
//    NSString *_city;//和synthesize二选一
}

@synthesize city = _city;

- (instancetype)initWithCity:(NSString *)city {
    if (self = [super init]) {
        _city = city;
    }
    return self;
}

- (NSString *)city {
    NSLog(@"搞什么啊？%@", _city);
    return _city;
}

- (void)setCity:(NSString *)city {
    _city = city;
}

@end
