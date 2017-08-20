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
	pushq	%rbx
	pushq	%rax
Ltmp3:
	.cfi_offset %rbx, -40
Ltmp4:
	.cfi_offset %r14, -32
Ltmp5:
	.cfi_offset %r15, -24
	movq	%rsi, %r14
	movq	%rdi, %r15
	movq	$1, (%r14)
	callq	_vec_length
	movq	%rax, %rbx
	movq	%r15, %rdi
	callq	_get_vec_start
	testq	%rbx, %rbx
	jle	LBB0_6
## BB#1:
	movq	(%r14), %rcx
	leaq	-1(%rbx), %rdx
	movq	%rbx, %rdi
	xorl	%esi, %esi
	andq	$3, %rdi
	je	LBB0_3
	.p2align	4, 0x90
LBB0_2:                                 ## =>This Inner Loop Header: Depth=1
	imulq	(%rax,%rsi,8), %rcx
	movq	%rcx, (%r14)
	incq	%rsi
	cmpq	%rsi, %rdi
	jne	LBB0_2
LBB0_3:
	cmpq	$3, %rdx
	jb	LBB0_6
## BB#4:
	subq	%rsi, %rbx
	leaq	24(%rax,%rsi,8), %rax
	.p2align	4, 0x90
LBB0_5:                                 ## =>This Inner Loop Header: Depth=1
	imulq	-24(%rax), %rcx
	movq	%rcx, (%r14)
	imulq	-16(%rax), %rcx
	movq	%rcx, (%r14)
	imulq	-8(%rax), %rcx
	movq	%rcx, (%r14)
	imulq	(%rax), %rcx
	movq	%rcx, (%r14)
	addq	$32, %rax
	addq	$-4, %rbx
	jne	LBB0_5
LBB0_6:
	addq	$8, %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
