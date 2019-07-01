//
//  LCAlgorithmTools.c
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2019/7/1.
//  Copyright © 2019 Lihux. All rights reserved.
//

#include "LCAlgorithmTools.h"

void swap(int *a, int *b) {
    if (*a > *b) {
        int temp = *a;
        *a = *b;
        *b = temp;
    }
}

void printArray(int *nums, int n, const char *s) {
    if (s) {
        printf("%s", s);
    }
    printf("\n[ ");
    for (int i = 0; i < n; i ++) {
        printf("%d ", nums[i]);
    }
    printf("]\n");
}
