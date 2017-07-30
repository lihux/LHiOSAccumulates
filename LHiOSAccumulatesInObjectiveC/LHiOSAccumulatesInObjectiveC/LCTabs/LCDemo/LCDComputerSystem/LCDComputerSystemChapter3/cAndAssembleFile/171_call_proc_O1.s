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
	movq	$1, -16(%rbp)
	movl	$2, -4(%rbp)
	leaq	-16(%rbp), %rsi
	leaq	-4(%rbp), %rcx
	movl	$1, %edi
	movl	$2, %edx
	callq	_proc
	movslq	-4(%rbp), %rax
	addq	-16(%rbp), %rax
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
