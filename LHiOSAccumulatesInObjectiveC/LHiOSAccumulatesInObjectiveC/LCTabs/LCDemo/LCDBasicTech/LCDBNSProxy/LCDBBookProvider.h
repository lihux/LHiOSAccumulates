//
//  LCDBBookProvider.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/9/14.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LCDBBookProviderProtocol <NSObject>

- (NSString *)purchaseBookWithTitle:(NSString *)bookTitle;

@end

@interface LCDBBookProvider : NSObject

@end
