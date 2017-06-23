//
//  LCBookCreater.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/23.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCBookCreater.h"

#import "LCBookShelf+CoreDataModel.h"

@interface LCBookCreater ()

@property (nonatomic, weak) NSManagedObjectContext *moc;

@end

@implementation LCBookCreater

- (instancetype)initWithMOC:(NSManagedObjectContext *)moc {
    if (self = [super init]) {
        self.moc = moc;
    }
    return self;
}

- (LCBook *)createBookFromJsonData:(id)jsonData {
    NSDictionary *dic = [self dicFromJsonData:jsonData];
    NSManagedObjectContext *moc = self.moc;
    if (dic && moc) {
        LCBook *book = [[LCBook alloc] initWithContext:moc];
        book.subtitle = [self stringFromJsonData:dic[@"subtitle"]];
        book.publishDate = [self stringFromJsonData:dic[@"pubdate"]];
        book.originalTitle = [self stringFromJsonData:dic[@"origin_title"]];
        book.image = [self stringFromJsonData:dic[@"image"]];
        book.binding = [self stringFromJsonData:dic[@"binding"]];
        book.catalog = [self stringFromJsonData:dic[@"catalog"]];
        book.pages = [[self stringFromJsonData:dic[@"pages"]] longLongValue];
        book.publisher = [self stringFromJsonData:dic[@"publisher"]];
        book.doubanID = [[self stringFromJsonData:dic[@"id"]] longLongValue];
        book.doubanURL = [self stringFromJsonData:dic[@"alt"]];
        book.isbn10 = [self stringFromJsonData:dic[@"isbn10"]];
        book.isbn13 = [self stringFromJsonData:dic[@"isbn13"]];
        book.title = [self stringFromJsonData:dic[@"title"]];
        book.authorIndroduction = [self stringFromJsonData:dic[@"author_intro"]];
        book.summary = [self stringFromJsonData:dic[@"summary"]];
        book.price = [self stringFromJsonData:dic[@"price"]];
        
        book.doubanRating = [self ratingFromJsonData:dic[@"rating"]];
        book.authors = [self authorsFromJsonData:dic[@"author"]];
        book.translators = [self translatorsFromJsonData:dic[@"translator"]];
        book.detailImage = [self bookImageFromJsonData:dic[@"images"]];
        book.series = [self bookSeriesFromJsonData:dic[@"series"]];
        if ([self.moc hasChanges]) {
            NSError *error = nil;
            [self.moc save:&error];
            if (error) {
                NSLog(@"存储CoreData数据失败：%@", error);
            }
        }
        return book;
    }
    return nil;
}

- (LCBookDouBanRating *)ratingFromJsonData:(id)jsonData {
    NSDictionary *dic = [self dicFromJsonData:jsonData];
    NSManagedObjectContext *moc = self.moc;
    if (dic && moc) {
        LCBookDouBanRating *rating = [[LCBookDouBanRating alloc] initWithContext:moc];
        rating.max = [self int64FromJsonData:dic[@"max"]];
        rating.min = [self int64FromJsonData:dic[@"min"]];
        rating.numRaters = [self int64FromJsonData:dic[@"numRaters"]];
        rating.average = [self stringFromJsonData:dic[@"averate"]];
    }
    return nil;
}

- (NSSet <LCBookAuthor *>*)authorsFromJsonData:(id)jsonData {
    NSArray *array = [self arrayFromJsonData:jsonData];
    NSManagedObjectContext *moc = self.moc;
    if (array.count > 0 && moc) {
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:array.count];
        for (id data in array) {
            NSString *name = [self stringFromJsonData:data];
            if (name) {
                LCBookAuthor *author = (LCBookAuthor *)[self fetchUniqueModelInCoreDataWithClass:[LCBookAuthor class] key:@"name" value:name];
                if (!author) {
                    author = [[LCBookAuthor alloc] initWithContext:moc];
                    author.name =name;
                }
                [temp addObject:author];
            }
        }
        return [NSSet setWithArray:temp];
    }
    return nil;
}

