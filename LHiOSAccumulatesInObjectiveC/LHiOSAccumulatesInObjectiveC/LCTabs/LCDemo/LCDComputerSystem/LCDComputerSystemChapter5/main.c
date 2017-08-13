#include <time.h>
#include <stdio.h>

int main () {
    double start, end, cost;
    time_t t_start, t_end;
    start = clock();
    t_start = time(NULL);
    float j = 432432;
    for (int i = 0; i < 100000000; i ++) {
        j /= 1.109;
    }
    end = clock();
    t_end = time(NULL);
    cost = end - start;
    printf("占用的CPU时间是：%f, j = %f", cost, j);
    printf("占用的时间是：%f", difftime(t_end, t_start));
}
