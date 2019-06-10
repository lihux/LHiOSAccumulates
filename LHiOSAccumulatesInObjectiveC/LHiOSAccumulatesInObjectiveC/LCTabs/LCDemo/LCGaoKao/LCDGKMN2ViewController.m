//
//  LCDGKMN2ViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2019/4/29.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "LCDGKMN2ViewController.h"

#import <sys/unistd.h>

id _Nullable origin_objc_msgSend(id _Nullable self, SEL _Nonnull op, ...);

id _Nullable lihux_objc_msgSend(id _Nullable self, SEL _Nonnull op, ...) {
    NSLog(@"我是hook的objc_msgSend方法里面的调用:[%@ %@]", self, NSStringFromSelector(op));
    return self;
}

@implementation LCDGKMN2ViewController

#pragma mark - override
- (NSDictionary *)buildDictionaryData {
    return @{@"检查GCD主-子-主线程切换的执行顺序": @"checkGCDFlow1",
             @"检查GCD子-主-子线程切换的执行顺序": @"checkGCDFlow2",
             @"检查当前系统C指针类型": @"checkPointerType",
             @"发现GCD源码中一个故意导致crash的函数，调用一下": @"crashNow",
             @"hook住objc_msgSend()": @"hookMsgSend",
             @"使用系统提供的getpagesize方法获取page size": @"getPageSize",
             };
}

- (BOOL)isShowLogReverse {
    return NO;
}

- (BOOL)isShowSegment {
    return NO;
}
//struct dispatch_queue_s {
//    const struct dispatch_queue_vtable_s *do_vtable;
//    struct dispatch_queue_s *volatile do_next;
//    unsigned int do_ref_cnt;
//    unsigned int do_xref_cnt;
//    unsigned int do_suspend_cnt;
//    struct dispatch_queue_s *do_targetq;
//    void *do_ctxt;
//    void *do_finalizer;
//    uint32_t volatile dq_running;
//    uint32_t dq_width;
//    struct dispatch_object_s *volatile dq_items_tail;
//    struct dispatch_object_s *volatile dq_items_head;
//    unsigned long dq_serialnum;
//    dispatch_queue_t dq_specific_q;
//    char dq_label[64];
//    char _dq_pad[32];
//}
//struct dispatch_queue_vtable_s {
//    unsigned long const do_type;
//    const char const do_kind;
//    size_t (*const do_debug)(struct dispatch_queue_s , char , size_t);
//    struct dispatch_queue_s (const do_invoke)(struct dispatch_queue_s );
//    bool (const do_probe)(struct dispatch_queue_s );
//    void (const do_dispose)(struct dispatch_queue_s )
//};

#pragma mark - 具体调用
#define DISPATCH_DEBUG 1
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

- (void)crashNow {
    dispatch_atfork_child();//这个函数故意让它crash的，因为它把里面的链表指针都指向了0x100
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"这段代码不会执行就crash了");
    });
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

- (void)hookMsgSend {
    
}

- (void)getPageSize {
    int pageSize = getpagesize();
    [self log:[NSString stringWithFormat:@"获取到当前的pageSize为：%d bytes，也即 %dKB", pageSize, pageSize / 1024]];
}

@end
