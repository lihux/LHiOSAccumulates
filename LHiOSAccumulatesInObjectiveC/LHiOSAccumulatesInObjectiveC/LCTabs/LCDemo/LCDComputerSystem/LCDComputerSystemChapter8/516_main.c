#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

int main() {
    int x = 1;
    if (fork() == 0) {
        printf("p1: x = %d\n", ++x);
    }
    printf("p2: x = %d\n", --x);
    exit(0);
}

/*
 实际运行结果：
 p2: x = 0
 p1: x = 2
 p2: x = 1
 */

