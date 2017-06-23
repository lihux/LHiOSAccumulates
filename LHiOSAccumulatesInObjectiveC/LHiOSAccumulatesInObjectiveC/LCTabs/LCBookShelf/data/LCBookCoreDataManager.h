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
@interface LCBookCoreDataManager : NSObject

- (NSFetchedResultsController *)fetchBookController;

- (NSInteger)numberOfBooksInSection:(NSInteger)section;
- (LCBook *)bookForRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)inserNewBookFromJsonData:(id)jsonData;

@end
