//
//  LCCalanderHelper.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/28.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCCalanderHelper.h"

@implementation LCCalanderHelper

+ (NSInteger)daysFromStart:(NSDate *)start end:(NSDate *)end {
    NSInteger days = 0;
    NSTimeInterval interval = [end timeIntervalSinceDate:start];
    if (interval > 0) {
        NSInteger secondsPerDay = 24 * 60 * 60;
        days = interval / secondsPerDay;
    }
    return days;
}

@end
