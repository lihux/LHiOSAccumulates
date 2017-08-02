//以下代码由命令生成：llvm-gcc -O0 -S -o 202_vframe_O0/1.s 202_vframe.c
//c源码如下：
//long vframe(long n, long idx, long *q) {
//    long i;
//    long *p[n];
//    p[0] = &i;
//    for (i = 1; i < n; i ++) {
//        p[i] = q;
//    }
//    return *p[idx];
//}

.section    __TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_vframe
	.p2align	4, 0x90
#以下代码进入方法体vframe中
_vframe:                                ## @vframe
	.cfi_startproc
## BB#0:
#%rbp: bp == base pointer / frame pointer 基指针或者帧指针
    pushq    %rbp #保存调用者的基指针，为ret恢复做准备
Ltmp0:
	.cfi_def_cfa_offset 16
Ltmp1:
	.cfi_offset %rbp, -16
    movq    %rsp, %rbp #基指针指向当前栈顶所在的位置
Ltmp2:
	.cfi_def_cfa_register %rbp
    subq    $64, %rsp #分配64bytes的栈空间，也即能够保存8 个long值
    leaq    -40(%rbp), %rax #%rax存放指向栈顶- 40（5 long)的地方
    movq    ___stack_chk_guard@GOTPCREL(%rip), %rcx #插入金丝雀，防止栈访问溢出
    movq    (%rcx), %rcx
	movq	%rcx, -8(%rbp) #金丝雀canary保存，后边校验？
    #入参使用寄存器的顺序是：rdi rsi rdx rcx r8 r9，所以这里推测：rdi:n, rsi:idx, rdx:&q
    movq    %rdi, -16(%rbp) # save n in stack
    movq    %rsi, -24(%rbp) #save idx in stack
    movq    %rdx, -32(%rbp) #save &q in stack
    movq    -16(%rbp), %rcx #n >> rcx
    movq    %rsp, %rdx # 栈顶指针值 >> rdx
	movq	%rdx, -48(%rbp) # 栈顶指针值存入stack
    #变长变量，所以要分配变长的堆栈：
    leaq    15(,%rcx,8), %rcx #8n + 15 >> rcx, 额外的加15是为了保证后面的4位对齐后仍有足够的空间可供使用
    andq    $-16, %rcx #-16 = 0xffff...fff0，因此该操作是将rcx存的值低4位对其（4字节）
	movq	%rsp, %rdx
    subq    %rcx, %rdx
	movq	%rdx, %rsp #分配对齐低4字节的栈空间
	movq	%rax, (%rdx) #%rax存放指向栈顶- 40（5 long)的地方，rdx也即栈顶存i所在的栈位置，好绕...
    movq    $1, -40(%rbp) #将i = 1入栈
	movq	%rdx, -56(%rbp)         ## 8-byte Spill
LBB0_1:                                 ## =>This Inner Loop Header: Depth=1
	movq	-40(%rbp), %rax
	cmpq	-16(%rbp), %rax
	jge	LBB0_4
## BB#2:                                ##   in Loop: Header=BB0_1 Depth=1
	movq	-32(%rbp), %rax
	movq	-40(%rbp), %rcx
	movq	-56(%rbp), %rdx         ## 8-byte Reload
	movq	%rax, (%rdx,%rcx,8)
## BB#3:                                ##   in Loop: Header=BB0_1 Depth=1
	movq	-40(%rbp), %rax
	addq	$1, %rax
	movq	%rax, -40(%rbp)
	jmp	LBB0_1
LBB0_4:
	movq	-24(%rbp), %rax
	movq	-56(%rbp), %rcx         ## 8-byte Reload
	movq	(%rcx,%rax,8), %rax
	movq	(%rax), %rax
	movq	-48(%rbp), %rdx
	movq	%rdx, %rsp
	movq	___stack_chk_guard@GOTPCREL(%rip), %rdx
	movq	(%rdx), %rdx
	movq	-8(%rbp), %rsi
	cmpq	%rsi, %rdx
	movq	%rax, -64(%rbp)         ## 8-byte Spill
	jne	LBB0_6
## BB#5:
	movq	-64(%rbp), %rax         ## 8-byte Reload
	movq	%rbp, %rsp
	popq	%rbp
	retq
LBB0_6:
	callq	___stack_chk_fail
	.cfi_endproc


.subsections_via_symbols
