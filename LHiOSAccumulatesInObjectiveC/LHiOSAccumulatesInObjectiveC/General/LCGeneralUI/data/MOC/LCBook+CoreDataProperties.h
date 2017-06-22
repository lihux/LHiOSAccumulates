//
//  LCBook+CoreDataProperties.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/22.
//  Copyright © 2017年 Lihux. All rights reserved.
//
//

#import "LCBook+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface LCBook (CoreDataProperties)

+ (NSFetchRequest<LCBook *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *author;
@property (nonatomic) int64_t chapterCount;
@property (nonatomic) BOOL hasRead;
@property (nullable, nonatomic, copy) NSString *language;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int64_t pageCount;
@property (nullable, nonatomic, retain) LCBookReadingPlan *readingPlan;

@end

NS_ASSUME_NONNULL_END
