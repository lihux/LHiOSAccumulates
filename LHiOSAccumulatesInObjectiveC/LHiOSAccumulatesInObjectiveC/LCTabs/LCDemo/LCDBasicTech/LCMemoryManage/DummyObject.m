//
//  DummyObject.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2019/7/6.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "DummyObject.h"

@implementation Dummy9BObject
@end
@implementation Dummy10BObject
@end
@implementation Dummy11BObject
@end
@implementation Dummy12BObject
@end
@implementation Dummy15BObject
@end

@implementation Dummy520BObject
@end

@implementation DummyObject

+ (NSArray *)testClasses {
    return @[[NSObject class],
             [Dummy9BObject class],
             [Dummy10BObject class],
             [Dummy11BObject class],
             [Dummy12BObject class],
             [Dummy15BObject class],
             [Dummy520BObject class]];
}

@end
