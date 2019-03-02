//
//  LCDParent.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2019/2/28.
//  Copyright © 2019年 Lihux. All rights reserved.
//

#import "LCDParent.h"

#import "LCDSon.h"

int myAtoi(char* str) {
    int length = strlen(str), index = 0;
    
    if (length == 0) return 0;
    
    if (length == 1) return (str[0]-'0' >= 0 && str[0]-'0' <= 9 ) ? str[0] - '0' : 0;
    
    while (str[index] == ' ' && index < length - 1) {
        index++;
    }
    
    bool isnegative = false;
    if (str[index] == '-') {
        index++;
        isnegative = true;
    } else if (str[index] == '+') {
        index ++;
    }
    
    unsigned int result = 0;
    unsigned int max = (unsigned int)(0x100000000 / 2);
    unsigned int a = max / 10, b = max % 10;
    max = isnegative ? max : max-1;
    
    while (index < length && result < max) {
        int value = str[index++] - '0';
        if (value < 0 || value > 9) {
            return result * (isnegative ? -1 : 1);
        }
        
        if (result < a || (result == a && value <= b)) {
            result = (result * 10) + value;
        } else {
            return isnegative ? -max : max;
        }
    }
    
    result = result < max ? result : max;
    return result * (isnegative ? -1 : 1);
}

@implementation LCDParent {
//    NSString *_city;//和synthesize二选一
}

@synthesize city = _city;

- (instancetype)initWithCity:(NSString *)city {
    if (self = [super init]) {
        _city = city;
        NSLog(@"%@:%p", NSStringFromClass([self class]), self);
        NSLog(@"%@", NSStringFromClass([super class]));
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        myAtoi("4193 with words");
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
        anInvocation.selector = NSSelectorFromString(@"sleep");//可以重复调用，微调一下内容即可，666老铁
        [anInvocation invokeWithTarget:son];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

@end
