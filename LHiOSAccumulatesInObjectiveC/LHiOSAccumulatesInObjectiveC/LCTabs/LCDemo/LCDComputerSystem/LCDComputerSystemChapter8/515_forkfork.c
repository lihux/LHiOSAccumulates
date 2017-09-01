#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
/*
 结果分析：
 1翻2，2翻4，进程最终是4个，so，结果打印了6条
 
 */
int main() {
    pid_t pid;
    pid = fork();
    int i = 1;
    printf("xx当前进程的ID为：%d   fork返回值为：%d, ++i 的值为：%d\n", getpid(), pid, ++i);//该条语句运行了2次（2个进程上）
    pid = fork();
    printf("yy当前进程的ID为：%d   fork返回值为：%d,  ++i 的值为：%d\n", getpid(), pid, ++i);//该条语句运行了4次（4个进程上）
    exit(0);
}

/*
 实际运行结果：
 xx当前进程的ID为：10314   fork返回值为：10315, ++i 的值为：2
 yy当前进程的ID为：10314   fork返回值为：10316,  ++i 的值为：3
 xx当前进程的ID为：10315   fork返回值为：0, ++i 的值为：2
 yy当前进程的ID为：10316   fork返回值为：0,  ++i 的值为：3
 yy当前进程的ID为：10315   fork返回值为：10317,  ++i 的值为：3
 yy当前进程的ID为：10317   fork返回值为：0,  ++i 的值为：3
 
 结果分析：
 三个不同非0的fork返回值说明新建了三个子进程，且是在父进程中打印出的log；
 三个为0的fork返回值是在三个子进程中打出来的log
 fork出来的子进程会得到父进程用户级虚拟地址空间相同的、但是独立的一份副本，包括代码和数据段、堆、共享库
 以及用户栈。我猜测应该是使用了内存的COW策略（copy on write），一旦有对原数据的更改，就会copy一份
 出来，这样保证了互补影响，比如上面打印出来的++i的值就说明了这一点：共享但又独立！！！
 在父进程和子进程各返回一次，这也是fork方法有趣（令人迷惑）的地方
 */

