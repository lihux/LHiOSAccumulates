#include "csapp.h"

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("请输入文件名：\n");
        exit(1);
    }
    int fd = open(argv[1], O_RDONLY);
    if (fd == -1) {
        printf("读取文件%s失败\n", argv[1]);
        exit(1);
    }
    printf("读取文件%s成功\n", argv[1]);
    exit(0);
}
