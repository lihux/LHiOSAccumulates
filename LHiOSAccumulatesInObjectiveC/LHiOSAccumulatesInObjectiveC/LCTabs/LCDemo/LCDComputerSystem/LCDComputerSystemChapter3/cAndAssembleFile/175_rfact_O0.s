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
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	cmpq	$1, -8(%rbp)
	jg	LBB0_2
## BB#1:
	movq	$1, -16(%rbp)
	jmp	LBB0_3
LBB0_2:
	movq	-8(%rbp), %rax
	movq	-8(%rbp), %rcx
	subq	$1, %rcx
	movq	%rcx, %rdi
	movq	%rax, -24(%rbp)         ## 8-byte Spill
	callq	_rfact
	movq	-24(%rbp), %rcx         ## 8-byte Reload
	imulq	%rax, %rcx
	movq	%rcx, -16(%rbp)
LBB0_3:
	movq	-16(%rbp), %rax
	addq	$32, %rsp
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
