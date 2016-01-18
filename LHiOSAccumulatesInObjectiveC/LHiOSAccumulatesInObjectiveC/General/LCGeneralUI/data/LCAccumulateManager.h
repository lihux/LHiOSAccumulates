//
//  LCAccumulateManager.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/16.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCAccumulateManager : NSObject

@property (nonatomic, strong) NSArray *accumulates;

- (instancetype)initWithPlistFileName:(NSString *)fileName;

@end
