#include <time.h>
#include <stdio.h>

int main () {
    double start, end, cost;
    start = clock();
    int j = 0;
    for (int i = 0; i < 1000; i ++) {
        j ++;
    }
    end = clock();
    cost = end - start;
    printf("睡你一秒占用的CPU时间是：%f", cost);
}
