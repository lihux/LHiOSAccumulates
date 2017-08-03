typedef enum {NEG, ZERO, POS, OTHER} range_t;
range_t find_range(float x) {
    int result;
    if (x < 0) {
        result = NEG;
    } else if (x == 0) {
        result = ZERO;
    } else if (x > 0) {
        result = POS;
    } else {
        result = OTHER;
    }
    return result;
}
