#ifdef COMPILETIME

#include <stdio.h>
#include "malloc.h"

/*
 Compile time lib interpositioning
 #Compile:
 gcc -DCOMPILETIME -c mymalloc.c
 gcc -I . -o intc int.c mymalloc.o
 #Run:
 ./intc
 */

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

#ifdef LINKTIME

#include <stdio.h>

/*malloc wrapper function*/
void *__real_malloc(size_t size);
void *__real_free(void *ptr);

void *__wrap_malloc(size_t size) {
    void *ptr = __real_malloc(size);
    printf("lihux添加的打桩方法mymalloc中调用：malloc(%d) = %p\n", (int)size, ptr);
    return ptr;
}

void __wrap_free(void *ptr) {
    __real_free(ptr);
    printf("lihux添加的打桩方法myfree中调用：free (%p)\n", ptr);
}

#endif
