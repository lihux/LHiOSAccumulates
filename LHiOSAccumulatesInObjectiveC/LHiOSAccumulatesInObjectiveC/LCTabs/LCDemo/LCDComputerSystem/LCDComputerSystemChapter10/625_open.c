#include "../csapp.h"

//输出为3，因为0/1/2是标准输入、输出、错误的系统定义好的描述符，fd1本来使用了3，
//但是后面它有立即关闭了，3又重新回到描述符池中，所以fd2使用的还是3！！
int main() {
    int fd1, fd2;
    fd1 = open("foo.txt", O_RDWR, O_CREAT);
    close(fd1);
    fd2 = open ("baz.txt", O_RDWR, O_CREAT);
    printf("fd2 = %d\n", fd2);
    exit(0);
}
