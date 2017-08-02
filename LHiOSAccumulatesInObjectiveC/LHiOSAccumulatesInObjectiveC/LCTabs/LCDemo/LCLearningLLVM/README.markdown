http://clang.llvm.org/get_started.html

//The 'clang' driver is designed to work as closely to GCC as possible to maximize portability. The only major difference between the two is that Clang defaults to gnu99 mode while GCC defaults to gnu89 mode. If you see weird link-time errors relating to inline functions, try passing -std=gnu89 to clang.
$ clang t.c

使用命令clang ~/t.c -S -emit-llvm -o - 生成IR
