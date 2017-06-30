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

@end
