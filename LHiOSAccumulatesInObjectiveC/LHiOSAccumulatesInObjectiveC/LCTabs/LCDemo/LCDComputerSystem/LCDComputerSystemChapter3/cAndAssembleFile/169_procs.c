//在x86-64机器上:
//p1~p6 共6个参数会依次存入寄存器：%rdi, %rsi, %rdx, %rcx, %r8, %r9
//p7~p9 等大于六个以外的参数会直接push入栈中存储和传递

int proc0() {
    return 1;
}

long proc1(long p1) {
    long a = 1;
    return p1 + a * 2;
}

long proc2(long p1, int p2) {
    return p1 + p2;
}

long proc3(long p1, int p2, short p3) {
    return p1 + p2 + p3;
}

long proc4(long p1, int p2, short p3, char p4) {
    return p1 + p2 + p3* p4;
}

void proc5(long p1, int p2, short p3, char p4, long *p5) {
    *p5 = p1 + p2 + p3 - p4;
}

long proc6(long p1, int p2, short p3, char p4, long *p5, long p6) {
    *p5 = p1 + p2 + p3 - p4;
    return *p5 + p6;
}

long proc7(long p1, int p2, short p3, char p4, long *p5, long p6, long p7) {
    *p5 = p1 + p2 + p3 - p4;
    return *p5 + p6 + p7;
}

long proc8(long p1, int p2, short p3, char p4, long *p5, long p6, long p7, long p8) {
    *p5 = p1 + p2 + p3 - p4;
    return *p5 + p6 + p7 * p8;
}
void proc9(long p1, int p2, short p3, char p4, long *p5, long p6, long p7, long p8, long *p9) {
    *p5 = p1 + p2 + p3 - p4;
    *p9 = p6 * p7 * p8;
}
