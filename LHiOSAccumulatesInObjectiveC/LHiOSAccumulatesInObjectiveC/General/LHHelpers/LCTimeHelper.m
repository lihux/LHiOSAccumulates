//
//  LCTimeHelper.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/30.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCTimeHelper.h"

@interface LCTimeHelper ()

@property (nonatomic, strong) NSCalendar *calender;

@end

static const NSInteger kMinute = 60;
static const NSInteger kHour = 60 * kMinute;
static const NSInteger kDay = 24 * kHour;

@implementation LCTimeHelper

+ (NSTimeInterval)timeIntervalFromDate:(NSDate *)date {
    return [date timeIntervalSince1970];
}

+ (NSDate *)dateFromTimeInterval:(NSTimeInterval)timeInterval {
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}

+ (NSDate *)tomorrow {
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDate *tomorrow = [NSDate dateWithTimeIntervalSince1970:[self timeIntervalFromDate:[NSDate date]] + kDay];
    NSInteger era, year, month, day;
    [calender getEra:&era year:&year month:&month day:&day fromDate:tomorrow];
    return [calender dateWithEra:era year:year month:month day:day hour:0 minute:0 second:0 nanosecond:0];
}

+ (NSString *)yyMMddFromDate:(NSDate *)date {
    NSInteger era, year, month, day;
    [[NSCalendar currentCalendar] getEra:&era year:&year month:&month day:&day fromDate:date];
    return [NSString stringWithFormat:@"%04ld-%02ld-%02ld", year, month, day];
}

+ (NSString *)yyMMddFromTimeInterval:(NSTimeInterval)timeInterval {
    return [self yyMMddFromDate:[self dateFromTimeInterval:timeInterval]];
}

+ (NSDate *)dateFromyyMMdd:(NSString *)yyMMdd {
    NSDate *date;
    NSArray *temp = [yyMMdd componentsSeparatedByString:@"-"];
    if (temp.count == 3) {
        NSInteger year = [temp[0] integerValue], month = [temp[1] integerValue], day = [temp[2] integerValue];
        date = [[NSCalendar currentCalendar] dateWithEra:1 year:year month:month day:day hour:0 minute:0 second:0 nanosecond:0];
    }
    return date;
}

+ (NSTimeInterval)timeIntervalFromyyMMdd:(NSString *)yyMMdd {
    return [self timeIntervalFromDate:[self dateFromyyMMdd:yyMMdd]];
}

+ (NSDate *)dateFromOriginDate:(NSDate *)originDate daysOffset:(NSTimeInterval)daysOffset {
    NSTimeInterval interval = [self timeIntervalFromDate:originDate] + (daysOffset * kDay);
    return [self dateFromTimeInterval:interval];
}

+ (NSInteger)daysDuratinFromStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    int64_t start = (int64_t)[self timeIntervalFromDate:startDate];
    int64_t end = (int64_t)[self timeIntervalFromDate:endDate];
    NSCalendar *calender = [NSCalendar currentCalendar];
    if (end <= start) {
        return 0;
    }
    if ([calender isDate:startDate inSameDayAsDate:endDate]) {
        return 0;
    }
    int64_t duration = end - start;
    int64_t daysDuration = duration / kDay + (duration % kDay > 0 ? 1 : 0);
    return daysDuration;
}

+ (NSInteger)daysDuratinFromStartTimeInterval:(NSTimeInterval)startTimeInterval endTimeInterval:(NSTimeInterval)endTimeInterval {
    NSDate *startDate = [self dateFromTimeInterval:startTimeInterval];
    NSDate *endDate = [self dateFromTimeInterval:endTimeInterval];
    return [self daysDuratinFromStartDate:startDate endDate:endDate];
}

@end
