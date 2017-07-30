void if_eg(long x, long n, long *dest) {
    long val = x;
    if (n == 100) {
        val *= 13;
    } else if (n == 102) {
        val += 10;
        val += 11;
    } else if (n == 103) {
        val += 11;
    } else if (n == 104 || n == 106) {
        val *= val;
    } else {
        val = 0;
    }
    *dest = val;
}
