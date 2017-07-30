	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_switch_eg
	.p2align	4, 0x90
_switch_eg:                             ## @switch_eg
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
	addq	$-100, %rsi
	cmpq	$6, %rsi
	ja	LBB0_5
## BB#1:
	leaq	LJTI0_0(%rip), %rax
	movslq	(%rax,%rsi,4), %rcx
	addq	%rax, %rcx
	jmpq	*%rcx
LBB0_4:
	imulq	%rdi, %rdi
	jmp	LBB0_6
LBB0_5:
	xorl	%edi, %edi
	jmp	LBB0_6
LBB0_3:
	addq	$11, %rdi
	jmp	LBB0_6
LBB0_2:
	imulq	$13, %rdi, %rdi
LBB0_6:
	movq	%rdi, (%rdx)
	popq	%rbp
	retq
	.cfi_endproc
	.p2align	2, 0x90
	.data_region jt32
L0_0_set_2 = LBB0_2-LJTI0_0
L0_0_set_5 = LBB0_5-LJTI0_0
L0_0_set_3 = LBB0_3-LJTI0_0
L0_0_set_6 = LBB0_6-LJTI0_0
L0_0_set_4 = LBB0_4-LJTI0_0
LJTI0_0:
	.long	L0_0_set_2
	.long	L0_0_set_5
	.long	L0_0_set_3
	.long	L0_0_set_6
	.long	L0_0_set_4
	.long	L0_0_set_5
	.long	L0_0_set_4
	.end_data_region


.subsections_via_symbols
