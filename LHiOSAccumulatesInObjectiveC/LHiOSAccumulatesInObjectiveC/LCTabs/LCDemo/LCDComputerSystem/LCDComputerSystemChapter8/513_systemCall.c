#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>

int main () {
    printf("当前进程ID：%d\n", getpid());
    printf("当前进程的父进程ID：%d\n", getppid());
    return 0;
}
