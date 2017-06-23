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
@property (nonatomic, strong) LCBookCreater *bookCreater;

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
    return [self.bookCreater createBookFromJsonData:jsonData];
}

- (LCBook *)bookForISBN:(NSString *)ISBN {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"LCBook"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"isbn13 = %@", ISBN];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    NSError *error = nil;
    NSArray *result = [self.persistentContainer.viewContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"读取图书:%@发生错误：%@", ISBN, error);
    }
    if (result.count > 0) {
        return result[0];
    }
    return nil;
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

- (LCBookCreater *)bookCreater {
    if (_bookCreater) {
        return _bookCreater;
    }
    _bookCreater = [[LCBookCreater alloc] initWithMOC:self.persistentContainer.viewContext];
    return _bookCreater;
}

@end
