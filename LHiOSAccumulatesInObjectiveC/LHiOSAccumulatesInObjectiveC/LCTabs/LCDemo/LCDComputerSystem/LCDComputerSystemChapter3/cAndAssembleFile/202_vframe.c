long vframe(long n, long idx, long *q) {
    long i;
    long *p[n];
    p[0] = &i;
    for (i = 1; i < n; i ++) {
        p[i] = q;
    }
    return *p[idx];
}
