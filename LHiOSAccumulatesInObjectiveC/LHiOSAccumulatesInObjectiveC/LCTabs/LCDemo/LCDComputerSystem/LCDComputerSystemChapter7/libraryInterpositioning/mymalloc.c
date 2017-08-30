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

/*
 Link time lib interpositioning
 #Compile:
 gcc -DLINKTIME -c mymalloc.c
 gcc -c int.c
 gcc -Wl,--warp,malloc -Wl,--warp,free -o intl int.o mymalloc.o
 
 #Run:
 ./intc
 */

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

#ifdef RUNTIME

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>

/*
 Runtime time lib interpositioning
 #Compile:
 gcc -DRUNTIME shared -fpic -o mymalloc.so mymalloc.c -ldl
 gcc -o intr int.c
 
 #Run:
 LD_PREOLAD="./MYMALLOC.SO" ./intc
 */

/*malloc wrapper function*/
void *mymalloc(size_t size) {
    void *(*mallocp)(size_t size);
    char *error;
    mallocp = dlsym(RTLD_NEXT, "malloc");/* Get address of libc malloc */
    if ((error = dlerror()) != NULL) {
        fputs(error, stderr);
        exit(1);
    }
    char *ptr = mallocp(size);
    printf("lihux添加的打桩方法mymalloc中调用：malloc(%d) = %p\n", (int)size, ptr);
    return ptr;
}

void myfree(void *ptr) {
    void (*freep)(void *) = NULL;
    char *error;
    if (!ptr) {
        return;
    }
    freep = dlsym(RTLD_NEXT, "free");/* Get address of libc free */
    if ((error = dlerror()) != NULL) {
        fputs(error, stderr);
        exit(1);
    }
    free(ptr);
    printf("lihux添加的打桩方法myfree中调用：free (%p)\n", ptr);
}

#endif

