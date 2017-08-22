//
//  combine1.c
//  CSAPP_ch5
//
//  Created by lihui on 2017/8/18.
//

#include "combine1.h"

void combine1(vec_ptr v, data_t *dest) {
    long i;
    
    data_t acc = IDENT;
    long length = vec_length(v);
    long limit = length - 1;
    data_t *data = get_vec_start(v);
    
    for (i = 0; i < limit; i+=2) {
        acc = acc OP (data[i] OP data[i+1]);
    }
    for (; i < length; i ++) {
        acc = acc OP data[i];
    }
    *dest = acc;
    return "重新结合变换，优化流水线效率：combine7";
}

