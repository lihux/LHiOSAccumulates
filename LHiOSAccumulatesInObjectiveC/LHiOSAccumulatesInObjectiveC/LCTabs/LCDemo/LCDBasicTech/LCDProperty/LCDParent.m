//
//  LCDParent.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2019/2/28.
//  Copyright © 2019年 Lihux. All rights reserved.
//

#import "LCDParent.h"

#import "LCDSon.h"

@implementation LCDParent {
//    NSString *_city;//和synthesize二选一
}

@synthesize city = _city;

- (instancetype)initWithCity:(NSString *)city {
    if (self = [super init]) {
        _city = city;
    }
    return self;
}

- (NSString *)city {
    NSLog(@"搞什么啊？%@", _city);
    return _city;
}

- (void)setCity:(NSString *)city {
    _city = city;
}

//1.消息决议 Method Resolution
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    return NO;
}

//2.快速发送 Fast Forwarding
- (id)forwardingTargetForSelector:(SEL)aSelector {
    return nil;
}

//3.正常发送 Normal Forwarding
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) isEqualToString:@"eatFood"]) {
        NSMethodSignature *s = [NSMethodSignature signatureWithObjCTypes:"v@:"];
        return s;
    }
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL aSelector = anInvocation.selector;
    LCDSon *son = [LCDSon new];//老子干不动了，让儿子来干，😁
    if ([son respondsToSelector:aSelector]) {
        [anInvocation invokeWithTarget:son];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

@end
