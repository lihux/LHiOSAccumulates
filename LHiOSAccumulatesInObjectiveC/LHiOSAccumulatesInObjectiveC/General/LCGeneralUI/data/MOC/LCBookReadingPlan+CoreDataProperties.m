//
//  LCBookReadingPlan+CoreDataProperties.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/22.
//  Copyright © 2017年 Lihux. All rights reserved.
//
//

#import "LCBookReadingPlan+CoreDataProperties.h"

@implementation LCBookReadingPlan (CoreDataProperties)

+ (NSFetchRequest<LCBookReadingPlan *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"LCBookReadingPlan"];
}

@dynamic currentReadingCount;
@dynamic endTime;
@dynamic startTime;
@dynamic totalPageCount;
@dynamic book;

@end
