#define N 16
typedef int fix_matrix[N][N];

/*计算一个矩阵的内积[i,k] */
int fix_prod_ele (fix_matrix A, fix_matrix B, long i, long k) {
    long j;
    int result = 0;
    for (j = 0; j < N; j ++) {
        result += A[i][j] * B[j][k];
    }
    return result;
}
