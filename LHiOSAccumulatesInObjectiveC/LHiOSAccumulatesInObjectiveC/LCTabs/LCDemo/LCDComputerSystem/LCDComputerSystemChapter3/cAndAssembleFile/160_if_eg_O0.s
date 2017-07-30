	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_if_eg
	.p2align	4, 0x90
_if_eg:                                 ## @if_eg
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
	movq	%rdx, -32(%rbp)
	cmpq	$100, -16(%rbp)
	jne	LBB0_2
## BB#1:
	imulq	$13, -32(%rbp), %rax
	movq	%rax, -32(%rbp)
	jmp	LBB0_13
LBB0_2:
	cmpq	$102, -16(%rbp)
	jne	LBB0_4
## BB#3:
	movq	-32(%rbp), %rax
	addq	$10, %rax
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	addq	$11, %rax
	movq	%rax, -32(%rbp)
	jmp	LBB0_12
LBB0_4:
	cmpq	$103, -16(%rbp)
	jne	LBB0_6
## BB#5:
	movq	-32(%rbp), %rax
	addq	$11, %rax
	movq	%rax, -32(%rbp)
	jmp	LBB0_11
LBB0_6:
	cmpq	$104, -16(%rbp)
	je	LBB0_8
## BB#7:
	cmpq	$106, -16(%rbp)
	jne	LBB0_9
LBB0_8:
	movq	-32(%rbp), %rax
	imulq	-32(%rbp), %rax
	movq	%rax, -32(%rbp)
	jmp	LBB0_10
LBB0_9:
	movq	$0, -32(%rbp)
LBB0_10:
	jmp	LBB0_11
LBB0_11:
	jmp	LBB0_12
LBB0_12:
	jmp	LBB0_13
LBB0_13:
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rcx
	movq	%rax, (%rcx)
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
