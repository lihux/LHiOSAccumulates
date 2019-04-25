//
//  main.m
//  virtualMemearyLearning
//
//  Created by 李辉 on 2019/4/25.
//  Copyright © 2019 LH. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LHTinyDog.h"

int main(int argc, const char * argv[]) {
    NSMutableSet *set = [NSMutableSet new];
    int count = 10000;
    @autoreleasepool {
        for (int i = 0; i < count; i++) {
            [set addObject:[LHTinyDog new]];
        }
        sleep(100000);
    }
    return 0;
}
