void switch_eg(long x, long n, long *dest) {
    long val = x;
    switch (n) {
        case 100:
            val *=13;
            break;
        case 102:
            val += 10;
        case 103:
            val += 11;
            break;
        case 104:
        case 106:
            val *= val;
            break;
            
        default:
            val = 0;
            break;
    }
    *dest = val;
}
