//
//  LCAlgorithmBaseModel.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2019/7/1.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "LCAlgorithmBaseModel.h"

@implementation LCAlgorithmBaseModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self beginTests];
    }
    return self;
}

//子类实现
- (void)beginTests {
}

@end
