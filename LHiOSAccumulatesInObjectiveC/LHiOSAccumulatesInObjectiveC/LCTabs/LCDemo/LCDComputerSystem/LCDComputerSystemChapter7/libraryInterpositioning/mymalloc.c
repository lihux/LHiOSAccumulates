#ifdef COMPILETIME

#include <stdio.h>
#include "malloc.h"

/*malloc wrapper function*/
void *mymalloc(size_t size) {
    void *ptr = malloc(size);
    printf("lihux添加的打桩方法mymalloc中调用：malloc(%d) = %p\n", (int)size, ptr);
    return ptr;
}

void myfree(void *ptr) {
    free(ptr);
    printf("lihux添加的打桩方法myfree中调用：free (%p)\n", ptr);
}

#endif
