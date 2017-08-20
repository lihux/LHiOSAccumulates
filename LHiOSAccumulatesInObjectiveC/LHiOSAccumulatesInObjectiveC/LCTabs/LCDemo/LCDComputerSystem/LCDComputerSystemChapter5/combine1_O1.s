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
	subq	$16, %rsp
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
	movq	$0, (%r14)
	callq	_vec_length
	testq	%rax, %rax
	jle	LBB0_3
## BB#1:
	xorl	%ebx, %ebx
	leaq	-40(%rbp), %r12
	.p2align	4, 0x90
LBB0_2:                                 ## =>This Inner Loop Header: Depth=1
	movq	%r15, %rdi
	movq	%rbx, %rsi
	movq	%r12, %rdx
	callq	_get_vec_element
	movq	-40(%rbp), %rax
	addq	%rax, (%r14)
	incq	%rbx
	movq	%r15, %rdi
	callq	_vec_length
	cmpq	%rax, %rbx
	jl	LBB0_2
LBB0_3:
	addq	$16, %rsp
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
