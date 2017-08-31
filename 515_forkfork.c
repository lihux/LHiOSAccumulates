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
    printf("xx当前进程的ID为：%d   \n", getpid());//该条语句运行了2次（2个进程上）
    pid = fork();
    printf("yy当前进程的ID为：%d   \n", getpid());//该条语句运行了4次（4个进程上）
    exit(0);
}

/*
 实际运行结果：
 xx当前进程的ID为：8107
 xx当前进程的ID为：8108
 yy当前进程的ID为：8107
 yy当前进程的ID为：8109
 yy当前进程的ID为：8108
 yy当前进程的ID为：8110
 
 */

