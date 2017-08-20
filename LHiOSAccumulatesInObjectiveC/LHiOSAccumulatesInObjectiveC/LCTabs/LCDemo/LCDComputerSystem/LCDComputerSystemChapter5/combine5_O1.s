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
	callq	_vec_length
	movq	%rax, %rbx
	movq	%r15, %rdi
	callq	_get_vec_start
	cmpq	$2, %rbx
	jl	LBB0_3
## BB#1:
	leaq	-1(%rbx), %rdx
	leaq	8(%rax), %rsi
	movl	$1, %ecx
	movq	%rdx, %rdi
	.p2align	4, 0x90
LBB0_2:                                 ## =>This Inner Loop Header: Depth=1
	imulq	-8(%rsi), %rcx
	imulq	(%rsi), %rcx
	addq	$8, %rsi
	decq	%rdi
	jne	LBB0_2
	jmp	LBB0_5
LBB0_3:
	movl	$1, %ecx
	cmpq	$1, %rbx
	jne	LBB0_7
## BB#4:
	xorl	%edx, %edx
LBB0_5:
	leaq	(%rax,%rdx,8), %rax
	incq	%rbx
	incq	%rdx
	subq	%rdx, %rbx
	.p2align	4, 0x90
LBB0_6:                                 ## =>This Inner Loop Header: Depth=1
	imulq	(%rax), %rcx
	addq	$8, %rax
	decq	%rbx
	jne	LBB0_6
LBB0_7:
	movq	%rcx, (%r14)
	addq	$8, %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
