	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_rfact
	.p2align	4, 0x90
_rfact:                                 ## @rfact
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
	movl	$1, %eax
	cmpq	$2, %rdi
	jl	LBB0_2
	.p2align	4, 0x90
LBB0_1:                                 ## =>This Inner Loop Header: Depth=1
	imulq	%rdi, %rax
	cmpq	$2, %rdi
	leaq	-1(%rdi), %rdi
	jg	LBB0_1
LBB0_2:
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
