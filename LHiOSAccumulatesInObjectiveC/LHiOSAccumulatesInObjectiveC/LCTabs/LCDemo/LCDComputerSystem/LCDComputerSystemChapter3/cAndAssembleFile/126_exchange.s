	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_exchange
	.p2align	4, 0x90
_exchange:                              ## @exchange
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
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rsi
	movq	(%rsi), %rsi
	movq	%rsi, -24(%rbp)
	movq	-16(%rbp), %rsi
	movq	-8(%rbp), %rdi
	movq	%rsi, (%rdi)
	movq	-24(%rbp), %rax
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
