/*Created by lihux @20170814 06:46*/
//Create abstract data type for vector

typedef long data_t;

typedef struct{
    long len;
    data_t *data;
} vec_rec, *vec_ptr;

vec_ptr new_vec(long len);
