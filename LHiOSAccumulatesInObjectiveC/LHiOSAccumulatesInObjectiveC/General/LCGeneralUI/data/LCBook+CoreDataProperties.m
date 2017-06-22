//
//  LCBook+CoreDataProperties.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/22.
//  Copyright © 2017年 Lihux. All rights reserved.
//
//

#import "LCBook+CoreDataProperties.h"

@implementation LCBook (CoreDataProperties)

+ (NSFetchRequest<LCBook *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"LCBook"];
}

@dynamic author;
@dynamic chapterCount;
@dynamic hasRead;
@dynamic language;
@dynamic name;
@dynamic pageCount;
@dynamic readingPlan;

@end
