	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_call_proc
	.p2align	4, 0x90
_call_proc:                             ## @call_proc
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
	subq	$16, %rsp
	leaq	-8(%rbp), %rsi
	leaq	-12(%rbp), %rcx
	movq	$1, -8(%rbp)
	movl	$2, -12(%rbp)
	movq	-8(%rbp), %rdi
	movl	-12(%rbp), %edx
	callq	_proc
	movq	-8(%rbp), %rcx
	movslq	-12(%rbp), %rsi
	addq	%rsi, %rcx
	movq	%rcx, %rax
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
