#include "csapp.h"

int main () {
    printf("下面开始调用execuve执行另外一个a.out");//运行发现这段代码也没打印出来， 嚓
    execve("a.out", NULL, NULL);
    printf("这段代码绝不会执行");
    return 0;
}
