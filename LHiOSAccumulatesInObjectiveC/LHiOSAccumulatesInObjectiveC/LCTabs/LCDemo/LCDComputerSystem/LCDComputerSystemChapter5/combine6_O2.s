	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_combine1
	.p2align	4, 0x90
_combine1:                              ## @combine1
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp0:
	.cfi_def_cfa_offset 16
Ltmp1:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp2:
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r12
	pushq	%rbx
Ltmp3:
	.cfi_offset %rbx, -48
Ltmp4:
	.cfi_offset %r12, -40
Ltmp5:
	.cfi_offset %r14, -32
Ltmp6:
	.cfi_offset %r15, -24
	movq	%rsi, %r14
	movq	%rdi, %r15
	callq	_vec_length
	movq	%rax, %rbx
	leaq	-1(%rbx), %r12
	movq	%r15, %rdi
	callq	_get_vec_start
	cmpq	$2, %rbx
	jl	LBB0_1
## BB#2:
	leaq	-2(%rbx), %rsi
	movl	%esi, %edi
	shrl	%edi
	incl	%edi
	andq	$3, %rdi
	je	LBB0_3
## BB#4:
	negq	%rdi
	movl	$1, %ecx
	xorl	%edx, %edx
	.p2align	4, 0x90
LBB0_5:                                 ## =>This Inner Loop Header: Depth=1
	imulq	(%rax,%rdx,8), %rcx
	imulq	8(%rax,%rdx,8), %rcx
	addq	$2, %rdx
	incq	%rdi
	jne	LBB0_5
	jmp	LBB0_6
LBB0_1:
	xorl	%edx, %edx
	movl	$1, %ecx
	jmp	LBB0_8
LBB0_3:
	xorl	%edx, %edx
	movl	$1, %ecx
LBB0_6:
	cmpq	$6, %rsi
	jb	LBB0_7
	.p2align	4, 0x90
LBB0_16:                                ## =>This Inner Loop Header: Depth=1
	imulq	(%rax,%rdx,8), %rcx
	movq	%rdx, %rsi
	orq	$1, %rsi
	imulq	(%rax,%rsi,8), %rcx
	leaq	2(%rdx), %rsi
	imulq	16(%rax,%rdx,8), %rcx
	orq	$1, %rsi
	imulq	(%rax,%rsi,8), %rcx
	imulq	32(%rax,%rdx,8), %rcx
	leaq	4(%rdx), %rsi
	orq	$1, %rsi
	imulq	(%rax,%rsi,8), %rcx
	imulq	48(%rax,%rdx,8), %rcx
	leaq	6(%rdx), %rsi
	orq	$1, %rsi
	imulq	(%rax,%rsi,8), %rcx
	addq	$8, %rdx
	cmpq	%r12, %rdx
	jl	LBB0_16
LBB0_7:
	movq	%rbx, %rdx
	andq	$-2, %rdx
LBB0_8:
	cmpq	%rdx, %rbx
	jle	LBB0_15
## BB#9:
	movl	%ebx, %esi
	subl	%edx, %esi
	subq	%rdx, %r12
	andq	$7, %rsi
	je	LBB0_12
## BB#10:
	negq	%rsi
	.p2align	4, 0x90
LBB0_11:                                ## =>This Inner Loop Header: Depth=1
	imulq	(%rax,%rdx,8), %rcx
	incq	%rdx
	incq	%rsi
	jne	LBB0_11
LBB0_12:
	cmpq	$7, %r12
	jb	LBB0_15
## BB#13:
	subq	%rdx, %rbx
	leaq	56(%rax,%rdx,8), %rax
	.p2align	4, 0x90
LBB0_14:                                ## =>This Inner Loop Header: Depth=1
	imulq	-56(%rax), %rcx
	imulq	-48(%rax), %rcx
	imulq	-40(%rax), %rcx
	imulq	-32(%rax), %rcx
	imulq	-24(%rax), %rcx
	imulq	-16(%rax), %rcx
	imulq	-8(%rax), %rcx
	imulq	(%rax), %rcx
	addq	$64, %rax
	addq	$-8, %rbx
	jne	LBB0_14
LBB0_15:
	movq	%rcx, (%r14)
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
