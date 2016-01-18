//
//  LCAccumulate.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/16.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import "LCAccumulate.h"

@implementation LCAccumulate

- (instancetype)initWith:(NSString *)title content:(NSString *)content storyboardID:(NSString *)storyboardID
{
    self.title = title;
    self.content = content;
    self.storyboardID = storyboardID;
    return self;
}

@end
