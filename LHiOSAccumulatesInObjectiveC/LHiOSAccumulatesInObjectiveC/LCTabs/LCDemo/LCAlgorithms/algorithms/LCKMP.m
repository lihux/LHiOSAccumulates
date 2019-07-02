//
//  LCKMP.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2019/7/1.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "LCKMP.h"
#include <string.h>

size_t *KMPhelper(const char *target) {
    
    size_t m = strlen(target);
    size_t *nums = malloc(sizeof(int) * m);
    nums[0] = 0;
    for (size_t i = 1; i < m; i++) {
        size_t j = nums[i-1];
        if (nums[j] == nums[i]) {
            nums[i] = nums[i-1] + 1;
        } else {
            j = nums[j];
        }
    }
    return nums;
}

size_t KMP(const char *src, const char *target) {
    size_t n = strlen(src), m = strlen(target);
    if (n < m) {
        return  -1;
    }
    
    size_t *helper = KMPhelper(target);
    size_t i = 0, j = 0;
    while (i < n-m) {
        while (src[i] == target[j] && src[i]) {
            i++;
            j++;
        }
        if (!target[j]) {
            return i - m;
        }
        j = helper[j];
    }
    return -1;
}

@implementation LCKMP

- (void)beginTests {
    
}

@end
