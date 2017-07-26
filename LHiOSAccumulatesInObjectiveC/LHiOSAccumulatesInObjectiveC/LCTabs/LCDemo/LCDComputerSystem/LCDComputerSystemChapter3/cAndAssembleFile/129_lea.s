	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_scale
	.p2align	4, 0x90
_scale:                                 ## @scale
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
	movq	%rdx, -24(%rbp)
	movq	-8(%rbp), %rdx
	movq	-16(%rbp), %rsi
	shlq	$2, %rsi
	addq	%rsi, %rdx
	imulq	$12, -24(%rbp), %rsi
	addq	%rsi, %rdx
	movq	%rdx, -32(%rbp)
	movq	-32(%rbp), %rax
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
