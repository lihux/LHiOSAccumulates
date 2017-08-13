/*Created by lihux @20170814 06:46*/

#include "vec.h"

#include <stdlib.h>

//Create vector of specified length
vec_ptr new_vec(long len) {
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
    }
    result->data = data;
    return result;
}
