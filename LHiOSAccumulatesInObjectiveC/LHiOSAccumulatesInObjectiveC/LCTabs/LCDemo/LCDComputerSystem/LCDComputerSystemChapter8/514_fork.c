#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
/*
 结果分析：
 关键点就在于fork()会被调用一次，但是会返回两次，一次是在父进程中，一次是在子进程中，
 在父进程中返回创建的子进程的真正的PID，在子进程中返回0，所以下面巧妙的通过pid == 0
 来判断是在子进程中
 */
int main() {
    pid_t pid;
    int x = 1;
    pid = fork();
    printf("当前进程的ID为：%d   pid的值为：%d\n", getpid(), pid);
    if (pid == 0) {
        printf("child : x = %d, pid = %d, 父进程的id:%d\n", ++x, getpid(), getppid());
        exit(0);
    }
    printf("parent: x = %d, pid = %d\n", --x, getpid());
    exit(0);
}

/*
 实际运行结果：没看懂，我表示
 当前进程的ID为：9920   pid的值为：9921
 parent: x = 0, pid = 9920
 当前进程的ID为：9921   pid的值为：0
 child : x = 2, pid = 9921, 父进程的id:1
 
*/
