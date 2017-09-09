#include "../csapp.h"

int main() {
    int fd1, fd2;
    char c1, c2;
    fd1 = open("dog.txt", O_RDONLY, 1);
    fd2 = open("dog.txt", O_RDWR, 1);
    read(fd1, &c1, 1);
    read(fd2, &c2, 1);
    dup2(fd2, 1);
    printf("fd1 = %d  fd2 = %d c1 = %c   c2 = %c\n", fd1, fd2, c1, c2);
    exit(0);
}
