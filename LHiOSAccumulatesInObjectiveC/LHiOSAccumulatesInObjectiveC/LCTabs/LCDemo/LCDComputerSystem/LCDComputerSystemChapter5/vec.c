/*Created by lihux @20170814 06:46*/

#include "vec.h"

#include <stdlib.h>
#include <stdio.h>

//新建一个长度为len的向量集合
vec_ptr new_vec(long len) {
    static int i = 0;
    vec_ptr result = (vec_ptr)malloc(sizeof(vec_rec));
    data_t *data = NULL;
    if (result == NULL) {
        return NULL;
    }
    if (len > 0) {
        data = (data_t *)calloc(len, sizeof(data_t));
        if (!data) {
            free((void *)result);
            return NULL;
        }
        result->len = len;
        for (int j = 0; j < len; j++) {
            data[j] = (i++ % 2) + 1;
            printf("赋值：%lf", data[j]);
        }
    }
    result->data = data;
    return result;
}

//获取一个vector element,存入dest
int get_vec_element(vec_ptr v, long index, data_t *dest) {
    if (index < 0 || index >= v->len) {
        return 0;
    }
    *dest = v->data[index];
    return 1;
}

//返回向量长度
long vec_length(vec_ptr v) {
    return v->len;
}
