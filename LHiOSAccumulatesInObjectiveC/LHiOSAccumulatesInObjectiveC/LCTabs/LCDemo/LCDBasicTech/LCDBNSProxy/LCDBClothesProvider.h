//
//  LCDBClothesProvider.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/9/14.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, LCDBClothesSize){
    LCDBClothesSizeSmall = 0,
    LCDBClothesSizeMedium,
    LCDBClothesSizeLarge
};

@protocol LCDBClothesProviderProtocol <NSObject>

- (NSString *)purchaseClothesWithSize:(LCDBClothesSize )size;

@end

@interface LCDBClothesProvider : NSObject

@end

