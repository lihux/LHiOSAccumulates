#include <stdio.h>
//lihux added:llvm-gcc 编译的时候会强制插入金丝雀（canary)，没有-fno-stack-protector选项
/*Implementation of library function gets() */
//char gets(char *s) {
//    int c;
//    char *dest = s;
//    while ((c = getchar() != '\n' && c != EOF) {
//        *dest++ = c;
//    }
//   if (c == EOF && dest == s) return NULL;
//   *dest ++ = '\0';
//   return s;
//}

/* Read input line and write it back */
void echo() {
    char buf[8];
    gets(buf);
    puts(buf);
}
