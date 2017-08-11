long f();

long func1() {
    return f() + f() + f() + f();
}

long func2() {
    return 4 * f();
}

long counter  = 0;
long f() {
    return counter ++;
}
