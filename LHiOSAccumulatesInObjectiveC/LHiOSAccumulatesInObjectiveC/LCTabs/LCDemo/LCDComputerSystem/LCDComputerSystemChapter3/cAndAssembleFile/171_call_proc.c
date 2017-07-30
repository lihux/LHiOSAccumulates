void proc (long p1, long *p2, int p3, int *p4);

long call_proc() {
    long x1 = 1;
    int x2 = 2;
    proc(x1, &x1, x2, &x2);
    return (x1 +x2);
}
