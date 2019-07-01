//
//  LCSorts.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2019/7/1.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "LCSorts.h"

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

//1. 冒泡排序，算法时间复杂度O(n^2),空间复杂度：O(1), 属于比较排序，稳定排序算法
void bubbleSort(int *nums, int n) {
    printArray(nums, n, "\n开始冒泡排序：\n");
    
    for (int i = 0; i < n-1; i ++) {
        for (int j = 0; j < n - i - 1; j++) {
            if (nums[j] > nums[j+1]) {
                swap(nums+j, nums+j+1);
            }
        }
    }
    
    printArray(nums, n, "\n排序之后结果是：\n");
}

//2. 选择排序，算法时间复杂度O(n^2),空间复杂度：O(1), 属于比较排序，稳定排序算法
void selectSort(int *nums, int n) {
    printArray(nums, n, "\n开始选择排序：\n");

    for (int i = 0; i < n; i++) {
        int idx = i;
        for (int j = i+1; j < n; j++) {
            idx = nums[idx] > nums[j] ? j : idx;
        }
        swap(nums+i, nums+idx);
    }
    
    printArray(nums, n, "\n排序之后结果是：\n");
}

void testBubbleSort() {
    int a[] = {8,9,7,6,5,4,3,2,1};
//    bubbleSort(a, 9);
    selectSort(a, 9);
}

@implementation LCSorts

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self beginTests];
    }
    return self;
}

- (void)beginTests {
    testBubbleSort();
}

@end


