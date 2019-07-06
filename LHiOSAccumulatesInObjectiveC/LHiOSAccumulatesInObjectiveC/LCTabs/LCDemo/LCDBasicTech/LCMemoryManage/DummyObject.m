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
@implementation Dummy15BObject
@end
@implementation Dummy23BObject
@end

@implementation Dummy513BObject
@end

@implementation Dummy1025BObject
@end

@implementation DummyObject

+ (NSArray *)testClasses {
    return @[[NSObject class],
             [Dummy9BObject class],
             [Dummy15BObject class],
             [Dummy23BObject class],
             [Dummy513BObject class],
             [Dummy1025BObject class]];
}

@end
