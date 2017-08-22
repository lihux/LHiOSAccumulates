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
    data_t *data = get_vec_start(v);
    
    for (i = 0; i < length; i++) {
        data_t val;
        *dest = *dest OP data[i];
    }
    return "消除for循环中通过使用方法调用获取指针:combine3";
}

