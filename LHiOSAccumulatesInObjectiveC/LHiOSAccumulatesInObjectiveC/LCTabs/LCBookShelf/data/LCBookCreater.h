//
//  LCBookCreater.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/23.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LCBook;
@class NSManagedObjectContext;

@interface LCBookCreater : NSObject

- (instancetype)initWithMOC:(NSManagedObjectContext *)moc;

- (LCBook *)createBookFromJsonData:(id)jsonData;

@end
