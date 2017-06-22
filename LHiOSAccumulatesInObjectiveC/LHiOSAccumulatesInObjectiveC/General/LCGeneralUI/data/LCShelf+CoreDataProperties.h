//
//  LCShelf+CoreDataProperties.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/22.
//  Copyright © 2017年 Lihux. All rights reserved.
//
//

#import "LCShelf+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface LCShelf (CoreDataProperties)

+ (NSFetchRequest<LCShelf *> *)fetchRequest;

@property (nonatomic) int64_t bookCount;
@property (nullable, nonatomic, retain) NSSet<LCBook *> *books;

@end

@interface LCShelf (CoreDataGeneratedAccessors)

- (void)addBooksObject:(LCBook *)value;
- (void)removeBooksObject:(LCBook *)value;
- (void)addBooks:(NSSet<LCBook *> *)values;
- (void)removeBooks:(NSSet<LCBook *> *)values;

@end

NS_ASSUME_NONNULL_END
