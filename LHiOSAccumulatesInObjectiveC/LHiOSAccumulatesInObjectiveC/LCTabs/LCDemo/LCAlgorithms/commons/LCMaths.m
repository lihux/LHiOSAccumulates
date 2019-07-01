//
//  LCMaths.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2019/7/1.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "LCMaths.h"

@implementation LCMaths

- (void)beginTests {
    for (int i = 100; i <1000; i++) {
        int a = i / 100, b = (i % 100) / 10, c = (i % 100) % 10;
        if (i == a * a * a + b * b * b + c * c * c) {
            printf("\n水仙花：%d", i);
        }
    }
}

@end
