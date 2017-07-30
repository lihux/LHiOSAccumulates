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
	cmpq	$103, %rsi
	je	LBB0_5
## BB#1:
	cmpq	$102, %rsi
	je	LBB0_4
## BB#2:
	cmpq	$100, %rsi
	jne	LBB0_6
## BB#3:
	imulq	$13, %rdi, %rdi
	jmp	LBB0_7
LBB0_5:
	addq	$11, %rdi
	jmp	LBB0_7
LBB0_4:
	addq	$21, %rdi
	jmp	LBB0_7
LBB0_6:
	orq	$2, %rsi
	imulq	%rdi, %rdi
	xorl	%eax, %eax
	cmpq	$106, %rsi
	cmovneq	%rax, %rdi
LBB0_7:
	movq	%rdi, (%rdx)
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
