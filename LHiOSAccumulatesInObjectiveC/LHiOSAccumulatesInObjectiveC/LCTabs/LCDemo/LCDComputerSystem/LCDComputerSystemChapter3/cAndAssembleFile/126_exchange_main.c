long exchange (long *src, long dst) {
    long temp = *src;
    *src = dst;
    return temp;
}

int main () {
    long a = 4;
    long b = exchange(&a, 3);
    return a + b;
}
