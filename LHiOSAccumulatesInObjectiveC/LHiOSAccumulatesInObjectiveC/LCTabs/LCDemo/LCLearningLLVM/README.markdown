http://clang.llvm.org/get_started.html

//The 'clang' driver is designed to work as closely to GCC as possible to maximize portability. The only major difference between the two is that Clang defaults to gnu99 mode while GCC defaults to gnu89 mode. If you see weird link-time errors relating to inline functions, try passing -std=gnu89 to clang.
$ clang t.c

使用命令clang ~/t.c -S -emit-llvm -o - 生成IR
使用clang -fomit-frame-pointer -O3 -S -o - t.c >> t_asm_x86.s生成x86机器上的汇编代码
