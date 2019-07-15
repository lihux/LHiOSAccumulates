//
//  LCInvocationViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2019/7/15.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "LCInvocationViewController.h"

@interface LCInvocationViewController ()

@end

@implementation LCInvocationViewController

-(void)test {
    [self test1];
}

- (void)test1 {
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(giveMeADog:age:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:@selector(giveMeADog:age:)];
    NSString *name = @"dog";
    NSInteger age = 3;
    [invocation setArgument:(__bridge void * _Nonnull)(name) atIndex:2];
    [invocation setArgument:&age atIndex:3];
    [invocation invoke];
}

- (void)test2 {
    
}

- (NSString *)giveMeADog:(NSString *)name age:(NSInteger)age {
    return [NSString stringWithFormat:@"我抱养了一只小狗，它的名字叫:%@,它今年%zd岁了^_^", name, age];
}

@end
