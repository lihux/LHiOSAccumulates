/*Created by lihux @20170814 06:46*/
//Create abstract data type for vector

typedef long data_t;

#ifdef CSAPP_CH5_ADD
    #define INDENT 0
    #define OP +
#else
    #define INDENT 1
    #define OP *
#fi

typedef struct{
    long len;
    data_t *data;
} vec_rec, *vec_ptr;

//新建一个长度为len的向量集合
vec_ptr new_vec(long len);

//获取一个vector element,存入dest,返回1表示成功，0表示失败
int get_vec_element(vec_ptr v, long index, data_t *dest);

//返回向量长度
long vec_length(vec_ptr v);
