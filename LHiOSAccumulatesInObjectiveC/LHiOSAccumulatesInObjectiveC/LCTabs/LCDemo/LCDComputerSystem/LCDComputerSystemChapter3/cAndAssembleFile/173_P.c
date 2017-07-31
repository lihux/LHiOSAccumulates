long Q(long x);

long P(long x, long y) {
    long u = Q(y);
    long v = Q(x);
    return u + v;
}
