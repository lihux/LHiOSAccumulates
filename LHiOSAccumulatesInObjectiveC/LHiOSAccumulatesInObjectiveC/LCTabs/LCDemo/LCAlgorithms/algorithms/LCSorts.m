//
//  LCSorts.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2019/7/1.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "LCSorts.h"

#include "LCAlgorithmTools.h"

/********************************************************************/
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

/********************************************************************/
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

/********************************************************************/
//3. 插入排序，算法时间复杂度O(n^2),空间复杂度：O(1), 属于比较排序，稳定排序算法
void insertSort(int *nums, int n) {
    printArray(nums, n, "\n开始插入排序：\n");

    for (int i = 1; i < n; i++) {
        int j = i;
        int temp = nums[i];
        while (j > 0 && nums[j-1] > temp) {
            nums[j] = nums[j-1];
            j--;
        }
        nums[j] = temp;
    }
    printArray(nums, n, "\n排序之后结果是：\n");
}

void testBubbleSort() {
    int a[] = {8,9,7,6,5,4,3,2,1};
//    bubbleSort(a, 9);
//    selectSort(a, 9);
    insertSort(a, 9);
}

@implementation LCSorts

- (void)beginTests {
    testBubbleSort();
}

@end


