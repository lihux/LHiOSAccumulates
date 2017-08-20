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
	movq	%rax, %r12
	movq	%r15, %rdi
	callq	_get_vec_start
	cmpq	$2, %r12
	jl	LBB0_8
## BB#1:
	leaq	-1(%r12), %r9
	movq	(%rax), %rsi
	leaq	-2(%r12), %r8
	movq	%r9, %rbx
	andq	$3, %rbx
	je	LBB0_2
## BB#3:
	movl	$1, %ecx
	xorl	%edi, %edi
	.p2align	4, 0x90
LBB0_4:                                 ## =>This Inner Loop Header: Depth=1
	imulq	%rsi, %rcx
	movq	8(%rax,%rdi,8), %rsi
	incq	%rdi
	imulq	%rsi, %rcx
	cmpq	%rdi, %rbx
	jne	LBB0_4
	jmp	LBB0_5
LBB0_8:
	movl	$1, %ecx
	cmpq	$1, %r12
	jne	LBB0_16
## BB#9:
	xorl	%r9d, %r9d
	jmp	LBB0_10
LBB0_2:
	xorl	%edi, %edi
	movl	$1, %ecx
LBB0_5:
	cmpq	$3, %r8
	jb	LBB0_10
## BB#6:
	leaq	-1(%r12), %rbx
	subq	%rdi, %rbx
	leaq	32(%rax,%rdi,8), %rdi
	.p2align	4, 0x90
LBB0_7:                                 ## =>This Inner Loop Header: Depth=1
	imulq	%rcx, %rsi
	movq	-24(%rdi), %rdx
	movq	-16(%rdi), %rcx
	imulq	%rdx, %rsi
	imulq	%rcx, %rdx
	imulq	%rsi, %rdx
	movq	-8(%rdi), %rsi
	imulq	%rsi, %rcx
	imulq	%rsi, %rcx
	imulq	%rdx, %rcx
	movq	(%rdi), %rsi
	imulq	%rsi, %rcx
	addq	$32, %rdi
	addq	$-4, %rbx
	jne	LBB0_7
LBB0_10:
	leal	1(%r12), %edi
	leaq	1(%r9), %rdx
	subl	%edx, %edi
	movq	%r12, %rsi
	subq	%rdx, %rsi
	andq	$7, %rdi
	je	LBB0_13
## BB#11:
	negq	%rdi
	.p2align	4, 0x90
LBB0_12:                                ## =>This Inner Loop Header: Depth=1
	imulq	(%rax,%r9,8), %rcx
	incq	%r9
	incq	%rdi
	jne	LBB0_12
LBB0_13:
	cmpq	$7, %rsi
	jb	LBB0_16
## BB#14:
	subq	%r9, %r12
	leaq	56(%rax,%r9,8), %rax
	.p2align	4, 0x90
LBB0_15:                                ## =>This Inner Loop Header: Depth=1
	imulq	-56(%rax), %rcx
	imulq	-48(%rax), %rcx
	imulq	-40(%rax), %rcx
	imulq	-32(%rax), %rcx
	imulq	-24(%rax), %rcx
	imulq	-16(%rax), %rcx
	imulq	-8(%rax), %rcx
	imulq	(%rax), %rcx
	addq	$64, %rax
	addq	$-8, %r12
	jne	LBB0_15
LBB0_16:
	movq	%rcx, (%r14)
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
