	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_add
	.p2align	4, 0x90
_add:                                   ## @add
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
	movl	%edi, -4(%rbp)
	movl	$2, -8(%rbp)
	movl	-4(%rbp), %edi
	addl	-8(%rbp), %edi
	movl	%edi, -12(%rbp)
	movl	-4(%rbp), %edi
	movl	-8(%rbp), %eax
	shll	$1, %eax
	addl	%eax, %edi
	movl	%edi, -16(%rbp)
	movl	-16(%rbp), %eax
	movl	%eax, %edi
	addl	$1, %edi
	movl	%edi, -16(%rbp)
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
