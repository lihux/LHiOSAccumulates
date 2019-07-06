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

@implementation Dummy520BObject
@end

@implementation Dummy1111BObject
@end

@implementation DummyStrIntBObject
@end

@implementation DummyObject

+ (NSArray *)testClasses {
    return @[[NSObject class],
             [Dummy9BObject class],
             [DummyStrIntBObject class],
             [Dummy15BObject class],
             [Dummy520BObject class],
             [Dummy1111BObject class]];
}

@end
