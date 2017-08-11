//汇编语言显示：编译器总是以最坏的情况考虑事情，这里无论以什么优先级进行优化，都不会对f()的
//四次调用进行优化

inline long f();

long func1() {
    return f() + f() + f() + f();
}

long func2() {
    return 4 * f();
}

long counter  = 0;
inline long f() {
    return counter ++;
}
