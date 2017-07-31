	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_P
	.p2align	4, 0x90
_P:                                     ## @P
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
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-16(%rbp), %rdi
	callq	_Q
	movq	%rax, -24(%rbp)
	movq	-8(%rbp), %rdi
	callq	_Q
	movq	%rax, -32(%rbp)
	movq	-24(%rbp), %rax
	addq	-32(%rbp), %rax
	addq	$32, %rsp
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
