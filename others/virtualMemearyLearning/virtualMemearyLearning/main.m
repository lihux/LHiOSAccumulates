//
//  main.m
//  virtualMemearyLearning
//
//  Created by 李辉 on 2019/4/25.
//  Copyright © 2019 LH. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LHTinyDog.h"

#import <sys/malloc.h>

#define kOneK 1024
#define KSpace(n) (n * kOneK)
#define MSpace(n) (n * kOneK * kOneK)

void mallocLearning() {
    int length = 1024 * 4;
    void *memBlock = malloc(length * length);
    memset(memBlock, 0, length * length);
    sleep(100000);
}

void bigNSObject() {
    NSMutableSet *set = [NSMutableSet new];
    int count = 10000;
    @autoreleasepool {
        for (int i = 0; i < count; i++) {
            [set addObject:[LHTinyDog new]];
        }
        sleep(100000);
    }
}

void allocCustomObjectsWithCustomMallocZone() {
    malloc_zone_t *customZone = malloc_create_zone(1024, 0);
    malloc_set_zone_name(customZone, "custom malloc zone");
    for (int i = 0; i < 1000; ++i) {
        malloc_zone_malloc(customZone, 300 * 4096);
    }
    sleep(100000);
}

void create100VM() {
    vm_address_t p;
    vm_size_t size = MSpace(100);
    vm_allocate((vm_map_t)mach_task_self(), &p, size, VM_MAKE_TAG(31415926) | VM_FLAGS_ANYWHERE);
    sleep(100000);
}

int main(int argc, const char * argv[]) {
//    mallocLearning();
//    bigNSObject();
    allocCustomObjectsWithCustomMallocZone();
//    create100VM();
    return 0;
}
