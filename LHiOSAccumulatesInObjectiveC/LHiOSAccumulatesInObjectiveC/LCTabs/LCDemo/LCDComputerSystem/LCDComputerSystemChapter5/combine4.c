//
//  combine1.c
//  CSAPP_ch5
//
//  Created by lihui on 2017/8/18.
//

#include "combine1.h"

char* combine1(vec_ptr v, data_t *dest) {
    long i;
    
    data_t acc = IDENT;
    long length = vec_length(v);
    data_t *data = get_vec_start(v);
    
    for (i = 0; i < length; i++) {
        data_t val;
        acc = acc OP data[i];
    }
    *dest = acc;
    return "通过累计变量优化循环中每次都要往内存中写数据：combine4";
}

