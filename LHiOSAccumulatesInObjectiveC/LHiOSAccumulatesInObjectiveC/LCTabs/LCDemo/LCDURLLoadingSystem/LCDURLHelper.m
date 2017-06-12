//
//  LCDURLHelper.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/6/10.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCDURLHelper.h"

NSString * const kLCDURLHost = @"http://13.58.220.233:1113/accumulates/v1";

@implementation LCDURLHelper

+ (NSURL *)urlWithPath:(NSString *)path {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kLCDURLHost, path]];
}

@end