- (NSSet <LCBookTranslator *>*)translatorsFromJsonData:(id)jsonData {
    NSArray *array = [self arrayFromJsonData:jsonData];
    NSManagedObjectContext *moc = self.moc;
    if (array.count > 0 && moc) {
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:array.count];
        for (id data in array) {
            NSString *name = [self stringFromJsonData:data];
            if (name) {
                LCBookTranslator *translator = (LCBookTranslator *)[self fetchUniqueModelInCoreDataWithClass:[LCBookTranslator class] key:@"name" value:name];
                if (!translator) {
                    translator = [[LCBookTranslator alloc] initWithContext:moc];
                    translator.name =name;
                }
                [temp addObject:translator];
            }
        }
        return [NSSet setWithArray:temp];
    }
    return nil;
}

- (LCBookImage *)bookImageFromJsonData:(id)jsonData {
    NSDictionary *dic = [self dicFromJsonData:jsonData];
    NSManagedObjectContext *moc = self.moc;
    if (dic && moc) {
        LCBookImage *image = [[LCBookImage alloc] initWithContext:moc];
        image.large = [self stringFromJsonData:dic[@"large"]];
        image.small = [self stringFromJsonData:dic[@"small"]];
        image.medium = [self stringFromJsonData:dic[@"medium"]];
        return image;
    }
    return nil;
}

- (LCBookSeries *)bookSeriesFromJsonData:(id)jsonData {
    NSDictionary *dic = [self dicFromJsonData:jsonData];
    NSManagedObjectContext *moc = self.moc;
    NSString *title = [self stringFromJsonData:dic[@"title"]];
    if (title && moc) {
        LCBookSeries *series = (LCBookSeries *)[self fetchUniqueModelInCoreDataWithClass:[LCBookSeries class] key:@"title" value:title];
        if (!series) {
            series = [[LCBookSeries alloc] initWithContext:moc];
            series.title = title;
            series.seriesID = [self stringFromJsonData:dic[@"id"]];
        }
        return series;
    }
    return nil;
}

- (NSSet <LCBookTag *> *)bookTagFromJsonData:(id)jsonData {
    NSArray *array = [self arrayFromJsonData:jsonData];
    NSManagedObjectContext *moc = self.moc;
    if (array.count > 0 && moc) {
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:array.count];
        for (id data in array) {
            NSDictionary *dic = [self dicFromJsonData:data];
            NSString *name = [self stringFromJsonData:dic[@"name"]];
            if (name) {
                LCBookTag *bookTag = (LCBookTag *)[self fetchUniqueModelInCoreDataWithClass:[LCBookTag class] key:@"name" value:name];
                if (!bookTag) {
                    bookTag = [[LCBookTag alloc] initWithContext:moc];
                    bookTag.name =name;
                }
                [temp addObject:bookTag];
            }
        }
        return [NSSet setWithArray:temp];
    }
    return nil;
}

- (NSManagedObjectModel *)fetchUniqueModelInCoreDataWithClass:(Class)cls key:(NSString *)key value:(NSString *)value {
    if ([cls isKindOfClass:[NSManagedObjectModel class]] && self.moc) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(cls)];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%@ = %@", key, value];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:key ascending:YES]];
        NSError *error = nil;
        NSArray *result = [self.moc executeFetchRequest:fetchRequest error:&error];
        if (error) {
            NSLog(@"读取coreda发生错误：%@", error);
        }
        if (result.count > 0) {
            return result[0];
        }
    }
    return nil;
}

- (NSDictionary *)dicFromJsonData:(id)jsonData {
    if (jsonData && [jsonData isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)jsonData;
    }
    return nil;
}

- (NSArray *)arrayFromJsonData:(id)jsonData {
    if (jsonData && [jsonData isKindOfClass:[NSArray class]]) {
        return (NSArray *)jsonData;
    }
    return nil;
}

- (int64_t)int64FromJsonData:(id)jsondData {
    if (jsondData && [jsondData isKindOfClass:[NSNumber class]]) {
        NSNumber *num = (NSNumber *)jsondData;
        return [num longLongValue];
    }
    return 0;
}

- (NSString *)stringFromJsonData:(id)jsonData {
    if (jsonData && [jsonData isKindOfClass:[NSString class]]) {
        return (NSString *)jsonData;
    }
    return nil;
}

@end
