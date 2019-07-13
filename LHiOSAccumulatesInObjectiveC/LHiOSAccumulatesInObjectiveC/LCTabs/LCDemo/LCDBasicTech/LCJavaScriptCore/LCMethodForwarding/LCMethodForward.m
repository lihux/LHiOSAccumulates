//
//  LCMethodForward.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2019/7/13.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "LCMethodForward.h"

#import <objc/runtime.h>

void dog(id self, SEL _cmd) {
    printf("我是一条狗");
}

@implementation LCMethodForward

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if ([NSStringFromSelector(sel) isEqualToString:@"dog"]) {
        class_addMethod([self class], sel, (IMP)dog, "v@:");
        return YES;
    }
    return NO;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) isEqualToString:@"cat"]) {
        return nil;
    }
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:"v@:"];
    return signature;
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"我的老天爷啊：%s", __FUNCTION__);
}

@end
