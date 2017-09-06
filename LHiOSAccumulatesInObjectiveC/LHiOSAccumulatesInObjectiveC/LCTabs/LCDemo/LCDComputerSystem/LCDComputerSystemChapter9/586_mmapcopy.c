#include "csapp.h"

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("请输入文件名：\n");
        exit(1);
    }
    char *fileName = argv[1];
    int fd = open(fileName, O_RDONLY);
    if (fd == -1) {
        printf("读取文件%s失败\n", fileName);
        exit(1);
    }
    printf("读取文件%s成功\n", fileName);
    struct stat fileSat;
    fstat(fd, &fileSat);
    int size = fileSat.st_size;
    printf("文件%s的大小是：%d B\n", fileName, size);
    printf("下面开始通过mmap将%s文件内容映射到内存中来，然后再输出到终端\n", fileName);
    char *start = mmap(NULL, size, PROT_READ, MAP_PRIVATE, fd, 0);
    write(1, start, size);
    exit(0);
}
