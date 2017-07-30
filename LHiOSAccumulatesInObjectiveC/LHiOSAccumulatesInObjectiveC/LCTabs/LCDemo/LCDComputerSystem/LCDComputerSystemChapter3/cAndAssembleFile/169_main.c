int proc0();
long proc1(long p1);
long proc2(long p1, int p2);
long proc3(long p1, int p2, short p3);
long proc4(long p1, int p2, short p3, char p4);
void proc5(long p1, int p2, short p3, char p4, long *p5);
long proc6(long p1, int p2, short p3, char p4, long *p5, long p6);
long proc7(long p1, int p2, short p3, char p4, long *p5, long p6, long p7);
long proc8(long p1, int p2, short p3, char p4, long *p5, long p6, long p7, long p8);
void proc9(long p1, int p2, short p3, char p4, long *p5, long p6, long p7, long p8, long *p9);

//在x86-64机器上:约定（和协议类似）传参细节
//p1~p6 共6个参数会依次存入寄存器：%rdi, %rsi, %rdx, %rcx, %r8, %r9
//p7~p9 等大于六个以外的参数会直接push入栈中存储和传递

//在x86-64机器上:约定（和协议类似）被调用者proc*()必须要保存调用者main()的寄存器值：
//%rbx, %rbp, %r12~%r15,
//要么你不使用，要么你使用前要入栈，使用后要pop恢复

int main () {
    long p1 = 1;
    int p2 = 2;
    short p3 = 3;
    char p4 = 4;
    long *p5 = 5;
    long p6 = 6, p7 = 7, p8 = 8;
    long *p9 = 9;
    int a = 0;
    a += proc0();
    long b = 2;
    b *= proc1(p1);
    b *= proc2(p1, p2);
    b *= proc3(p1, p2, p3);
    b *= proc4(p1, p2, p3, p4);
    proc5(p1, p2, p3, p4, p5);
    b += proc6(p1, p2, p3, p4, p5, p6);
    b += proc7(p1, p2, p3, p4, p5, p6, p7);
    b += proc8(p1, p2, p3, p4, p5, p6, p7, p8);
    proc9(p1, p2, p3, p4, p5, p6, p7, p8, p9);
    return b;
}
