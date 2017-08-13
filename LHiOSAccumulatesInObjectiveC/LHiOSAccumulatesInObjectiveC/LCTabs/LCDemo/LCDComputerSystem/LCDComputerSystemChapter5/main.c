#include <time.h>
#include <stdio.h>

#include "vec.h"

static const long kLENGTH = 1234;

void calculate();

int main () {
    double start, end, cost;
    time_t t_start, t_end;
    start = clock();
    calculate();
    end = clock();
    cost = end - start;
    printf("%f", cost);
}

void calculate() {
    vec_ptr vector = new_vec(kLENGTH);
}
