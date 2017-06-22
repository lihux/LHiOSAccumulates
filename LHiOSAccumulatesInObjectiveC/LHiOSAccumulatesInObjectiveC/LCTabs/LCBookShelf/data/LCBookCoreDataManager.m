//
//  LCBookCoreDataManager.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/21.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCBookCoreDataManager.h"

#import <CoreData/CoreData.h>

@interface LCBookCoreDataManager ()

@property (nonatomic, strong) NSPersistentContainer *persistentContainer;

@end

@implementation LCBookCoreDataManager

- (instancetype)init {
    if (self = [super init]) {
        self.persistentContainer = [NSPersistentContainer persistentContainerWithName:@"LCBookShelf"];
    }
    return self;
}

@end
