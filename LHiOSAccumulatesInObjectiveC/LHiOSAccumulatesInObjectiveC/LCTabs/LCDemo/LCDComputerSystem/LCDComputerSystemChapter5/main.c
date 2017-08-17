#include <time.h>
#include <stdio.h>

#include "combine1.h"

static const long kLENGTH = 12345;

void calculate();

int main () {
    double start, end, cost;
    time_t t_start, t_end;
    start = clock();
    calculate();
    end = clock();
    cost = end - start;
    printf("%lf", cost);
}

void calculate() {
    vec_ptr vector = new_vec(kLENGTH);
    data_t dest;
    combine1(vector, &dest);
    printf("%ld", dest);
}
