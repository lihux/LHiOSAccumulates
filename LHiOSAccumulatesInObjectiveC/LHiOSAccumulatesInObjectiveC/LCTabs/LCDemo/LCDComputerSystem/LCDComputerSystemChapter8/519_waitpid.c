#include "csapp.h"

#define N 20
int main() {
    int status, i;
    pid_t pid;
    //创建N个子进程
    for (i = 0; i < N; i++) {
        if ((pid = fork()) == 0) {
            exit(100 + i);
        }
    }
    
    while ((pid = waitpid(-1, &status, 0)) > 0) {
        if (WIFEXITED(status)) {
            printf("子进程%d 正常终止，结束返回值（exist)是：%d\n", pid, WEXITSTATUS(status));
        }
    }
    
    exit(0);
}

/*
 实际运行结果：bacc
 但这道题的全部结果还可能有：
 acbc
 abcc
 */

