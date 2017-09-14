//
//  LCDBDealerProxy.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/9/14.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LCDBBookProvider.h"
#import "LCDBClothesProvider.h"

@interface LCDBDealerProxy : NSProxy <LCDBBookProviderProtocol, LCDBClothesProviderProtocol>

+ (instancetype)dealerInstance;

@end
