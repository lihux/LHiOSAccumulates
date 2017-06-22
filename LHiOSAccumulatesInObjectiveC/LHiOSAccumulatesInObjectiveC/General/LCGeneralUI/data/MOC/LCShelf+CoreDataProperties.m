//
//  LCShelf+CoreDataProperties.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/22.
//  Copyright © 2017年 Lihux. All rights reserved.
//
//

#import "LCShelf+CoreDataProperties.h"

@implementation LCShelf (CoreDataProperties)

+ (NSFetchRequest<LCShelf *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"LCShelf"];
}

@dynamic bookCount;
@dynamic books;

@end
