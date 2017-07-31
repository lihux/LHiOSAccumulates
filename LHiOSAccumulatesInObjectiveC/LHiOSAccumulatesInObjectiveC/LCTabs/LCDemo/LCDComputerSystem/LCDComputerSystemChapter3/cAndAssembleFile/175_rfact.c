//发现只有当强制不优化的时候，汇编代码才会真正的实现递归调用，否则会优化为一个简单的Inner Loop。
long rfact(long n) {
    long result;
    if (n <= 1) {
        result = 1;
    } else {
        result = n * rfact(n - 1);
    }
    return result;
}
