#include "csapp.h"

void sigint_handler(int sig) {
    printf("捕获到信号：%d", sig);
    exit(0);
}

int main() {
    if (signal(SIGINT, sigint_handler) == SIG_ERR) {
        printf("我勒个去，注册自己的信号处理方法的时候遇到了错误");
    }
    pause();
    return 0;
}
