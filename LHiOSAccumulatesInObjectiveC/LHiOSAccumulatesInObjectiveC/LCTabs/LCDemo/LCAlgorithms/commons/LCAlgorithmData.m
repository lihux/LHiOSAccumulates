//
//  LCAlgorithmData.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2019/5/28.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "LCAlgorithmData.h"

@interface LCAlgorithmData ()

@property (nonatomic, copy) NSString *originalString;

@end

@implementation LCAlgorithmData

- (instancetype)initWithString:(NSString *)string {
    self = [super init];
    self.originalString = string;
    return self;
}

- (int *_Nullable *_Nullable)intInputs {
    return NULL;
}

- (char *_Nullable *_Nullable)charInputs {
    return NULL;
}

@end
