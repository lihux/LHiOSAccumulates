#include "csapp.h"

int main() {
    pid_t pid;
    if ((pid = fork()) == 0) {
        printf("子线程ID 为：%d", getpid());
        pause();
        printf("这段代码绝不会被执行\n");
        exit(0);
    }
    printf("子线程ID 为：%d\n", pid);
    kill(pid, SIGKILL);
    exit(0);
}
