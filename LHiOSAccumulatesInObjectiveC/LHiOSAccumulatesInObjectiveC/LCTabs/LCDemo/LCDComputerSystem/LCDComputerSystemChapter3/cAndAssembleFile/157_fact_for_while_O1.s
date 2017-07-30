	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_fact_for_while
	.p2align	4, 0x90
_fact_for_while:                        ## @fact_for_while
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
	cmpq	$2, %rdi
	jge	LBB0_2
## BB#1:
	movl	$1, %eax
	popq	%rbp
	retq
LBB0_2:
	movl	$1, %ecx
	movl	$1, %eax
	.p2align	4, 0x90
LBB0_3:                                 ## =>This Inner Loop Header: Depth=1
	incq	%rcx
	imulq	%rcx, %rax
	cmpq	%rcx, %rdi
	jne	LBB0_3
## BB#4:
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
