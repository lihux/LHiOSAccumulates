//
//  LCTimeHelper.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/30.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCTimeHelper : NSObject

+ (NSTimeInterval)timeIntervalFromDate:(NSDate *)date;

+ (NSDate *)dateFromTimeInterval:(NSTimeInterval)timeInterval;

+ (NSDate *)tomorrow;

+ (NSString *)yyMMddFromDate:(NSDate *)date;

+ (NSString *)yyMMddFromTimeInterval:(NSTimeInterval)timeInterval;

+ (NSInteger)daysDuratinFromStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

+ (NSInteger)daysDuratinFromStartTimeInterval:(NSTimeInterval)startTimeInterval endTimeInterval:(NSTimeInterval)endTimeInterval;

+ (NSDate *)dateFromOriginDate:(NSDate *)originDate daysOffset:(NSTimeInterval)daysOffset;

@end
