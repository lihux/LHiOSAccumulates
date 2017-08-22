//
//  combine1.c
//  CSAPP_ch5
//
//  Created by lihui on 2017/8/18.
//

#include "combine1.h"

char* combine1(vec_ptr v, data_t *dest) {
    long i;
    
    data_t acc0 = IDENT;
    data_t acc1 = IDENT;
    long length = vec_length(v);
    long limit = length - 1;
    data_t *data = get_vec_start(v);
    
    for (i = 0; i < limit; i+=2) {
        acc0 = acc0 OP (data[i] OP data[i+1]);
        acc1 = acc1 OP (data[i] OP data[i+1]);
    }
    for (; i < length; i ++) {
        acc0 = acc0 OP data[i];
    }
    *dest = acc0 OP acc1;
    return "二次循环展开：combine5";
}

