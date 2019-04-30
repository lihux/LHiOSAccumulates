//
//  LCDGKMN2ViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2019/4/29.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "LCDGKMN2ViewController.h"

@implementation LCDGKMN2ViewController

#pragma mark - override
- (NSDictionary *)buildDictionaryData {
    return @{@"检查GCD主-子-主线程切换的执行顺序": @"checkGCDFlow1",
             @"检查GCD子-主-子线程切换的执行顺序": @"checkGCDFlow2",
             @"检查当前系统C指针类型": @"checkPointerType"
             };
}

- (BOOL)isShowLogReverse {
    return NO;
}

- (BOOL)isShowSegment {
    return NO;
}

#pragma mark - 具体调用
- (void)checkGCDFlow1 {
    [self cleanLog];
    printf("1");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        printf("2");
    });
    printf("3");
    [self log:@"主(1)-子(2)-主(3)的执行顺序一定是：132，原因是：dispatch_async(global)，子线程的执行是在...的时候才进行"];
}

- (void)checkGCDFlow2 {
    [self cleanLog];
    printf("1");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        printf("2");
        dispatch_async(dispatch_get_main_queue(), ^{
            printf("3");
        });
        printf("4");
    });
    printf("5");
    [self log:@"主(1)-子(2)-主(3)的执行顺序一定是：15243，原因是：dispatch_async(global)，子线程的执行是在...的时候才进行"];
}

- (void)checkPointerType {
    //https://blog.csdn.net/xanadut/article/details/9864891
    [self log:@"本系统是：__LP64__格式的，下面验证一下"];
    [self log:@"C语言缺少一种增加新的基本数据类型的机制。C程序开发人员为了提供64位寻址和标量运算的能力，需要改变现有的数据类型的定义或映射或添加新的数据类型。C语言标准规定了一套各种数据类型之间的关系，但故意没有定义具体长度。如果不考虑非标准类型的话，三种64位指针模型都可以兼容现有的规则。"];
    [self log:@"LP64选择了折中的方式。它使用8位，16位和32位标量类型（char，short和int）来保证兼容32位系统中数据大小和对齐，使用64位的long型来支持完整的运算能力，以及64位的指针运算。程序中要将指针地址强制转换成标量时必须使用long而不是int型。在64位系统下能正常工作的代码在32为系统中不用做任何修改就能正常编译和运行。这些数据类型是天然的，每个标量类型都比先前的类型要长。"];
    [self log:@"当前系统上的不同基础类型的size分别是："];
    size_t charSize = sizeof(char), shortSize = sizeof(short), intSize = sizeof(int);
    size_t longSize = sizeof(long), llongSize = sizeof(long long), pointerSize = sizeof(int *);
    [self log:[NSString stringWithFormat:@"char:%zd\nshort:%zd\nint:%zd\nlong:%zd\nlong long:%zd\n pointer::%zd\n", charSize, shortSize, intSize, longSize, llongSize, pointerSize]];
}

@end
