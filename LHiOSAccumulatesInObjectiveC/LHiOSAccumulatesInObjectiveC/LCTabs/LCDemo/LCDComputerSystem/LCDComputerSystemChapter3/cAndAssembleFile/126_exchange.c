long exchange (long *src, long dst) {
    long temp = *src;
    *src = dst;
    return temp;
}
