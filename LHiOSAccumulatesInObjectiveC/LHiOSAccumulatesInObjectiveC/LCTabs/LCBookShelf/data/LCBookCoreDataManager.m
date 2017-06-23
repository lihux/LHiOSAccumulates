//
//  LCBookCoreDataManager.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/21.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCBookCoreDataManager.h"

#import <CoreData/CoreData.h>

#import "LCBookCreater.h"

@interface LCBookCoreDataManager ()

@property (nonatomic, strong) NSPersistentContainer *persistentContainer;
@property (nonatomic, strong) NSFetchedResultsController *fetchBookController;

@end

@implementation LCBookCoreDataManager

- (NSInteger)numberOfBooksInSection:(NSInteger)section {
    return [self.fetchBookController sections].count;
}

- (LCBook *)bookForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.fetchBookController objectAtIndexPath:indexPath];
}

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (BOOL)inserNewBookFromJsonData:(id)jsonData {
    return [LCBookCreater createBookFromJsonData:jsonData managedObjectContext:self.persistentContainer.viewContext];
}

#pragma mark - lazy load
- (NSFetchedResultsController *)fetchBookController {
    if (_fetchBookController) {
        return _fetchBookController;
    }
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"LCBook"];
    fetchRequest.fetchBatchSize = 20;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pageCount" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    _fetchBookController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.persistentContainer.viewContext sectionNameKeyPath:nil cacheName:@"LCBookCoreDataManager"];
    return _fetchBookController;
}

- (NSPersistentContainer *)persistentContainer {
    if (_persistentContainer) {
        return _persistentContainer;
    }
    _persistentContainer = [NSPersistentContainer persistentContainerWithName:@"LCBookShelf"];
    [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * _Nonnull storeDescription, NSError * _Nullable error) {
        NSAssert(!error, ([NSString stringWithFormat:@"从CoreData中加载我的书架书籍失败，错误信息：\n%@", error]), nil);
    }];
    return _persistentContainer;
}

@end
