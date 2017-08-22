#include <time.h>
#include <stdio.h>



#include "combine1.h"

static const long kLENGTH = 100;

void calculate();

/**
 小结：本代码来自《CSAPP》第五章：优化程序性能，通过以下若干步骤，逐步优化：
 1.消除循环的低效率：通过代码移动（code motion）将循环内部所做的事情尽可能的少；
 2.发现隐藏的渐进低效率的地方（asymptotic inefficiency）改进之；
 3.减少过程调用；
 4.消除不必要的内存引用；
 5.理解现有CPU的基础上，优化代码，使之在CPU流水中更顺畅；
 6.循环展开；
 7.多个累积变量（充分利用现代CPU多个功能单元的特性，缩小流水间隔）；
 8.重新结合变换；
 
 @return 0
 */
int main (int argc, char *argv[]) {
    double start, end, cost;
    time_t t_start, t_end;
    start = clock();
    calculate();
    end = clock();
    cost = end - start;
    freopen("result.txt", "w", stdout);//输出重定向，输出数据将保存在result.txt文件中
    if (argc > 1) {
        printf("输入参数个数：%d, 参数内容%s", argc - 1, argv[0]);
    }
    printf("    程序执行时间为：%lf\n", cost);
    fclose(stdout);
    return 0;
}

void calculate() {
    vec_ptr vector = new_vec(kLENGTH);
    data_t dest;
    combine1(vector, &dest);
    printf("\n执行计算结果是%ld\n\n", dest);
}
