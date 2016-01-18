//
//  LCAccumulateManager.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/16.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import "LCAccumulateManager.h"

#import "LCUtilities.h"

@interface LCAccumulateManager ()

@property (nonatomic, strong) NSString *fileName;

@end

@implementation LCAccumulateManager

- (instancetype)initWithPlistFileName:(NSString *)fileName
{
    if (self = [super init]) {
        self.fileName = fileName;
        [self loadAccumulatesFromPlistFile];
    }
    return self;
}

- (void)loadAccumulatesFromPlistFile
{
    self.accumulates = [LCUtilities loadAccumulatesFromPlistWithPlistFileName:self.fileName];
}

@end



