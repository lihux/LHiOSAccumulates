
//
//  LCDAddressSanitizerTest.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2019/4/25.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "LCDAddressSanitizerTest.h"

@implementation LCDAddressSanitizerTest

//下面这个方法故意制造了一个访问已经释放的堆内存的错误，然后在编译的时候在schema中打开
//address sanitizer即可捕获这个异常的位置
- (void)addressSantizerTest {
    unsigned int size = 8; // size = 8，比较容易命中。
    void *buffer = malloc(size);
    snprintf(buffer, size, "Hello!");
    NSLog(@"%p, %s", buffer, buffer);
    free(buffer);
    
    // memory history
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 在未来的某个时机，改变该指针的值
        snprintf(buffer, size, "Hello!");
    });
}

@end
