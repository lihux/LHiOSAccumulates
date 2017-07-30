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
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-8(%rbp), %rdx
	movq	%rdx, -32(%rbp)
	movq	-16(%rbp), %rdx
	addq	$-100, %rdx
	movq	%rdx, %rsi
	subq	$6, %rsi
	movq	%rdx, -40(%rbp)         ## 8-byte Spill
	movq	%rsi, -48(%rbp)         ## 8-byte Spill
	ja	LBB0_5
## BB#7:
	leaq	LJTI0_0(%rip), %rax
	movq	-40(%rbp), %rcx         ## 8-byte Reload
	movslq	(%rax,%rcx,4), %rdx
	addq	%rax, %rdx
	jmpq	*%rdx
LBB0_1:
	imulq	$13, -32(%rbp), %rax
	movq	%rax, -32(%rbp)
	jmp	LBB0_6
LBB0_2:
	movq	-32(%rbp), %rax
	addq	$11, %rax
	movq	%rax, -32(%rbp)
LBB0_3:
	jmp	LBB0_6
LBB0_4:
	movq	-32(%rbp), %rax
	imulq	-32(%rbp), %rax
	movq	%rax, -32(%rbp)
	jmp	LBB0_6
LBB0_5:
	movq	$0, -32(%rbp)
LBB0_6:
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rcx
	movq	%rax, (%rcx)
	popq	%rbp
	retq
	.cfi_endproc
	.p2align	2, 0x90
	.data_region jt32
L0_0_set_1 = LBB0_1-LJTI0_0
L0_0_set_5 = LBB0_5-LJTI0_0
L0_0_set_2 = LBB0_2-LJTI0_0
L0_0_set_3 = LBB0_3-LJTI0_0
L0_0_set_4 = LBB0_4-LJTI0_0
LJTI0_0:
	.long	L0_0_set_1
	.long	L0_0_set_5
	.long	L0_0_set_2
	.long	L0_0_set_3
	.long	L0_0_set_4
	.long	L0_0_set_5
	.long	L0_0_set_4
	.end_data_region


.subsections_via_symbols
