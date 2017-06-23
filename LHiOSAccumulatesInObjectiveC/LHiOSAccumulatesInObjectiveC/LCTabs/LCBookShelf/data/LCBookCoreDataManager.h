//
//  LCBookCoreDataManager.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/21.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSFetchedResultsController;
@class LCBook;

@protocol LCBookCoreDataManagerDelegate <NSObject>

- (void)dataHasChanged;

@end

@interface LCBookCoreDataManager : NSObject

@property (nonatomic, weak) id<LCBookCoreDataManagerDelegate> delegate;

- (NSFetchedResultsController *)fetchBookController;
- (NSInteger)numberOfBooksInSection:(NSInteger)section;
- (LCBook *)bookForRowAtIndexPath:(NSIndexPath *)indexPath;
- (LCBook *)bookForISBN:(NSString *)ISBN;
- (BOOL)inserNewBookFromJsonData:(id)jsonData;

@end
