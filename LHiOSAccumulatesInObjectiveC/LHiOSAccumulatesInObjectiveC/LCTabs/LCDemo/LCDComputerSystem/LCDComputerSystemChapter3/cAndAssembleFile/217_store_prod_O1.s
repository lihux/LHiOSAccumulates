	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_store_prod
	.p2align	4, 0x90
_store_prod:                            ## @store_prod
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
	movslq	%esi, %rcx
	movslq	%edx, %rax
	imulq	%rcx
	movq	%rdx, 8(%rdi)
	movq	%rax, (%rdi)
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
