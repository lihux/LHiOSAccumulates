//
//  LCAlgorithmData.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2019/5/28.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCAlgorithmData : NSObject

@property (nonatomic, strong) NSDictionary *inputsAndOutputDic;

- (instancetype)initWithString:(NSString *)string;

- (int *_Nullable *_Nullable)intInputs;

- (char *_Nullable *_Nullable)charInputs;

@end

NS_ASSUME_NONNULL_END
