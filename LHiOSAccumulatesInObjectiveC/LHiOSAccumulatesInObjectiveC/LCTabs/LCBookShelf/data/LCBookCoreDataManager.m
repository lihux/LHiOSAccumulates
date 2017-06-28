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

@interface LCBookCoreDataManager () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSPersistentContainer *persistentContainer;
@property (nonatomic, strong) LCBookCreater *bookCreater;

@end

@implementation LCBookCoreDataManager

- (NSInteger)numberOfBooksInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchBookController sections][section];
    return [sectionInfo numberOfObjects];
}

- (LCBook *)bookForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.fetchBookController objectAtIndexPath:indexPath];
}

- (instancetype)init {
    if (self = [super init]) {
        NSLog(@"%@", self.fetchBookController);
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

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if ([self.delegate respondsToSelector:@selector(dataHasChanged)]) {
        [self.delegate dataHasChanged];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath {
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
}



#pragma mark - lazy load
- (NSFetchedResultsController *)fetchBookController {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"LCBook"];
    fetchRequest.fetchBatchSize = 20;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.persistentContainer.viewContext sectionNameKeyPath:nil cacheName:@"LCBookCoreDataManager"];
    NSError *error;
    [fetchedResultsController performFetch:&error];
    if (error) {
        NSLog(@"从数据库获取失败：%@", error);
    }
    return fetchedResultsController;
}

- (NSPersistentContainer *)persistentContainer {
    if (_persistentContainer) {
        return _persistentContainer;
    }
    _persistentContainer = [NSPersistentContainer persistentContainerWithName:@"LCBookShelf"];
    [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * _Nonnull storeDescription, NSError * _Nullable error) {
        [NSString stringWithFormat:@"从CoreData中加载我的书架书籍失败，错误信息：\n%@", error];
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
