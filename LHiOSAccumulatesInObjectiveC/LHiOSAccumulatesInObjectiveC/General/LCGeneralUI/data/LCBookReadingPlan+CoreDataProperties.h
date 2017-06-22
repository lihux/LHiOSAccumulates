//
//  LCBookReadingPlan+CoreDataProperties.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/22.
//  Copyright © 2017年 Lihux. All rights reserved.
//
//

#import "LCBookReadingPlan+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface LCBookReadingPlan (CoreDataProperties)

+ (NSFetchRequest<LCBookReadingPlan *> *)fetchRequest;

@property (nonatomic) int64_t currentReadingCount;
@property (nullable, nonatomic, copy) NSDate *endTime;
@property (nullable, nonatomic, copy) NSDate *startTime;
@property (nonatomic) int64_t totalPageCount;
@property (nullable, nonatomic, retain) LCBook *book;

@end

NS_ASSUME_NONNULL_END
