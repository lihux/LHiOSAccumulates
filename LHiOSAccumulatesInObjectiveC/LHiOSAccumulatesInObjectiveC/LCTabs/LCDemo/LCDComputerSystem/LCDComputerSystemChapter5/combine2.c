//
//  combine1.c
//  CSAPP_ch5
//
//  Created by lihui on 2017/8/18.
//

#include "combine1.h"

char* combine1(vec_ptr v, data_t *dest) {
    long i;
    
    *dest = IDENT;
    long length = vec_length(v);
    for (i = 0; i < length; i++) {
        data_t val;
        get_vec_element(v, i, &val);
        *dest = *dest OP val;
    }
    return "combine2优化了for循环中使用的length,循环外计算出来";
}

