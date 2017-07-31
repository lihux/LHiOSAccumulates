	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_var_ele
	.p2align	4, 0x90
_var_ele:                               ## @var_ele
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
	movq	%rcx, -32(%rbp)
	movq	-8(%rbp), %rcx
	movq	-32(%rbp), %rdx
	movq	-24(%rbp), %rsi
	movq	-16(%rbp), %rdi
	imulq	%rcx, %rsi
	shlq	$2, %rsi
	addq	%rsi, %rdi
	movl	(%rdi,%rdx,4), %eax
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
