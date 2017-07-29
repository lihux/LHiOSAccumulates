	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_absdiff
	.p2align	4, 0x90
_absdiff:                               ## @absdiff
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
	cmpq	-16(%rbp), %rsi
	jge	LBB0_2
## BB#1:
	movq	-16(%rbp), %rax
	subq	-8(%rbp), %rax
	movq	%rax, -24(%rbp)
	jmp	LBB0_3
LBB0_2:
	movq	-8(%rbp), %rax
	subq	-16(%rbp), %rax
	movq	%rax, -24(%rbp)
LBB0_3:
	movq	-24(%rbp), %rax
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
