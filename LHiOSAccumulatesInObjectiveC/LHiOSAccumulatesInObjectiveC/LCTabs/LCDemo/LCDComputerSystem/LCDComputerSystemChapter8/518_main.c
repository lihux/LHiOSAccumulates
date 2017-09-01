#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/wait.h>

int main() {
    if (fork() == 0) {
        printf("a");
        fflush(stdout);
    } else {
        printf("b");
        fflush(stdout);
        waitpid(-1, NULL, 0);
    }
    printf("c");
    fflush(stdout);
    exit(0);
}

/*
 实际运行结果：bacc
 但这道题的全部结果还可能有：
 acbc
 abcc
 */
