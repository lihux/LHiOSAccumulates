//
//  LCTimeHelper.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/30.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCTimeHelper.h"

@implementation LCTimeHelper

+ (NSTimeInterval)timeIntervalFromDate:(NSDate *)date {
    return [date timeIntervalSince1970];
}

+ (NSDate *)dateFromTimeInterval:(NSTimeInterval)timeInterval {
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}

@end
