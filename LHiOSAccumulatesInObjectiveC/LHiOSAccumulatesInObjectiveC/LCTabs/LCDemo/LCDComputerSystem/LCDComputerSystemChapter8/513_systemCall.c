#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>

int main () {
    printf("%d\n", getpid());
    return 0;
}
